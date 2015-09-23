`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define    DAT_W           144

module split_tb();

reg clk;
reg rst_b;
reg start;
reg [0:`DAT_W-1] 	poly_in;

wire [0:`DAT_W-1] first_fragment_out;
wire [0:`DAT_W-1] second_fragment_out;

    
SPLIT uut(
	.clk			(clk),
	.rst_b			(rst_b),
	.start			(start),
	.poly_in		(poly_in),
	
	.first_fragment_out		(first_fragment_out),
	.second_fragment_out	(second_fragment_out)
);
	
initial begin
	// Initialize Inputs
	clk 			= 1;
	rst_b 			= 0;
	start 			= 0;
	poly_in		 	= 0;
	
	#(5*`CLK_PERIOD)	rst_b = 1'b1; 
	// test 	
	// 1st
	#(`CLK_PERIOD)			start = 1'b1;
							poly_in = 144'b100111111011011010011101000110001011110011000011100000111000111000100110000000000010101010001001010000011010100101101100111011100100011010010101;
	
	#(`CLK_PERIOD)			start = 1'b0;
	
	#(110*`CLK_PERIOD)		rst_b = 1'b0;
	#(`CLK_PERIOD)			rst_b = 1'b1;

	// 2nd
	#(`CLK_PERIOD)			start = 1'b1;
							poly_in = 144'b100111111011011010011101000110001011110011000011100000111000111000100110000000000010101010001001010000011010100101101100111011100000000000000000;									
end

initial begin
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
end

endmodule