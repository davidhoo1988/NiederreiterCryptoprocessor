`timescale 1 ns/1 ns

module ALU_Multiplier(clk, A_in, B_in, C_out);

parameter m=16, k3=5, k2=3, k1=2, n=8;

input wire clk;
input wire [m-1:0] A_in, B_in;
output reg [m-1:0] C_out;

wire[n-1:0] AH_AL, BH_BL;
wire[2*n-2:0] c_high, c_low, c_high_low, c_mix;
wire[m-1:0] C_mod;
wire[2*m-2:0] C_partial; //C_out without mudular operation
wire[m-1:0] C_out_wire;

assign AH_AL = A_in[m-1:m/2] ^ A_in[m/2-1:0];
assign BH_BL = B_in[m-1:m/2] ^ B_in[m/2-1:0];
assign c_mix = c_high ^ c_low ^ c_high_low;

assign C_partial = {c_high[2*n-2:n-1], c_high[n-2:0]^c_mix[2*n-2:n], c_mix[n-1], c_mix[n-2:0]^c_low[2*n-2:n], c_low[n-1:0]}; //AH*BH*x^m+AL*BL+[(AH+AL)(BH+BL)+AH*BH+AL*BL]*x^n

assign C_mod = {C_partial[29]^C_partial[28]^C_partial[26],
					 C_partial[30:25]^C_partial[28:23]^C_partial[27:22]^C_partial[25:20],
					 C_partial[24:21]^C_partial[22:19]^C_partial[21:18]^C_partial[19:16]^C_partial[30:27],
					 C_partial[20]^C_partial[18]^C_partial[17]^C_partial[30]^C_partial[29]^C_partial[28],
					 C_partial[19]^C_partial[17]^C_partial[16]^C_partial[30]^C_partial[29]^C_partial[28]^C_partial[27],
					 C_partial[18]^C_partial[16]^C_partial[30]^C_partial[27],
					 C_partial[17]^C_partial[30]^C_partial[28],
					 C_partial[16]^C_partial[30]^C_partial[29]^C_partial[27]};
					 
assign C_out_wire = C_mod ^ C_partial[m-1:0];

Mul_MultiCore    my_MultiCore0    (.a_in(A_in[m-1:m/2]), .b_in(B_in[m-1:m/2]), .c_out(c_high)); //high 8-bit multiplication
Mul_MultiCore    my_MultiCore1    (.a_in(A_in[m/2-1:0]), .b_in(B_in[m/2-1:0]), .c_out(c_low)); //low 8-bit multiplication
Mul_MultiCore    my_MultiCore2    (.a_in(AH_AL), .b_in(BH_BL), .c_out(c_high_low)); //(AH+AL)(BH+BL)

always @ (posedge clk)
begin
	C_out <= C_out_wire;
end

endmodule
