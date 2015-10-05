module GOPF_DIV (
	//input
	clk,
	rst_b,
	start,
	dividend,
	divisor,
	
	//output
	quotient_out,
	remainder_out,
	div_done,
	
	//output to MAC_ARRAY
	mul1_o_out,
	mul2_o_out,
	mul3_o_out,
	mul4_o_out,
	mul5_o_out,
	mul6_o_out,
	mul7_o_out,
	mul8_o_out,
	mul9_o_out,
	mul_t_out,	
	mul1_add_out,
	mul2_add_out,
	mul3_add_out,
	mul4_add_out,
	mul5_add_out,
	mul6_add_out,
	mul7_add_out,
	mul8_add_out,
	mul9_add_out,

	//output to INV_GENERATOR
	inv_out,
	inv_en,
	inv_trg,
	//input from MUL_ARRAY
	mul1_r_dat,
	mul2_r_dat,
	mul3_r_dat,
	mul4_r_dat,
	mul5_r_dat,
	mul6_r_dat,
	mul7_r_dat,
	mul8_r_dat,
	mul9_r_dat,
	inv_r_dat
);

parameter m = 144;

//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
input wire 				clk, rst_b;
input wire 				start;
input wire 	[0:m] 		dividend;
input wire 	[0:m-1]		divisor;

output wire [0:m-1] 	quotient_out;
output wire [0:m-1]		remainder_out;
output reg 				div_done;

output wire [0:15]		mul1_o_out,	mul2_o_out,	mul3_o_out,
						mul4_o_out,	mul5_o_out,	mul6_o_out,
						mul7_o_out,	mul8_o_out,	mul9_o_out;
						
output wire [0:15]		mul_t_out;

output wire [0:15]		mul1_add_out,	mul2_add_out,	mul3_add_out,
						mul4_add_out,	mul5_add_out,	mul6_add_out,
						mul7_add_out,	mul8_add_out,	mul9_add_out;

output wire [0:15]		inv_out;
output wire 			inv_en, inv_trg;

input wire 	[0:15]		mul1_r_dat,	mul2_r_dat,	mul3_r_dat,
						mul4_r_dat,	mul5_r_dat,	mul6_r_dat,
						mul7_r_dat,	mul8_r_dat,	mul9_r_dat;
						
input wire 	[0:15]		inv_r_dat;						
						
//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 	DATA_PRE  		= 0, //do nothing, then get prepared to DATA_MUL1
			DATA_DEGREE  	= 1, //shift divisor to line up with dividend
			DATA_LDCOEFF 	= 2, //confirm the leading coefficient of divisor [bn^-1*an]
			DATA_SHIFT		= 3,
			DATA_MAC  		= 4; //accumulator
					

//----------------------------------------------------------
//1st always block, sequential state transition
//----------------------------------------------------------
		reg    [2:0]   NextState , CurrentState;
		always @ (posedge clk or negedge rst_b)
			  if (!rst_b)            
					CurrentState <= DATA_PRE;        
			  else                  
					CurrentState <= NextState; 
					
					
//----------------------------------------------------------
//  signal Declaration
//	the signal start, overflow, finish control the end of montgomery
//---------------------------------------------------------- 
		reg [4:0]		counter;
		reg				dividend_degree_done, divisor_degree_done,
						ldcoeff_done, quotient_done, remainder_done, first_time;
