

module ALU_Multiplier(
					A_in, 
					B_in, 
					C_out,
					clk);

parameter m=16, k3=5, k2=3, k1=2, n=8;

input wire clk;
input wire [0:m-1] 	A_in, B_in;
output reg [0:m-1] C_out;

reg [m-1:0] 	A_inv_in, B_inv_in;
wire [m-1:0] 	C_inv_out;
integer i;

always @ (*)
begin
	for(i=0; i<m; i=i+1) begin
		A_inv_in[i] = A_in[i];
		B_inv_in[i] = B_in[i];
	end
end


wire [m-2:0] AHBHMulNet, ALBLMulNet, ZAZBMulNet, Sub;
wire [m-1:0] AHBHMulX8, AHBHMulX16, Z1Net;

reg [m/2-1:0] AHALAdd, BHBLAdd;
reg [m-2:0] AHBHMul, ALBLMul, ZAZBMul, PHPLAdd, ALBLMul1;
reg [m-1:0] AHBHMul1, Z1, Z0Z2Add;


Mul_MultiCore	my_Mul_MultiCore0(
					.a_in(A_inv_in[m-1:m/2]), 
					.b_in(B_inv_in[m-1:m/2]), 
					.c_out(AHBHMulNet));
					
Mul_MultiCore	my_Mul_MultiCore1(
					.a_in(A_inv_in[m/2-1:0]), 
					.b_in(B_inv_in[m/2-1:0]), 
					.c_out(ALBLMulNet));

Mul_MultiCore	my_Mul_MultiCore2(
					.a_in(AHALAdd), 
					.b_in(BHBLAdd), 
					.c_out(ZAZBMulNet));

Mul_ModularX8	my_Mul_ModularX80(
					.D_in({1'b0, AHBHMul}),
					.Q_out(AHBHMulX8));

Mul_ModularX8	my_Mul_ModularX81(
					.D_in(AHBHMulX8),
					.Q_out(AHBHMulX16));

Mul_ModularX8	my_Mul_ModularX82(
					.D_in({1'b0, Sub}),
					.Q_out(Z1Net));

assign Sub = ZAZBMul ^ PHPLAdd;
assign C_inv_out = Z1 ^ Z0Z2Add;

always @ (*)
begin
	for(i=0; i<m; i=i+1)
		C_out[i] = C_inv_out[i];
end

always@(posedge clk)
begin
	AHALAdd <= A_inv_in[m-1:m/2] ^ A_inv_in[m/2-1:0];
	BHBLAdd <= B_inv_in[m-1:m/2] ^ B_inv_in[m/2-1:0];
	AHBHMul <= AHBHMulNet;
	ALBLMul <= ALBLMulNet;
	
	ZAZBMul <= ZAZBMulNet;
	PHPLAdd <= AHBHMul ^ ALBLMul;
	AHBHMul1 <= AHBHMulX16;
	ALBLMul1 <= ALBLMul;
	
	Z1 <= Z1Net;
	Z0Z2Add <= {AHBHMul1[m-1], AHBHMul1[m-2:0] ^ ALBLMul1};

end

endmodule
