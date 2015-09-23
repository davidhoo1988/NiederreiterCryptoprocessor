`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define    DAT_W           144

module deg_tb();

reg 				clk;
reg 				rst_b;
reg 				start;
reg [0:`DAT_W-1]	poly_in; 	

wire 				deg_done;
wire	[3:0]		poly_deg_out;

    
DEG uut(
	.clk					(clk),
	.rst_b					(rst_b),
	.start					(start),
	.poly_in				(poly_in),
	
	.deg_done 				(deg_done),
	.poly_deg_out			(poly_deg_out)
);
	
initial begin
	// Initialize Inputs
	clk 			= 1;
	rst_b 			= 0;
	start 			= 0;
	poly_in			= 0;
	
	#(5*`CLK_PERIOD)		rst_b = 1'b1;
	
	 
	#(`CLK_PERIOD)			start = 1'b1;//9
							poly_in = 144'b001011110111100000001001001110101100111010011000011110010001010000100000011010100000001101011100100111001111111010100001110001000100011101000110;
	
	#(`CLK_PERIOD)			start = 1'b0;

	#(10*`CLK_PERIOD) 		start = 1'b1; //7
							poly_in = 144'b001011110111100000001001001110101100111010011000011110010001010000100000011010100000001101011100100111001111111000000000000000000000000000000000;

	#(`CLK_PERIOD)			start = 1'b0;

	#(10*`CLK_PERIOD) 		start = 1'b1; //1
							poly_in = 144'b001011110111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

	#(`CLK_PERIOD)			start = 1'b0;

	#(10*`CLK_PERIOD) 		start = 1'b1; //0
							poly_in = 144'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

	#(`CLK_PERIOD)			start = 1'b0;
	
end

initial begin
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
end

endmodule