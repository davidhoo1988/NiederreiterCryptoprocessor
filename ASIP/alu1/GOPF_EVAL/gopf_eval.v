module GOPF_EVAL (
	//input
	clk,
	rst_b,
	start,
	gopf,
	gf2e_element,
	
	//output
	eval_r_dat,
	eval_done,
	
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

	mul1_t_out,
	mul2_t_out,
	mul3_t_out,
	mul4_t_out,
	mul5_t_out,
	mul6_t_out,
	mul7_t_out,
	mul8_t_out,
	mul9_t_out,	
	
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
input wire 	[0:m] 		gopf;
input wire 	[0:m-1]		gf2e_element;

output wire [0:m-1] 	eval_r_dat;
output reg 				eval_done;

output wire [0:15]		mul1_o_out,	mul2_o_out,	mul3_o_out,
						mul4_o_out,	mul5_o_out,	mul6_o_out,
						mul7_o_out,	mul8_o_out,	mul9_o_out;

output wire [0:15]		mul1_t_out,	mul2_t_out,	mul3_t_out,
						mul4_t_out,	mul5_t_out,	mul6_t_out,
						mul7_t_out,	mul8_t_out,	mul9_t_out;						


input wire 	[0:15]		mul1_r_dat,	mul2_r_dat,	mul3_r_dat,
						mul4_r_dat,	mul5_r_dat,	mul6_r_dat,
						mul7_r_dat,	mul8_r_dat,	mul9_r_dat;
						
				
						
//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 	DATA_PRE  		= 0, //do nothing, then get prepared input 
			DATA_SHIFT  	= 1, //shift sigma to load coefficents sequentially
			DATA_MUL		= 2, 
			DATA_ADD 		= 3;
					

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
//----------------------------------------------------------	
reg [4:0]		counter;

reg [0:m+15] 	gopf_reg;
reg [0:m-1]		gf2e_element_reg;
reg [0:m-1] 	eval_r_reg;

reg [0:m-1] 	mul_o_in_reg;
reg [0:m-1]		mul_t_in_reg;		
//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------		
		always @ (CurrentState or start or counter or eval_done)
			begin
               case (CurrentState)
					DATA_PRE:	begin
									if (start)
										NextState = DATA_MUL;
									else
										NextState = DATA_PRE;
								end	
								
					DATA_SHIFT:	begin
										NextState = DATA_MUL;	
								end					
					
					DATA_MUL: 	begin // it takes 1 cycles to do one BF_MUL
									if (counter == 5'd0)
										NextState = DATA_ADD;
									else
										NextState = DATA_MUL;
								end
					
					DATA_ADD: 	begin	
									if (eval_done)
										NextState = DATA_PRE;	
									else
										NextState = DATA_SHIFT;									
								end
					
					default: NextState = DATA_PRE;
				endcase
		end	
		





//----------------------------------------------------------
//3rd always block, the sequential FSM output
//----------------------------------------------------------			
always @ (posedge clk or negedge rst_b) begin
			if (!rst_b) begin				
				counter				<= 0;
				eval_done			<= 0;
				gopf_reg			<= 160'b0;
				gf2e_element_reg 	<= 144'b0;
				mul_o_in_reg		<= 144'b0;
				mul_t_in_reg		<= 144'b0;
			end
			
			else begin
				case (CurrentState)
					DATA_PRE: begin	
						eval_done 			<= 0;
						counter 			<= 0;
						gopf_reg 			<= {gopf,15'b0};
						gf2e_element_reg 	<= gf2e_element;
						mul_o_in_reg		<= 144'b0;
						mul_t_in_reg		<= 144'b0;
						eval_r_reg 			<= 144'b0;

					end
					
					DATA_SHIFT: begin //locate each coefficient of gpof
						gopf_reg 			<= {16'b0, gopf_reg[0:143]};
						gf2e_element_reg 	<= gf2e_element_reg;
						mul_o_in_reg 		<= gf2e_element_reg;
						mul_t_in_reg 		<= eval_r_reg;
						counter				<= counter;
					end
									
					DATA_MUL: begin					
						counter 			<= counter + 1'b1;
						if (gopf_reg[0:159] == 160'b0)
							eval_done <= 1'b1;
						else
							eval_done <= 1'b0;	
					end
					
					DATA_ADD: begin					
						eval_r_reg			<= {mul1_r_dat ^ gopf_reg[144:159], mul2_r_dat ^ gopf_reg[144:159], mul3_r_dat ^ gopf_reg[144:159], mul4_r_dat ^ gopf_reg[144:159], mul5_r_dat ^ gopf_reg[144:159], mul6_r_dat ^ gopf_reg[144:159], mul7_r_dat ^ gopf_reg[144:159], mul8_r_dat ^ gopf_reg[144:159], mul9_r_dat ^ gopf_reg[144:159]};
						counter				<= 0;
						eval_done			<= 0;
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

assign mul1_t_out = mul_t_in_reg[0:15];
assign mul2_t_out = mul_t_in_reg[16:31];
assign mul3_t_out = mul_t_in_reg[32:47];
assign mul4_t_out = mul_t_in_reg[48:63];
assign mul5_t_out = mul_t_in_reg[64:79];
assign mul6_t_out = mul_t_in_reg[80:95];
assign mul7_t_out = mul_t_in_reg[96:111];
assign mul8_t_out = mul_t_in_reg[112:127];
assign mul9_t_out = mul_t_in_reg[128:143];


assign eval_r_dat = eval_r_reg;	
endmodule