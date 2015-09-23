`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define    DAT_W           144

module split_tb();

reg 				clk;
reg 				rst_b;
reg 				start;
reg [0:`DAT_W-1]	poly_in; 	

wire 				split_done;
wire [0:`DAT_W-1] 	first_fragment_out, second_fragment_out;

    
SPLIT uut(
	.clk					(clk),
	.rst_b					(rst_b),
	.start					(start),
	.poly_in				(poly_in),
	
	.split_done 			(split_done),
	.first_fragment_out		(first_fragment_out),
	.second_fragment_out	(second_fragment_out)
);
	
initial begin
	// Initialize Inputs
	clk 			= 1;
	rst_b 			= 0;
	start 			= 0;
	poly_in			= 0;
	
	#(5*`CLK_PERIOD)	rst_b = 1'b1;
	
	 
	// test addition	
	// 1st  
	//[0 0 1 0 1 1 1 1 0 1 1 1 1 0 0 0] 
	//[0 0 0 0 1 0 0 1 0 0 1 1 1 0 1 0] 
	//[1 1 0 0 1 1 1 0 1 0 0 1 1 0 0 0] 
	//[0 1 1 1 1 0 0 1 0 0 0 1 0 1 0 0] 
	//[0 0 1 0 0 0 0 0 0 1 1 0 1 0 1 0] 
	//[0 0 0 0 0 0 1 1 0 1 0 1 1 1 0 0] 
	//[1 0 0 1 1 1 0 0 1 1 1 1 1 1 1 0] 
	//[1 0 1 0 0 0 0 1 1 1 0 0 0 1 0 0] 
	//[0 1 0 0 0 1 1 1 0 1 0 0 0 1 1 0]
	#(`CLK_PERIOD)			start = 1'b1;
							poly_in = 144'b001011110111100000001001001110101100111010011000011110010001010000100000011010100000001101011100100111001111111010100001110001000100011101000110;
	
	#(`CLK_PERIOD)			start = 1'b0;
	
end

initial begin
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
end

endmodule