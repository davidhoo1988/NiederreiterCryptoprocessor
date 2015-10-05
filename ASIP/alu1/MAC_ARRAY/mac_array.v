module MAC_ARRAY(
	//input
	clk,

	multiplicand01,
	multiplier01,
	adder01,
	multiplicand02,
	multiplier02,
	adder02,
	multiplicand03,
	multiplier03,
	adder03,
	multiplicand04,
	multiplier04,
	adder04,
	multiplicand05,
	multiplier05,
	adder05,
	multiplicand06,
	multiplier06,
	adder06,
	multiplicand07,
	multiplier07,
	adder07,
	multiplicand08,
	multiplier08,
	adder08,
	multiplicand09,
	multiplier09,
	adder09,
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

input wire 	[0:m-1] 	adder01, adder02, adder03, adder04, 
						adder05, adder06, adder07, adder08, 
						adder09;												

output wire [0:m-1] 	result01, result02, result03, result04, 
						result05, result06, result07, result08, 
						result09;

//----------------------------------------------------------
//9 * GF(2^m) multipliers
//----------------------------------------------------------		
		ALU_Multiplier		BF_MUL01(
		.A_in(multiplicand01), 
		.B_in(multiplier01),
		.ADD_in(adder01),
		.C_out(result01),
		.clk(clk));
						
		ALU_Multiplier		BF_MUL02(
		.A_in(multiplicand02), 
		.B_in(multiplier02),
		.ADD_in(adder02),
		.C_out(result02),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL03(
		.A_in(multiplicand03), 
		.B_in(multiplier03),
		.ADD_in(adder03),
		.C_out(result03),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL04(
		.A_in(multiplicand04), 
		.B_in(multiplier04),
		.ADD_in(adder04),
		.C_out(result04),
		.clk(clk));
						
		ALU_Multiplier		BF_MUL05(
		.A_in(multiplicand05), 
		.B_in(multiplier05),
		.ADD_in(adder05),
		.C_out(result05),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL06(
		.A_in(multiplicand06), 
		.B_in(multiplier06),
		.ADD_in(adder06),
		.C_out(result06),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL07(
		.A_in(multiplicand07), 
		.B_in(multiplier07),
		.ADD_in(adder07),
		.C_out(result07),
		.clk(clk));
						
		ALU_Multiplier		BF_MUL08(
		.A_in(multiplicand08), 
		.B_in(multiplier08),
		.ADD_in(adder08),
		.C_out(result08),
		.clk(clk));
		
		ALU_Multiplier		BF_MUL09(
		.A_in(multiplicand09), 
		.B_in(multiplier09),
		.ADD_in(adder09),
		.C_out(result09),
		.clk(clk));
		
endmodule
