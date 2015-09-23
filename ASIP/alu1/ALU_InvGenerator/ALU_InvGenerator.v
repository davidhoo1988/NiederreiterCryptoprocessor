module ALU_InvGenerator(
				clk,
				rst,
				inv_in,
				inv_out,
				product_in,
				operandA_out,
				operandB_out,
				alu_o_sel
);

parameter m=16;

input wire 			clk, rst, alu_o_sel;
input wire [0:m-1] 	inv_in, product_in;

output reg 	[0:m-1] inv_out;
output reg	[0:m-1] operandA_out, operandB_out;


wire 			mux0_ctrl;
wire [1:0] 		exp_ctrl, reg_ctrl;
wire [m-1:0]  	operandA_out_temp, operandB_out_temp;
wire [m-1:0] 	muxA_in, muxB_in, exp_in;

/*reversing*/
reg [m-1:0] reverse_inv_in, reverse_product_in;
integer i;
always @ (*)
begin
	for(i=0; i<m; i=i+1) begin
		reverse_inv_in[i] 		= inv_in[i];
		reverse_product_in[i] 	= product_in[i];
	end
end

Inv_Reg0	my_Inv_Reg0(
						.clk(clk), 
						.rst(rst), 
						.init(reg_ctrl[1]), 
						.en(reg_ctrl[0]), 
						.reg_in(reverse_product_in), 
						.reg_init(reverse_inv_in), 
						.reg_out0(muxA_in), 
						.reg_out1(muxB_in));
						
Inv_Reg1 my_Inv_Reg1(
						.clk(clk), 
						.rst(rst),
						.init(reg_ctrl[1]), 
						.en(reg_ctrl[0]),
						.reg_init(reverse_inv_in),
						.reg_in(reverse_product_in), 
						.reg_out(exp_in));
						
Inv_Mux		my_Inv_Mux0(
						.ctrl(mux0_ctrl), 
						.d_0(muxA_in), 
						.d_1(muxB_in), 
						.q(operandA_out_temp));

Inv_Exp		my_Inv_Exp(
						.ctrl(exp_ctrl), 
						.d(exp_in),
						.q(operandB_out_temp));

Inv_Ctrl	my_Inv_Ctrl(
						.clk(clk), 
						.rst(rst), 
						.inv_cSignal({
								reg_ctrl, 
								mux0_ctrl,
								exp_ctrl}), 
						.alu_o_sel(alu_o_sel));

always@ (*) begin
	for (i=0; i<m; i=i+1) begin
		inv_out[i] = operandB_out_temp[i];
	end
end


always@(posedge clk)
begin
	for (i=0; i<m; i=i+1) begin
		operandA_out[i] <= operandA_out_temp[i];
		operandB_out[i] <= operandB_out_temp[i];
	end
end

endmodule