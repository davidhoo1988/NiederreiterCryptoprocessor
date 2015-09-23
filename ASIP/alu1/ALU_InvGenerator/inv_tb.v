`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define DAT_W  16

module inv_tb();
		reg 				clk, en_inv, alu_o_sel;
		reg [0:`DAT_W-1] 	inv_in;       
		wire[0:`DAT_W-1] 	inv_out, inv_o_reg_out, inv_t_reg_out;
		wire[0:`DAT_W-1]	mul_o_in, mul_t_in, mul_dat;

		
ALU_Multiplier		my_ALU_Multiplier(
						.A_in(mul_o_in), 
						.B_in(mul_t_in),
						.C_out(mul_dat),
						.clk(clk));

ALU_InvGenerator	my_ALU_InvGenerator(
						.clk(clk), 
						.rst(en_inv),
						.inv_in(inv_in), 
						.inv_out(inv_out), 
						.product_in(mul_dat), 
						.operandA_out(inv_o_reg_out), 
						.operandB_out(inv_t_reg_out), 
						.alu_o_sel(alu_o_sel));
						
assign mul_o_in =  inv_o_reg_out;
assign mul_t_in =  inv_t_reg_out;

initial begin
		// Initialize Inputs
		clk 		= 1;
		en_inv 		= 0;
		alu_o_sel	= 0;		

		#(5*`CLK_PERIOD) 	
		en_inv 		= 1'b1;		
		alu_o_sel 	= 1'b1;	
		inv_in 		= `DAT_W'h0f0f;
		#(`CLK_PERIOD) 		
		alu_o_sel 	= 1'b0;
end
	
	initial begin
	
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
	end
      
endmodule						  