//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------		
		always @ (CurrentState or start or counter or 
				ldcoeff_done or quotient_done or remainder_done 
				or dividend_degree_done or divisor_degree_done or div_done)
			begin
               case (CurrentState)
					DATA_PRE:	begin
									if (start)
										NextState = DATA_DEGREE;
									else
										NextState = DATA_PRE;
								end	
								
					DATA_DEGREE:	begin	
									if (dividend_degree_done && divisor_degree_done)
										NextState = DATA_LDCOEFF;
									else	
										NextState = DATA_DEGREE;
								end


					
					DATA_LDCOEFF: begin
									if (div_done)
										NextState = DATA_PRE;
									else if (ldcoeff_done)
										NextState = DATA_SHIFT;
									else
										NextState = DATA_LDCOEFF;
					end

					DATA_SHIFT: begin
							NextState = DATA_MAC;
					end
					
					DATA_MAC: 	begin 
									// it takes 1 cycles to do one BF_MUL
									if (counter == 5'd1)
										NextState = DATA_DEGREE;
									else
										NextState = DATA_MAC;
								end
					
					default: NextState = DATA_PRE;
				endcase
		end	
		
//----------------------------------------------------------
//  signal Declaration
//----------------------------------------------------------	
reg [0:m]	dividend_reg;
reg [0:m-1]	divisor_reg;

reg [0:m-1] quotient_reg;
reg	[0:m-1]	remainder_reg;

reg [0:m]	dividend_tmp_reg;
reg [0:m-1]	divisor_tmp_reg;
reg [0:m-1] inv_tmp_reg;

reg [0:m-1] mul_o_in_reg;
reg [0:15]	mul_t_in_reg;
reg [0:m-1] mul_add_in_reg;

reg [3:0] 	dividend_cnt, divisor_cnt;	

reg	[0:15]	inv_in_reg, inv_r_reg;
reg			inv_en_reg, inv_trg_reg;

reg 		dividend_degree_high, dividend_degree_mid, dividend_degree_low;
reg 		divisor_degree_high, divisor_degree_mid, divisor_degree_low;
//----------------------------------------------------------
//3rd always block, the sequential FSM output
//----------------------------------------------------------			
always @ (posedge clk or negedge rst_b) begin
			if (!rst_b) begin
				dividend_reg 	<= 145'b0;
				divisor_reg 	<= 144'b0;
				dividend_tmp_reg <= 145'd0;
				divisor_tmp_reg <= 144'd0;
				quotient_reg	<= 144'b0;

				
				inv_in_reg		<= 0;
				inv_r_reg		<= 0;
				inv_en_reg		<= 0;
				inv_trg_reg 	<= 0;
				dividend_cnt 	<= 0;
				divisor_cnt		<= 0;
				counter			<= 0;
				div_done		<= 0;
				dividend_degree_done <= 0;
				divisor_degree_done <= 0;
				dividend_degree_high <= 0;
				dividend_degree_mid <= 0;
				dividend_degree_low <= 0;
				divisor_degree_high <= 0;
				divisor_degree_mid <= 0;
				divisor_degree_low <= 0;

				remainder_done	<= 0;
				quotient_done	<= 0;
				ldcoeff_done    <= 0;
				first_time <= 1;
			end
			
			else begin
				case (CurrentState)
					DATA_PRE: begin	
						dividend_reg 	<= dividend;
						divisor_reg 	<= divisor;
						dividend_tmp_reg <= dividend;
						divisor_tmp_reg <= divisor;
						quotient_reg	<= 144'b0;
						
						dividend_cnt 	<= 4'd0; //rst degree
						divisor_cnt		<= 4'd0; //rst degree
						counter			<= 0;
						div_done 		<= 0;
						dividend_degree_done <= 0;
						divisor_degree_done <= 0;
						dividend_degree_high <= 0;
						dividend_degree_mid <= 0;
						dividend_degree_low <= 0;
						divisor_degree_high <= 0;
						divisor_degree_mid <= 0;
						divisor_degree_low <= 0;

						remainder_done	<= 0;
						quotient_done	<= 0;
						ldcoeff_done    <= 0;
						first_time 		<= 1;
					end
					
					DATA_DEGREE: begin //calculate degree of dividend and divisor
						remainder_done	<= 0;
						quotient_done	<= 0;
						counter 		<= 0;
						//assess dividend degree
						if (dividend_tmp_reg[m] == 1'b1) begin
							dividend_cnt <= 9;
							dividend_degree_done <= 1'b1;
						end	
						else if (dividend_tmp_reg[96:m-1] != 48'b0) begin
							dividend_degree_high <= 1;
							dividend_degree_mid <= 0;
							dividend_degree_low <= 0;
							dividend_degree_done <= 1;
						end
						else if (dividend_tmp_reg[48:95] != 48'b0) begin
							dividend_degree_high <= 0;
							dividend_degree_mid <= 1;
							dividend_degree_low <= 0;
							dividend_degree_done <= 1;
						end
						else if (dividend_tmp_reg[0:47] != 48'b0) begin
							dividend_degree_high <= 0;
							dividend_degree_mid <= 0;
							dividend_degree_low <= 1;
							dividend_degree_done <= 1;
						end
						else begin // dividend is zero
							dividend_cnt <= 4'd15;
							dividend_degree_done <= 1'b1;
						end

						case ({dividend_degree_low,dividend_degree_mid,dividend_degree_high})
							3'b001: begin
								if (dividend_tmp_reg[m-16:m-1] != 16'b0) begin
									dividend_cnt <= 4'd8;
									dividend_tmp_reg <= dividend_tmp_reg;
								end
								else if (dividend_tmp_reg[m-32:m-17] != 16'b0) begin
									dividend_cnt <= 4'd7;
									dividend_tmp_reg <= {16'b0,dividend_tmp_reg[0:m-17],dividend_tmp_reg[m]};
								end	
								else begin
									dividend_cnt <= 4'd6;
									dividend_tmp_reg <= {32'b0,dividend_tmp_reg[0:m-33],dividend_tmp_reg[m]};
								end	
							end
							3'b010: begin
								if (dividend_tmp_reg[m-64:m-49] != 16'b0) begin
									dividend_cnt <= 4'd5;
									dividend_tmp_reg <= {48'b0,dividend_tmp_reg[0:m-49],dividend_tmp_reg[m]};
								end	
								else if (dividend_tmp_reg[m-80:m-65] != 16'b0) begin	
									dividend_cnt <= 4'd4;
									dividend_tmp_reg <= {64'b0,dividend_tmp_reg[0:m-65],dividend_tmp_reg[m]};
								end	
								else begin
									dividend_cnt <= 4'd3;
									dividend_tmp_reg <= {80'b0,dividend_tmp_reg[0:m-81],dividend_tmp_reg[m]};
								end
							end
							3'b100: begin
								if (dividend_tmp_reg[m-112:m-97] != 16'b0) begin
									dividend_cnt <= 4'd2;
									dividend_tmp_reg <= {96'b0,dividend_tmp_reg[0:m-97],dividend_tmp_reg[m]};
								end
								else if (dividend_tmp_reg[m-128:m-113] != 16'b0) begin
									dividend_cnt <= 4'd1;
									dividend_tmp_reg <= {112'b0,dividend_tmp_reg[0:m-113],dividend_tmp_reg[m]};
								end
								else begin
									dividend_cnt <= 4'd0;
									dividend_tmp_reg <= {128'b0,dividend_tmp_reg[0:m-129],dividend_tmp_reg[m]};								
								end	
							end
							default: begin
							end
						endcase

						//assess divisor degree
						if (divisor_tmp_reg[96:m-1] != 48'b0) begin
							divisor_degree_high <= 1;
							divisor_degree_mid <= 0;
							divisor_degree_low <= 0;
							divisor_degree_done <= 1;
						end
						else if (divisor_tmp_reg[48:95] != 48'b0) begin
							divisor_degree_high <= 0;
							divisor_degree_mid <= 1;
							divisor_degree_low <= 0;
							divisor_degree_done <= 1;
						end
						else if (divisor_tmp_reg[0:47] != 48'b0) begin
							divisor_degree_high <= 0;
							divisor_degree_mid <= 0;
							divisor_degree_low <= 1;
							divisor_degree_done <= 1;
						end
						else begin // divisor is zero, invalid
							divisor_cnt <= 4'd15;
							divisor_degree_done <= 1'b1;
						end

						case ({divisor_degree_low,divisor_degree_mid,divisor_degree_high})
							3'b001: begin
								if (divisor_tmp_reg[m-16:m-1] != 16'b0) begin
									divisor_cnt <= 4'd8;
									divisor_tmp_reg <= divisor_tmp_reg;
								end
								else if (divisor_tmp_reg[m-32:m-17] != 16'b0) begin
									divisor_cnt <= 4'd7;
									divisor_tmp_reg <= {16'b0,divisor_tmp_reg[0:m-17]};
								end	
								else begin
									divisor_cnt <= 4'd6;
									divisor_tmp_reg <= {32'b0,divisor_tmp_reg[0:m-33]};
								end	
							end
							3'b010: begin
								if (divisor_tmp_reg[m-64:m-49] != 16'b0) begin
									divisor_cnt <= 4'd5;
									divisor_tmp_reg <= {48'b0,divisor_tmp_reg[0:m-49]};
								end	
								else if (divisor_tmp_reg[m-80:m-65] != 16'b0) begin	
									divisor_cnt <= 4'd4;
									divisor_tmp_reg <= {64'b0,divisor_tmp_reg[0:m-65]};
								end	
								else begin
									divisor_cnt <= 4'd3;
									divisor_tmp_reg <= {80'b0,divisor_tmp_reg[0:m-81]};
								end
							end
							3'b100: begin
								if (divisor_tmp_reg[m-112:m-97] != 16'b0) begin
									divisor_cnt <= 4'd2;
									divisor_tmp_reg <= {96'b0,divisor_tmp_reg[0:m-97]};
								end
								else if (divisor_tmp_reg[m-128:m-113] != 16'b0) begin
									divisor_cnt <= 4'd1;
									divisor_tmp_reg <= {112'b0,divisor_tmp_reg[0:m-113]};
								end
								else begin
									divisor_cnt <= 4'd0;
									divisor_tmp_reg <= {128'b0,divisor_tmp_reg[0:m-129]};								
								end	
							end
							default: begin
							end
						endcase

						
					end
					
					DATA_LDCOEFF: begin
						//determine whether div should be terminated.
						if (((dividend_cnt < divisor_cnt) || dividend_cnt == 4'd15)  && (dividend_degree_done == 1'b1) && (divisor_degree_done == 1'b1)) begin
							div_done <= 1'b1;
							dividend_degree_done <= 0;
							divisor_degree_done <= 0;
						end	
						else begin
							div_done <= 1'b0;
						end	

						//GF(2^16) inverse
						if (first_time && counter == 5'd0) begin
							inv_in_reg 	<= divisor_tmp_reg[m-16:m-1];
							inv_en_reg 	<= 1'b1;
							inv_trg_reg <= 1'b1;
							ldcoeff_done <= 1'b0;
							counter 	<= counter + 5'b1;
						end
						//GF(2^16) mul
						else if (first_time && counter == 5'd18) begin
							mul_t_in_reg  <=  inv_r_dat;
							mul_o_in_reg  <= (dividend_tmp_reg[m]==1'b1)?{1'b1,143'b0}:{dividend_tmp_reg[m-16:m-1],128'b0};
							mul_add_in_reg <= 144'b0;
							inv_r_reg 	<= inv_r_dat; 
							inv_en_reg <= 1'b0;
							ldcoeff_done <= 1'b1;
							counter 	<= counter + 1'd1;	
						end
						else if (first_time && counter == 5'd19) begin
							counter <= dividend_cnt - divisor_cnt;
							first_time <= 0;
							ldcoeff_done <= 0;
						end
						//GF(2^16) mul
						else if (~first_time && counter == 5'd0) begin
							mul_t_in_reg  <=  inv_r_reg;
							mul_o_in_reg  <= (dividend_tmp_reg[m]==1'b1)?{1'b1,143'b0}:{dividend_tmp_reg[m-16:m-1],128'b0};
							mul_add_in_reg <= 0;
							inv_en_reg <= 1'b0;
							ldcoeff_done <= 1'b1;
							counter 	<= counter + 1'd1;
						end	

						else if (~first_time && counter == 5'd1) begin
							counter <= dividend_cnt - divisor_cnt;
							ldcoeff_done <= 0;
						end	

						else begin
							inv_in_reg <= inv_in_reg;
							inv_r_reg  <= inv_r_reg;
							inv_en_reg <= inv_en_reg;
							inv_trg_reg <= 1'b0;
							counter <= counter + 5'b1;
							
							mul_t_in_reg <= mul_t_in_reg;
							mul_o_in_reg <= mul_o_in_reg;
							mul_add_in_reg <= 0;
							
							ldcoeff_done <= 1'b0;
						end	
					end

					DATA_SHIFT: begin
							case(counter) //prepare for q, r
							5'd0: begin
								mul_o_in_reg <= divisor_reg;
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg  <= {mul1_r_dat, 128'b0}; 
								counter <= 0;
							end
							5'd1: begin
								mul_o_in_reg <= {16'd0,divisor_reg[0:m-17]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= {16'd0,mul1_r_dat,112'd0};
								counter <= 0;
							end
							5'd2: begin
								mul_o_in_reg <= {32'd0,divisor_reg[0:m-33]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= {32'd0,mul1_r_dat,96'd0};
								counter <= 0;
							end
							5'd3: begin
								mul_o_in_reg <= {48'd0,divisor_reg[0:m-49]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= {48'd0,mul1_r_dat,80'd0};
								counter <= 0;
							end
							5'd4: begin
								mul_o_in_reg <= {64'd0,divisor_reg[0:m-65]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= {64'd0,mul1_r_dat,64'd0};
								counter <= 0;
							end
							5'd5: begin
								mul_o_in_reg <= {80'd0,divisor_reg[0:m-81]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= {80'd0,mul1_r_dat,48'd0};
								counter <= 0;
							end
							5'd6: begin
								mul_o_in_reg <= {96'd0,divisor_reg[0:m-97]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= quotient_reg ^ {96'd0,mul1_r_dat,32'd0};
								counter <= 0;
							end
							5'd7: begin
								mul_o_in_reg <= {112'd0,divisor_reg[0:m-113]};
								mul_t_in_reg <= mul1_r_dat; 
								mul_add_in_reg <= dividend_reg[0:m-1];

								inv_tmp_reg <= {112'd0,mul1_r_dat};
								counter <= 0;
							end
							default: begin
							//well, when goes into this case, it should be an exception.
								mul_o_in_reg <= 0;
								mul_t_in_reg <= 0;
								mul_add_in_reg <= 0;

								inv_tmp_reg <= 0;
								counter <= 0;
							end
						endcase
					end
					
					DATA_MAC: begin					
						//update divisor_reg because it changes every time when remainder updates.
						divisor_tmp_reg <= divisor_reg;

						dividend_degree_done <= 0;
						divisor_degree_done <= 0;
						dividend_degree_high <= 0;
						dividend_degree_mid <= 0;
						dividend_degree_low <= 0;
						divisor_degree_high <= 0;
						divisor_degree_mid <= 0;
						divisor_degree_low <= 0;

						if (counter == 5'd1) begin //allocate partial remainder into remainder_reg
							quotient_reg <= quotient_reg ^ inv_tmp_reg;
							dividend_reg <= {mul1_r_dat, mul2_r_dat, mul3_r_dat, mul4_r_dat, mul5_r_dat, mul6_r_dat, mul7_r_dat, mul8_r_dat, mul9_r_dat, 1'b0};
							dividend_tmp_reg <= {mul1_r_dat, mul2_r_dat, mul3_r_dat, mul4_r_dat, mul5_r_dat, mul6_r_dat, mul7_r_dat, mul8_r_dat, mul9_r_dat, 1'b0};
							counter <= 0;
						end
						else begin
							quotient_reg <= quotient_reg;
							dividend_reg <= dividend_reg;
							dividend_tmp_reg <= dividend_tmp_reg;
							counter	<= counter + 1'b1;
						end
					end				
				endcase
			end
end			
		
assign mul1_o_out = mul_o_in_reg[0:15];
assign mul2_o_out = mul_o_in_reg[16:31];
assign mul3_o_out = mul_o_in_reg[32:47];
assign mul4_o_out = mul_o_in_reg[48:63];
assign mul5_o_out = mul_o_in_reg[64:79];
assign mul6_o_out = mul_o_in_reg[80:95];
assign mul7_o_out = mul_o_in_reg[96:111];
assign mul8_o_out = mul_o_in_reg[112:127];
assign mul9_o_out = mul_o_in_reg[128:143];

assign mul_t_out = mul_t_in_reg;	

assign mul1_add_out = mul_add_in_reg[0:15];
assign mul2_add_out = mul_add_in_reg[16:31];
assign mul3_add_out = mul_add_in_reg[32:47];
assign mul4_add_out = mul_add_in_reg[48:63];
assign mul5_add_out = mul_add_in_reg[64:79];
assign mul6_add_out = mul_add_in_reg[80:95];
assign mul7_add_out = mul_add_in_reg[96:111];
assign mul8_add_out = mul_add_in_reg[112:127];
assign mul9_add_out = mul_add_in_reg[128:143];

assign inv_en = inv_en_reg;	
assign inv_out = inv_in_reg;
assign inv_trg = inv_trg_reg;	

assign quotient_out	= quotient_reg;
assign remainder_out = dividend_reg[0:m-1];	
	
endmodule