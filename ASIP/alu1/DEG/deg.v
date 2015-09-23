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
module DEG (
	//input
	clk,
	rst_b,
	start,
	poly_in,	
	//output
	poly_deg_out,
	deg_done	
);

parameter m = 144;

//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
input wire 				clk, rst_b;
input wire 				start;
input wire 	[0:m-1]		poly_in;

output reg [3:0] 		poly_deg_out;
output reg 				deg_done;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 	DATA_PRE  		= 0, //do nothing, then get prepared to DATA_MUL1
			DATA_SHIFT  	= 1; //shift poly_in
					
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
reg [0:m-1]	poly_in_reg; 

//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------		
always @ (CurrentState or start or poly_in_reg[m-16:m-1] or poly_deg_out)
begin
       case (CurrentState)
			DATA_PRE:	begin
							if (start)
								NextState = DATA_SHIFT;
							else
								NextState = DATA_PRE;
						end	
						
			DATA_SHIFT:	begin
							if (poly_in_reg[m-16:m-1] != 16'b0 || poly_deg_out == 4'b0)									
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
				poly_in_reg <= 144'b0;
				poly_deg_out <= 4'b0;
				deg_done <= 0;

			end
			
			else begin
				case (CurrentState)
					DATA_PRE: begin	
						poly_in_reg <= poly_in;
						poly_deg_out <= 4'd8;
						deg_done <= 1'b0;
					end
					
					DATA_SHIFT: begin //right shift poly_in_reg
						
						if (poly_in_reg[m-16:m-1] == 16'b0 && poly_deg_out != 4'b0) begin
							poly_in_reg <= {16'b0,poly_in_reg[0:m-17]};
							poly_deg_out <= poly_deg_out - 1'b1;
							deg_done <= 1'b0;
						end
						else begin
							poly_in_reg <= poly_in_reg;
							poly_deg_out <= poly_deg_out;
							deg_done <= 1'b1;
						end	

					end
				endcase
			end
end	

endmodule