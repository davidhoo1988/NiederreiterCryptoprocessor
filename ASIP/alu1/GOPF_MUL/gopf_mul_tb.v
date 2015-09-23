`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define    DAT_W           144

module gopf_mul_tb();

reg clk;
reg rst_b;
reg start;
reg [0:`DAT_W-1] 	multiplicand, multiplier;
reg [0:`DAT_W] 		mod;

wire [0:`DAT_W-1] mul_out;

    
GOPF_MUL uut(
	.clk			(clk),
	.rst_b			(rst_b),
	.start			(start),
	.multiplicand	(multiplicand),
	.multiplier		(multiplier),
	.mod			(mod[0:`DAT_W-1]),
	
	.mul_out		(mul_out)
);
	
initial begin
	// Initialize Inputs
	clk 			= 1;
	rst_b 			= 0;
	start 			= 0;
	multiplicand 	= 0;
	multiplier 		= 0;
	mod 			= 0;
	
	#(5*`CLK_PERIOD)	rst_b = 1'b1;
	
	 
	// test addition	
	// 1st
	#(`CLK_PERIOD)			start = 1'b1;
							multiplicand 	= 144'b100111111011011010011101000110001011110011000011100000111000111000100110000000000010101010001001010000011010100101101100111011100100011010010101;
							multiplier 		= 144'b011010100001000000111010011001110111111100010110010011000101011001101001110010010100000011100011111110010110011000101111010101111001001011001000;
							mod 			= 145'b0110101011011011011100111100101011001110101111010001111111111110111110100101001111001010111011001011000010111101010111011010101101001100001110111;
	
	#(`CLK_PERIOD)			start = 1'b0;
	
	#(110*`CLK_PERIOD)		rst_b = 1'b0;
	#(`CLK_PERIOD)			rst_b = 1'b1;

	// 2nd
	#(`CLK_PERIOD)			start = 1'b1;
							multiplicand 	= 144'b100111111011011010011101000110001011110011000011100000111000111000100110000000000010101010001001010000011010100101101100111011100000000000000000;
							multiplier 		= 144'b011010100001000000111010011001110111111100010110010011000101011001101001110010010100000011100011111110010110011000101111010101111001001011001000;

	#(`CLK_PERIOD)			start = 1'b0;
	
	#(110*`CLK_PERIOD)		rst_b = 1'b0;
	#(`CLK_PERIOD)			rst_b = 1'b1;
	
	// 3rd
	#(`CLK_PERIOD)			start = 1'b1;
							multiplicand 	= 144'b100111111011011010011101000110001011110011000011100000111000111000100110000000000010101010001001010000011010100101101100111011100100011010010101;
							multiplier 		= 144'b011010100001000000111010011001110111111100010110010011000101011001101001110010010100000011100011111110010110011000101111010101110000000000000000;
	
	#(`CLK_PERIOD)			start = 1'b0;
end

initial begin
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
end

endmodule