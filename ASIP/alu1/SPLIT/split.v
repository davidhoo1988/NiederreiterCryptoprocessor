//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./split/split.v
//  File Revision        : 1.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2015.7		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module is the spliter of the input polynomial
//                     e.g. T(x) = T0(x)^2 + x*T1(x)^2 where T0 and T1 is the output
//  ----------------------------------------------------------------------------
//===============================================================================
module SPLIT (
	//input
	clk,
	rst_b,
	start,
	poly_in,	
	//output
	first_fragment_out,
	second_fragment_out,
	split_done	
);

parameter m = 144;

//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
input wire 				clk, rst_b;
input wire 				start;
input wire 	[0:m-1]		poly_in;

output wire [0:m-1] 	first_fragment_out;
output wire [0:m-1]		second_fragment_out;

output reg 				split_done;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 	DATA_PRE  		= 0, //do nothing, then get prepared to DATA_MUL1
			DATA_SHIFT  	= 1, //shift poly_in
			DATA_SQRT 		= 2; //calculate sqrt of each coefficient in poly_in
					

//----------------------------------------------------------
//1st always block, sequential state transition
//----------------------------------------------------------
		reg    [2:0]   NextState, CurrentState;
		always @ (posedge clk or negedge rst_b)
			  if (!rst_b)            
					CurrentState <= DATA_PRE;        
			  else                  
					CurrentState <= NextState; 
					
					
//----------------------------------------------------------
//  signal Declaration
//	the signal start, overflow, finish control the end of split
//---------------------------------------------------------- 
reg 				finish;		
//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------		
always @ (CurrentState or start or split_done)
begin
       case (CurrentState)
			DATA_PRE:	begin
							if (start)
								NextState = DATA_SQRT;
							else
								NextState = DATA_PRE;
						end	
						
			DATA_SHIFT:	begin
							if (finish)									
								NextState = DATA_PRE;
						else		
								NextState = DATA_SQRT;	
						end					
			
			DATA_SQRT: begin	
							NextState = DATA_SHIFT;
			end

			default: NextState = DATA_PRE;
		endcase
end	
		
//----------------------------------------------------------
//  signal Declaration
//----------------------------------------------------------	
reg [0:m-1]	poly_in_reg;
reg [0:m-1] first_fragment_reg;
reg [0:m-1] second_fragment_reg;

reg [3:0]	cnt;

wire 		sqrt_0, sqrt_1, sqrt_2, sqrt_3,
			sqrt_4, sqrt_5, sqrt_6, sqrt_7,
			sqrt_8, sqrt_9, sqrt_10, sqrt_11,
			sqrt_12, sqrt_13, sqrt_14, sqrt_15;

