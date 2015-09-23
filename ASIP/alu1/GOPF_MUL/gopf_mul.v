module GOPF_MUL(
	//input
	clk,
	rst_b,
	start,
	multiplicand,
	multiplier,
	mod,
	
	//output
	mul_out,
	mul_done,
	
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
	
	//input from MUL_ARRAY
	mul1_r_dat,
	mul2_r_dat,
	mul3_r_dat,
	mul4_r_dat,
	mul5_r_dat,
	mul6_r_dat,
	mul7_r_dat,
	mul8_r_dat,
	mul9_r_dat
);

parameter m = 144;

//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
input wire 				clk, rst_b;
input wire 				start;
input wire 	[0:m-1] 	multiplicand, multiplier, mod; //note that the MSB of mod is omitted

output wire [0:m-1] 	mul_out;
output reg 				mul_done;

output wire [0:15]		mul1_o_out,	mul2_o_out,	mul3_o_out,
						mul4_o_out,	mul5_o_out,	mul6_o_out,
						mul7_o_out,	mul8_o_out,	mul9_o_out;
						
output wire [0:15]		mul_t_out;

input wire 	[0:15]		mul1_r_dat,	mul2_r_dat,	mul3_r_dat,
						mul4_r_dat,	mul5_r_dat,	mul6_r_dat,
						mul7_r_dat,	mul8_r_dat,	mul9_r_dat;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 	DATA_PRE  	= 0, //do nothing, then get prepared to DATA_MUL1
			DATA_DEGREE = 1, //calculate degree of multiplier
			DATA_SHIFT  = 2, //shift or shift by multiplying x
			DATA_MUL	= 3, //multiplicand * multiplier[i]
			DATA_MAC  	= 4; //accumulator
					

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
		reg 			finish;
		reg 			overflow;
		reg [1:0]   	mul_cnt;
		reg 			degree_done;
