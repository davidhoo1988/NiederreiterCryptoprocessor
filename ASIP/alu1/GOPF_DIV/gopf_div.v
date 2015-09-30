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
	
	//output to MUL_ARRAY
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
			DATA_SHIFT  	= 1, //shift divisor to line up with dividend
			DATA_LDCOEFF 	= 2, //confirm the leading coefficient of divisor [bn^-1*an]
			DATA_MUL		= 3, //multiplicand * multiplier[i]
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
										NextState = DATA_SHIFT;
									else
										NextState = DATA_PRE;
								end	
								
					DATA_SHIFT:	begin	
									if (dividend_degree_done && divisor_degree_done)
										NextState = DATA_LDCOEFF;
									else	
										NextState = DATA_SHIFT;
								end					
					
					DATA_LDCOEFF: begin
									if (div_done)
										NextState = DATA_PRE;
									else if (ldcoeff_done)
										NextState = DATA_MUL;
									else
										NextState = DATA_LDCOEFF;
					end
					
					DATA_MUL: 	begin // it takes 1 cycles to do one BF_MUL
									if (counter == 5'd2)
										NextState = DATA_MAC;
									else
										NextState = DATA_MUL;
								end
					
					DATA_MAC: 	begin													
									if (quotient_done && remainder_done)
										NextState = DATA_SHIFT;
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

reg [3:0] 	dividend_cnt, divisor_cnt;	

reg	[0:15]	inv_in_reg, inv_r_reg;
reg			inv_en_reg, inv_trg_reg;


//----------------------------------------------------------
//3rd always block, the sequential FSM output
//----------------------------------------------------------			
always @ (posedge clk or negedge rst_b) begin
			if (!rst_b) begin
				dividend_reg 	<= 145'b0;
				divisor_reg 	<= 144'b0;
				remainder_reg	<= 144'b0;
				quotient_reg	<= 144'b0;
				dividend_tmp_reg<= 145'b0;
				divisor_tmp_reg	<= 144'b0;
				
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
						dividend_tmp_reg<= dividend;
						divisor_tmp_reg	<= divisor;
						remainder_reg	<= 144'b0;
						quotient_reg	<= 144'b0;
						
						dividend_cnt 	<= 4'd8; //assume full degree
						divisor_cnt		<= 4'd8; //assume full degree
						counter			<= 0;
						div_done 		<= 0;
						dividend_degree_done <= 0;
						divisor_degree_done <= 0;
						remainder_done	<= 0;
						quotient_done	<= 0;
						ldcoeff_done    <= 0;
						first_time 		<= 1;
					end
					
					DATA_SHIFT: begin //calculate degree of dividend and divisor
						remainder_done	<= 0;
						quotient_done	<= 0;
						counter 		<= 0;
						//assess dividend degree
						if (dividend_tmp_reg[m]==1'b1) begin
							dividend_cnt <= 9;
							dividend_degree_done <= 1'b1;
						end	
						else if (dividend_tmp_reg[0:m-1]==144'b0) begin // dividend is zero
							dividend_cnt <= 4'd15;
							dividend_degree_done <= 1'b1;
						end
						else if (dividend_tmp_reg[m-16:m-1]==16'b0) begin
							dividend_tmp_reg <= {16'b0,dividend_tmp_reg[0:m-17],dividend_tmp_reg[m]};
							dividend_cnt <= dividend_cnt - 4'd1;
							dividend_degree_done <= 1'b0;
						end	
						else begin
							dividend_cnt <= dividend_cnt;
							dividend_degree_done <= 1'b1;
						end
						//assess divisor degree
						if (divisor_tmp_reg[m-16:m-1]==16'b0) begin
							divisor_tmp_reg <= {16'b0,divisor_tmp_reg[0:m-17]};
							divisor_cnt <= divisor_cnt - 4'd1;
							divisor_degree_done <= 1'b0;
						end
						else begin
							divisor_cnt <= divisor_cnt;
							divisor_degree_done <= 1'b1;
						end

						//determine whether div should be terminated.
						if (((dividend_cnt < divisor_cnt) || dividend_cnt == 4'd15)  && (dividend_degree_done == 1'b1) && (divisor_degree_done == 1'b1)) begin
							div_done <= 1'b1;
						end	
						else begin
							div_done <= 1'b0;
						end	
					end
					
					DATA_LDCOEFF: begin
						div_done <= 1'b0;
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
							inv_r_reg 	<= inv_r_dat; 
							inv_en_reg <= 1'b0;
							ldcoeff_done <= 1'b1;
							counter 	<= 5'b11111;	
							first_time <= 0;						
						end
						else if (~first_time && counter == 5'd0) begin
							mul_t_in_reg  <=  inv_r_reg;
							mul_o_in_reg  <= (dividend_tmp_reg[m]==1'b1)?{1'b1,143'b0}:{dividend_tmp_reg[m-16:m-1],128'b0};
							inv_en_reg <= 1'b0;
							ldcoeff_done <= 1'b1;
							counter 	<= 5'b11111;
						end
						else begin
							inv_in_reg <= inv_in_reg;
							inv_r_reg  <= inv_r_reg;
							inv_en_reg <= inv_en_reg;
							inv_trg_reg <= 1'b0;
							counter <= counter + 5'b1;
							
							mul_t_in_reg <= mul_t_in_reg;
							mul_o_in_reg <= mul_o_in_reg;
							
							ldcoeff_done <= 1'b0;
						end	
					end
					
					DATA_MUL: begin					
						mul_o_in_reg <= divisor_reg;
						mul_t_in_reg <= mul1_r_dat; 
						if (counter == 5'b0)
							inv_tmp_reg  <= {mul1_r_dat, 128'b0}; 
						else
							inv_tmp_reg <= inv_tmp_reg;
							
						if (counter == 5'd2) begin //allocate partial remainder into remainder_reg
							remainder_reg <= {mul1_r_dat, mul2_r_dat, mul3_r_dat, mul4_r_dat, mul5_r_dat, mul6_r_dat, mul7_r_dat, mul8_r_dat, mul9_r_dat};
							counter <= 0;
						end
						else begin
							remainder_reg <= remainder_reg;
							counter	<= counter + 1;
						end
					end
					
					DATA_MAC: begin
						dividend_tmp_reg <= dividend_reg; //update dividend because it changes every time when remainder updates.
						dividend_degree_done <= 0;
						divisor_degree_done <= 0;
						//obtain remainder
						if ((counter == dividend_cnt - divisor_cnt) && remainder_done == 1'b0)begin
							dividend_reg <= {remainder_reg ^ dividend_reg[0:m-1],1'b0};
							remainder_done <= 1'b1;
							counter <= 0;
							dividend_cnt <= 4'd8; //reset cnt
							divisor_cnt <= divisor_cnt;
						end
						else begin
							dividend_reg <= dividend_reg;
							remainder_reg <= {16'b0, remainder_reg[0:m-17]};
							remainder_done <= 1'b0;
							counter <= counter + 5'b1;
							dividend_cnt <= dividend_cnt;
							divisor_cnt <= divisor_cnt;
						end
						//obtain quotient
						if ((counter == dividend_cnt - divisor_cnt) && quotient_done == 1'b0) begin
							quotient_reg <= quotient_reg ^ inv_tmp_reg;
							quotient_done <= 1'b1;
							counter <= 0;
						end
						else begin
							inv_tmp_reg <= {16'd0, inv_tmp_reg[0:m-17]};
							quotient_done <= 1'b0;
							counter <= counter + 5'b1;
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

assign inv_en = inv_en_reg;	
assign inv_out = inv_in_reg;
assign inv_trg = inv_trg_reg;	

assign quotient_out	= quotient_reg;
assign remainder_out = dividend_reg[0:m-1];	
	
endmodule