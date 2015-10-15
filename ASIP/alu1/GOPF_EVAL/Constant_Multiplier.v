
module Constant_Multiplier(
	clk,
	A,
	C);

parameter m=16, k2=5, k1=3, k0=2;

input wire clk;
input wire [0:m-1] A;
output reg [0:m-1] C;


wire [m-1:0] Ax, Ax2, Ax3, Ax4, Ax5, Ax6, Ax7, Ax8, Ax9, Ax10, Ax11, Ax12, Ax13, Ax14, Ax15;
wire [m-1:0] C_Buffer;

//adjust input and output data format
reg [m-1:0] A_inv;
reg	[m-1:0] C_inv;

integer i;
always @ (*)
begin
	for(i=0; i<m; i=i+1) begin
		A_inv[i] = A[i];
		C[i] = C_inv[i];
	end
end

//assign A = A;
assign Ax   = {A_inv[14:5],    A_inv[4]^A_inv[15],       A_inv[3],    A_inv[2]^A_inv[15],       A_inv[1]^A_inv[15],       A_inv[0],    A_inv[15]};
assign Ax2  = {Ax[14:5],   Ax[4]^Ax[15],     Ax[3],   Ax[2]^Ax[15],     Ax[1]^Ax[15],     Ax[0],   Ax[15]};
assign Ax3  = {Ax2[14:5],  Ax2[4]^Ax2[15],   Ax2[3],  Ax2[2]^Ax2[15],   Ax2[1]^Ax2[15],   Ax2[0],  Ax2[15]};
assign Ax4  = {Ax3[14:5],  Ax3[4]^Ax3[15],   Ax3[3],  Ax3[2]^Ax3[15],   Ax3[1]^Ax3[15],   Ax3[0],  Ax3[15]};
assign Ax5  = {Ax4[14:5],  Ax4[4]^Ax4[15],   Ax4[3],  Ax4[2]^Ax4[15],   Ax4[1]^Ax4[15],   Ax4[0],  Ax4[15]};
assign Ax6  = {Ax5[14:5],  Ax5[4]^Ax5[15],   Ax5[3],  Ax5[2]^Ax5[15],   Ax5[1]^Ax5[15],   Ax5[0],  Ax5[15]};
assign Ax7  = {Ax6[14:5],  Ax6[4]^Ax6[15],   Ax6[3],  Ax6[2]^Ax6[15],   Ax6[1]^Ax6[15],   Ax6[0],  Ax6[15]};
assign Ax8  = {Ax7[14:5],  Ax7[4]^Ax7[15],   Ax7[3],  Ax7[2]^Ax7[15],   Ax7[1]^Ax7[15],   Ax7[0],  Ax7[15]};
assign Ax9  = {Ax8[14:5],  Ax8[4]^Ax8[15],   Ax8[3],  Ax8[2]^Ax8[15],   Ax8[1]^Ax8[15],   Ax8[0],  Ax8[15]};
assign Ax10 = {Ax9[14:5],  Ax9[4]^Ax9[15],   Ax9[3],  Ax9[2]^Ax9[15],   Ax9[1]^Ax9[15],   Ax9[0],  Ax9[15]};
assign Ax11 = {Ax10[14:5], Ax10[4]^Ax10[15], Ax10[3], Ax10[2]^Ax10[15], Ax10[1]^Ax10[15], Ax10[0], Ax10[15]};
assign Ax12 = {Ax11[14:5], Ax11[4]^Ax11[15], Ax11[3], Ax11[2]^Ax11[15], Ax11[1]^Ax11[15], Ax11[0], Ax11[15]};
assign Ax13 = {Ax12[14:5], Ax12[4]^Ax12[15], Ax12[3], Ax12[2]^Ax12[15], Ax12[1]^Ax12[15], Ax12[0], Ax12[15]};
assign Ax14 = {Ax13[14:5], Ax13[4]^Ax13[15], Ax13[3], Ax13[2]^Ax13[15], Ax13[1]^Ax13[15], Ax13[0], Ax13[15]};
assign Ax15 = {Ax14[14:5], Ax14[4]^Ax14[15], Ax14[3], Ax14[2]^Ax14[15], Ax14[1]^Ax14[15], Ax14[0], Ax14[15]};

assign C_Buffer = A_inv ^ Ax2 ^ Ax4 ^ Ax6 ^ Ax10 ^ Ax13 ^ Ax15;

always @ (posedge clk)
begin
	C_inv <= C_Buffer;
end

endmodule

	
