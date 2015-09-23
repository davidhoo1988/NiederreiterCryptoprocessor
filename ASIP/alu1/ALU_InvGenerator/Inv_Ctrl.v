`ifndef c
`define c 5
`endif

module Inv_Ctrl (clk, rst, inv_cSignal, alu_o_sel);

input clk, rst, alu_o_sel;
output[`c-1:0] inv_cSignal;

reg[`c-1:0] inv_cSignal;
reg[4:0] counter;

reg temp_o; //catch the posedge of alu_o_sel, alu_t_sel

always@(posedge clk)
begin
	temp_o <= alu_o_sel;
	if(!rst)
	begin
		counter <= 0;
	end
	else if({temp_o, alu_o_sel} == 2'b01)
	begin
		counter <= 1;
	end
	else if(counter == 26)
	begin
		counter <= 26;
	end
	else if(counter >=1)
	begin
		counter <= counter + 1'b1;
	end
	else 
		counter <= counter;
end

always@(counter, inv_cSignal)
begin
  case(counter)
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //inv_cSignal
  //bits:{regs_input_sel[4],  (load initial or load from mul) 
  //      regs_input_enable[3],  (update new data or remain no change)
  //      mux0_sel[2],
  //      2^x-power_sel[1:0]}   (2'b00 for 2^1-power, 2'b01 for 2^3-power, 2^b10 or 2^b11 for 2^6-power)
  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  
    1: inv_cSignal <= `c'b11000;//exp1
    2: inv_cSignal <= `c'b00000;
    3: inv_cSignal <= `c'b00000;
	 4: inv_cSignal <= `c'b00000;
    5: inv_cSignal <= `c'b00000;
    
    6: inv_cSignal <= `c'b01000;//exp1
    7: inv_cSignal <= `c'b00100;
    8: inv_cSignal <= `c'b00100;
    9: inv_cSignal <= `c'b00100;
    10:inv_cSignal <= `c'b00100;
    
    11:inv_cSignal <= `c'b01101;//exp3
    12:inv_cSignal <= `c'b00001;
	 13:inv_cSignal <= `c'b00001;
    14:inv_cSignal <= `c'b00001;
    15:inv_cSignal <= `c'b00001;
    
    16:inv_cSignal <= `c'b01001;//exp3
    17:inv_cSignal <= `c'b00101;
	 18:inv_cSignal <= `c'b00101;
    19:inv_cSignal <= `c'b00101;
    20:inv_cSignal <= `c'b00101;
    
    21:inv_cSignal <= `c'b01110;//exp6
    22:inv_cSignal <= `c'b00110;
	 23:inv_cSignal <= `c'b00110;
    24:inv_cSignal <= `c'b00110;
    25:inv_cSignal <= `c'b00110;
    
    26:inv_cSignal <= `c'b01100;
    default: inv_cSignal <= `c'b00000;
  endcase
end
endmodule
	              
	  		