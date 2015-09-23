module MUL_ARRAY(
	//input
	clk,

	multiplicand01,
	multiplier01,
	multiplicand02,
	multiplier02,
	multiplicand03,
	multiplier03,
	multiplicand04,
	multiplier04,
	multiplicand05,
	multiplier05,
	multiplicand06,
	multiplier06,
	multiplicand07,
	multiplier07,
	multiplicand08,
	multiplier08,
	multiplicand09,
	multiplier09,
	
	//output
	result01,
	result02,
	result03,
	result04,
	result05,	
	result06,	
	result07,
	result08,
	result09	
);

parameter m = 16;
//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
input wire 				clk;

input wire 	[0:m-1] 	multiplicand01, multiplicand02, multiplicand03, multiplicand04, 
						multiplicand05, multiplicand06, multiplicand07, multiplicand08, 
						multiplicand09;
						
input wire 	[0:m-1] 	multiplier01, multiplier02, multiplier03, multiplier04, 
						multiplier05, multiplier06, multiplier07, multiplier08, 
						multiplier09;						

output wire [0:m-1] 	result01, result02, result03, result04, 
						result05, result06, result07, result08, 
						result09;

//----------------------------------------------------------
//9 * GF(2^m) multipliers
//----------------------------------------------------------		
		ALU_Multiplier		BF_MUL01(
		.A_in(multiplicand01), 
		.B_in(multiplier01),
		.C_out(result01),
		.clk(clk));
						
		ALU_Multiplier		BF_MUL02(
		.A_in(multiplicand02), 
		.B_in(multiplier02),
		.C_out(result02),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL03(
		.A_in(multiplicand03), 
		.B_in(multiplier03),
		.C_out(result03),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL04(
		.A_in(multiplicand04), 
		.B_in(multiplier04),
		.C_out(result04),
		.clk(clk));
						
		ALU_Multiplier		BF_MUL05(
		.A_in(multiplicand05), 
		.B_in(multiplier05),
		.C_out(result05),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL06(
		.A_in(multiplicand06), 
		.B_in(multiplier06),
		.C_out(result06),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL07(
		.A_in(multiplicand07), 
		.B_in(multiplier07),
		.C_out(result07),
		.clk(clk));
						
		ALU_Multiplier		BF_MUL08(
		.A_in(multiplicand08), 
		.B_in(multiplier08),
		.C_out(result08),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL09(
		.A_in(multiplicand09), 
		.B_in(multiplier09),
		.C_out(result09),
		.clk(clk));
		
endmodule