//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------		
		always @ (CurrentState or start or degree_done or mul_cnt or overflow or finish)
			begin
               case (CurrentState)
					DATA_PRE:	begin
									if (start)
										NextState = DATA_DEGREE;
									else
										NextState = DATA_PRE;
								end	
					DATA_DEGREE: begin
									if (degree_done)
										NextState = DATA_MUL;
									else
										NextState = DATA_DEGREE;	
					end			
								
					DATA_SHIFT:	begin	
										NextState = DATA_MUL;
								end					
					
					DATA_MUL: 	begin // it takes 1 cycles to do one BF_MUL
									if (mul_cnt == 2'd1)
										NextState = DATA_MAC;
									else
										NextState = DATA_MUL;
								end
					
					DATA_MAC: 	begin													
									if (finish)
										NextState = DATA_PRE;
									else if (overflow == 1'b0) // there is no overflow, goes to the next position.
										NextState = DATA_SHIFT;
									else
										NextState = DATA_MUL;
								end
					
					default: NextState = DATA_PRE;
				endcase
		end	
		
//----------------------------------------------------------
//  signal Declaration
//----------------------------------------------------------	
reg [0:m-1]	mul_o_reg;
reg [0:m-1]	mul_t_reg;
reg	[0:m-1]	mod_reg;
reg [0:m-1] mul_r_reg;

reg [0:15]  mul_o_tmp_reg;
reg [0:15]  mul_t_tmp_reg;

reg [0:m-1] mul_o_in_reg;
reg [0:15] mul_t_in_reg;

reg [3:0] 	counter, multiplier_degree;	


wire [0:15] mul1_o_in, mul2_o_in, mul3_o_in,
			mul4_o_in, mul5_o_in, mul6_o_in,
			mul7_o_in, mul8_o_in, mul9_o_in;
			
wire [0:15] mul_t_in;	


//----------------------------------------------------------
//3rd always block, the sequential FSM output
//----------------------------------------------------------		
		always @ (posedge clk or negedge rst_b) begin
			if (!rst_b) begin
				mul_o_reg 	<= 144'b0;
				mul_t_reg 	<= 144'b0;
				mod_reg   	<= 144'b0;
				mul_r_reg 	<= 144'b0;
				mul_o_tmp_reg <= 16'b0;
				
				mul_o_in_reg<= 144'b0;
				mul_t_in_reg<= 16'b0;
				
				counter 	<= 0;
				multiplier_degree <= 4'd9;
				mul_cnt		<= 0;
				finish 		<= 0;
				overflow	<= 0;
				mul_done    <= 0;
				degree_done <= 0;
			end
			
			else begin
				case (CurrentState)
					DATA_PRE: begin	
						mul_o_reg 		<= multiplicand;
						mul_t_reg 		<= multiplier;
						mod_reg   		<= mod;
						mul_r_reg       <= multiplier; //first help calculate degree then set to zero.
						
						mul_o_tmp_reg	<= 0;
						
						counter 		<= 0;
						multiplier_degree 	<= 4'd8; //assume full degree of multiplier
						degree_done			<= 1'b0;
						mul_cnt			<= 0;
						finish 			<= 0;
						mul_done 		<= 0;
					end

					DATA_DEGREE: begin
						if (multiplier_degree == 4'b0) begin
							degree_done <= 1;
							mul_r_reg <= 144'b0;
							multiplier_degree <= 0;
						end
						else if (mul_r_reg[m-16:m-1] != 16'b0 && degree_done == 1'b0) begin
							degree_done <= 1;
							mul_r_reg <= mul_r_reg;
							multiplier_degree <= multiplier_degree;
						end	
						else if (mul_r_reg[m-16:m-1] != 16'b0 && degree_done == 1'b1) begin
							degree_done <= 1;
							mul_r_reg <= 144'b0;
							multiplier_degree <= multiplier_degree;
						end
						else begin
							degree_done <= 0;
							mul_r_reg <= {16'b0,mul_r_reg[0:m-17]};	
							multiplier_degree <= multiplier_degree - 1'b1;
						end	
					end
					
					DATA_SHIFT: begin
						counter 		<= counter + 4'b1;
						mul_cnt			<= 0;
						
						mul_t_reg 		<= {mul_t_reg[16:m-1], 16'b0};
						mul_o_reg 		<= {16'b0, mul_o_reg[0:m-17]};
						mul_o_tmp_reg	<= mul_o_reg[m-16:m-1];
						if (mul_o_reg[m-16:m-1] == 16'b0) begin
							overflow <= 0;
						end
						else begin
							overflow <= 1;
						end
					end
					
					DATA_MUL: begin	
						counter <= counter;
						mul_cnt	<= mul_cnt + 1;
						
						if (overflow == 1'b0) begin
							mul_o_in_reg <= mul_o_reg;
							mul_t_in_reg <= mul_t_reg[0:15];	
						end
						else begin
							mul_o_in_reg <= mod_reg;
							mul_t_in_reg <= mul_o_tmp_reg;
						end
						
						if (counter == multiplier_degree && overflow == 1'b0)
							finish <= 1'b1;
						else
							finish <= 1'b0;
					end					
					
					DATA_MAC: begin	
						mul_cnt 	<= 0;
						overflow 	<= 1'b0;
						if (overflow == 1'b0) begin
							mul_r_reg <= mul_r_reg ^ {mul1_r_dat, mul2_r_dat, mul3_r_dat, mul4_r_dat, mul5_r_dat, mul6_r_dat, mul7_r_dat, mul8_r_dat, mul9_r_dat};
						end
						else begin
							mul_o_reg <= mul_o_reg ^ {mul1_r_dat, mul2_r_dat, mul3_r_dat, mul4_r_dat, mul5_r_dat, mul6_r_dat, mul7_r_dat, mul8_r_dat, mul9_r_dat};
						end
						if (finish)
							mul_done <= 1;
						else
							mul_done <= 0;
						
					end		
					
					default: mul_r_reg <= mul_r_reg;
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

assign mul_out = mul_r_reg;

		
endmodule
