`timescale 1 ns/1 ns

module multiplier_tb();
parameter m=16, k3=5, k2=3, k1=2, n=8, period = 20;

reg clk;
reg [m-1:0] A_in, B_in;

wire [m-1:0] C_out;


ALU_Multiplier	testbench(
					.A_in(A_in), 
					.B_in(B_in), 
					.C_out(C_out), 
					.clk(clk));

					
initial
begin
	forever #(period/2) clk = ~clk;
end

initial
begin
	clk = 1;
	A_in = 16'h0000;
	B_in = 16'h0000;
	
	#(5*period)	A_in = 16'h8421;
					B_in = 16'h0002;
					
	#(period)	A_in = 16'h1234;
					B_in = 16'h0002;
					
	#(period)	A_in = 16'h1234;
					B_in = 16'h4321;
					
	#(period)	A_in = 16'h2222;
					B_in = 16'h1357;
					
	#(period)	A_in = 16'habcd;
					B_in = 16'hf0f0;
	
	#(period)	A_in = 16'hffff;
					B_in = 16'hffff;
end

endmodule

