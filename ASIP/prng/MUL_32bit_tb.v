`timescale 1ns / 1ns
`define    CLK_PERIOD      10

module MUL_32bit_tb();
parameter n = 32;

	reg clk;
	reg [n-1:0] multiplicand,multiplier;
	wire [2*n-1:0]	result;

    
MUL_32bit uut (
.clk			(clk), 
.multiplicand	(multiplicand),
.multiplier		(multiplier), 
.result			(result)
);
	
	initial begin
		// Initialize Inputs
		$display("MUL_32bit test begins:");  
		$monitor($time, "\t multiplicand = %d, multiplier = %d ,result = %d",multiplicand, multiplier, result);
		clk = 0;
		#(0.5*`CLK_PERIOD)
		clk = 1;
		multiplicand = 0;
		multiplier = 0;
											
		/* 1st round */

		#(3*`CLK_PERIOD)	multiplicand = 32'd123456;
							multiplier 	= 32'd654321;	

							
		/* 2nd round */

		#(10*`CLK_PERIOD)	multiplicand = 32'd123456789;
							multiplier 	=  32'd987654321;	
							
		/* 3rd round */

		#(10*`CLK_PERIOD)	multiplicand = 32'd1;
							multiplier 	=  32'd1103515245;
end
	
	initial begin
	
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
	end
      
endmodule						  