//----------------------------------------------------------
//3rd always block, the sequential FSM output
//----------------------------------------------------------			
always @ (posedge clk or negedge rst_b) begin
			if (!rst_b) begin
				poly_in_reg <= 144'b0;
				cnt <= 4'b0;
				split_done <= 0;
				first_fragment_reg <= 144'b0;
				second_fragment_reg <= 144'b0;
			end
			
			else begin
				case (CurrentState)
					DATA_PRE: begin	
						poly_in_reg <= poly_in;
						cnt <= 4'b0;
						split_done <= 0;
						first_fragment_reg <= 144'b0;
						second_fragment_reg <= 144'b0;
					end
					
					DATA_SHIFT: begin //left shift poly_in_reg
						poly_in_reg <= {poly_in_reg[16:m-1],16'b0};
						
						if (finish)
							split_done <= 1;
						else
							split_done <= 0;	
					end

					DATA_SQRT: begin //sqrt in 
						cnt <= cnt + 1'b1;

						if (cnt[0] == 1'b0) begin //left shift first_fgrament_reg, it has 5 GF(2^16) elements inside
							first_fragment_reg <= {first_fragment_reg[16:79],sqrt_0,sqrt_1,sqrt_2,sqrt_3,sqrt_4,sqrt_5,sqrt_6,sqrt_7,sqrt_8,sqrt_9,sqrt_10,sqrt_11,sqrt_12,sqrt_13,sqrt_14,sqrt_15,64'b0};
						end

						else begin //left shift second_fgrament_reg, it has 4 GF(2^16) elements inside
							second_fragment_reg <= {second_fragment_reg[16:63],sqrt_0,sqrt_1,sqrt_2,sqrt_3,sqrt_4,sqrt_5,sqrt_6,sqrt_7,sqrt_8,sqrt_9,sqrt_10,sqrt_11,sqrt_12,sqrt_13,sqrt_14,sqrt_15,80'b0};
						end

						if (cnt == 4'd8)
							finish <= 1'b1;
						else
							finish <= 1'b0;	
					end

				endcase
			end
end	


// sqrt array
/*Sqrt Matrix:
[1 1 0 0 0 1 0 1 0 1 0 1 0 1 0 1] --- 0,1,5,7,9,11,13,15
[0 0 1 1 0 0 0 1 0 1 0 1 0 1 0 1] --- 2,3,7,9,11,13,15
[0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0] --- 1,4,7
[0 1 0 1 0 1 1 1 0 0 0 1 0 1 0 1] --- 1,3,5,6,7,11,13,15
[0 0 0 1 0 1 0 1 1 1 0 0 0 1 0 1] --- 3,5,7,8,9,13,15
[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0] --- 10,13
[0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1] --- 12,15
[0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0] --- 1,14
[0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0] --- 1,3
[0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0] --- 1,3,5
[0 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0] --- 1,3,5,7
[0 1 0 1 0 1 0 1 0 1 0 0 0 0 0 0] --- 1,3,5,7,9
[0 1 0 1 0 1 0 1 0 1 0 1 0 0 0 0] --- 1,3,5,7,9,11
[0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 0] --- 1,3,5,7,9,11,13
[0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1] --- 1,3,5,7,9,11,13,15
[0 0 0 1 0 1 0 1 0 1 0 1 0 1 0 1] --- 3,5,7,9,11,13,15*/

assign sqrt_0 =  poly_in_reg[0]^poly_in_reg[1]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[9]^poly_in_reg[11]^poly_in_reg[13]^poly_in_reg[15];
assign sqrt_1 =  poly_in_reg[2]^poly_in_reg[3]^poly_in_reg[7]^poly_in_reg[9]^poly_in_reg[11]^poly_in_reg[13]^poly_in_reg[15];
assign sqrt_2 =  poly_in_reg[1]^poly_in_reg[4]^poly_in_reg[7];
assign sqrt_3 =  poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[6]^poly_in_reg[7]^poly_in_reg[11]^poly_in_reg[13]^poly_in_reg[15];
assign sqrt_4 =  poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[8]^poly_in_reg[9]^poly_in_reg[13]^poly_in_reg[15];
assign sqrt_5 =  poly_in_reg[10]^poly_in_reg[13];
assign sqrt_6 =  poly_in_reg[12]^poly_in_reg[15];
assign sqrt_7 =  poly_in_reg[1]^poly_in_reg[14];
assign sqrt_8 =  poly_in_reg[1]^poly_in_reg[3];
assign sqrt_9 =  poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5];
assign sqrt_10 = poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7];
assign sqrt_11 = poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[9];
assign sqrt_12 = poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[9]^poly_in_reg[11];
assign sqrt_13 = poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[9]^poly_in_reg[11]^poly_in_reg[13];
assign sqrt_14 = poly_in_reg[1]^poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[9]^poly_in_reg[11]^poly_in_reg[13]^poly_in_reg[15];
assign sqrt_15 = poly_in_reg[3]^poly_in_reg[5]^poly_in_reg[7]^poly_in_reg[9]^poly_in_reg[11]^poly_in_reg[13]^poly_in_reg[15];



//output signal
assign first_fragment_out = first_fragment_reg;
assign second_fragment_out = second_fragment_reg;

endmodule