//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/alu.v
//  File Revision        : 1.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2014.12		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module is the arithmetic & logic core of our processor
//  ----------------------------------------------------------------------------
//===============================================================================

//===============================================================================
//this ALU module contians four regs, three for input operands as well as instruction 
//code, and one for output.
// 
//Modified by Wangchen DAI 20/01/2015
//===============================================================================
// synthesis translate_on
`include "../include/define.v"
`include "../include/timescale.v"
`define  DAT_W_MINUS_ONE 	143

 module ALU
(
	input wire							clk,
	input wire							rst_b,
	input wire							alu_o_sel, //'1' for triggering the data fetch from external bus
	input wire							alu_t_sel, //'1' for triggering the data fetch from external bus
	input wire 							alu_mod_sel,//'1' for triggering the data fetch from external bus
	input wire [0:`LDAT_W-1] 			alu_o_dat,   //operand data from bus
	input wire [0:`DAT_W-1] 			alu_t_dat,
	input wire [0:`LDAT_W-1]			alu_mod_dat,
	input wire [`ALU_TYP_W-1:0]			alu_typ_sel, //4'b0001 for add; 4'b0010 for sub; 4'b0011 for mul; 4'b0100 for zero estimation; 4'b0101 for inverse
	
	output wire [0:`DAT_W-1]			alu_r_dat1,
	output wire [0:`DAT_W-1]			alu_r_dat2,  //reserved for polynomial div remainder
	output wire 						compute_done //indicate MUL and DIV finished
);

parameter m = 16;
//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg [0:`DAT_W-1] 	alu_reg_dat, alu_reg_dat2;
reg [0:`LDAT_W-1] 	alu_o_reg; //note it could be Goppa polynomial
reg [0:`DAT_W-1] 	alu_t_reg;
reg	[0:`LDAT_W-1]	alu_mod_reg;

reg [3:0] 			trg_typ_reg;

wire 				non_zero_sel;
wire [0:`DAT_W-1] 	add_sub_dat;

wire [0:`DAT_W-1] 	mul_dat; 
wire				mul_done;

wire 				en_mul;
reg 				en_mul_reg;

wire [0:m-1]		mul1_o_in, mul2_o_in, mul3_o_in, 
					mul4_o_in, mul5_o_in, mul6_o_in,   
					mul7_o_in, mul8_o_in, mul9_o_in,
					
					mul_t_in,
					
					mul1_r_dat, mul2_r_dat, mul3_r_dat,
					mul4_r_dat, mul5_r_dat, mul6_r_dat,
					mul7_r_dat, mul8_r_dat, mul9_r_dat;
					
wire [0:`DAT_W-1] 	quotient_dat, remainder_dat;
wire				div_done;

wire 				en_inv; //enable polynomial division
reg 				en_inv_reg;

wire [0:m-1]		div1_o_out, div2_o_out, div3_o_out,
					div4_o_out, div5_o_out, div6_o_out,
					div7_o_out, div8_o_out, div9_o_out,
					
					div_t_out;
					
wire 				inv_en, inv_enable, inv_trg, invgenerator_trg, invgenerator_rst; //enable GF(2^m) inverse
reg 				inv_enable_reg, alu_o_sel_reg;

wire [0:m-1]		inv_out, inv_dat_in, inv_dat_out;
wire [0:m-1]		operandA_out, operandB_out;

wire [0:m-1]		multiplicand01, multiplicand02, multiplicand03,
					multiplicand04, multiplicand05, multiplicand06,
					multiplicand07, multiplicand08, multiplicand09,
					
					multiplier01, multiplier02, multiplier03,
					multiplier04, multiplier05, multiplier06,
					multiplier07, multiplier08, multiplier09;
					
					
wire [0:`DAT_W-1] 	alu_o_reg_out, alu_t_reg_out, inv_o_reg_out, inv_t_reg_out;

//split singal declared
wire 				en_split;
reg 				en_split_reg;
wire				split_done;
wire [0:`DAT_W-1]	first_fragment_out, second_fragment_out;

//deg signal declared
wire 				en_deg;
reg 				en_deg_reg;
wire 				deg_done;
wire [3:0] 			poly_deg_out;

//rshift signal declared
wire				en_rshift;
reg 				en_rshift_tmp1, en_rshift_tmp2;
reg 				rshift_done;

//gopf_eval signal declared
wire 				en_eval;
reg 				en_eval_reg;
wire [0:`DAT_W-1] 	eval_r_dat;
wire 				eval_done;

wire [0:m-1] 		eval1_o_out,eval2_o_out,eval3_o_out,
					eval4_o_out,eval5_o_out,eval6_o_out,
					eval7_o_out,eval8_o_out,eval9_o_out;

wire [0:m-1]		eval1_t_out,eval2_t_out,eval3_t_out,
					eval4_t_out,eval5_t_out,eval6_t_out,
					eval7_t_out,eval8_t_out,eval9_t_out;

assign alu_o_reg_out = alu_o_reg[0:`DAT_W-1];
assign alu_t_reg_out = alu_t_reg;

assign en_mul = (alu_typ_sel == `ALU_TYP_W'd3 && alu_o_sel == 1'b1 && alu_t_sel == 1'b1) ? 1'b1 : 1'b0;
assign en_inv = (alu_typ_sel == `ALU_TYP_W'd5 && alu_o_sel == 1'b1 && alu_t_sel == 1'b1) ? 1'b1 : 1'b0;
assign en_split = (alu_typ_sel == `ALU_TYP_W'd2 && alu_o_sel == 1'b1 && alu_t_sel ==  1'b1) ? 1'b1 : 1'b0;
assign en_deg = (alu_typ_sel == `ALU_TYP_W'd7 && alu_o_sel == 1'b1 && alu_t_sel == 1'b1) ? 1'b1 : 1'b0;
assign en_rshift = (alu_typ_sel == `ALU_TYP_W'd8 && alu_o_sel == 1'b1 && alu_t_sel == 1'b1) ? 1'b1 : 1'b0;
assign en_eval = (alu_typ_sel == `ALU_TYP_W'd9 && alu_o_sel == 1'b1 && alu_t_sel == 1'b1) ? 1'b1 : 1'b0;

assign non_zero_sel = (alu_t_reg[`DAT_W-16:`DAT_W-1] > alu_o_reg[`DAT_W-16:`DAT_W-1]) ? 1'b1 : 1'b0; 

assign alu_r_dat1 	= alu_reg_dat;
assign alu_r_dat2 	= alu_reg_dat2;
assign compute_done = mul_done | div_done | split_done | deg_done | rshift_done;

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		trg_typ_reg <= 0;
	else
		trg_typ_reg <= alu_typ_sel;	
end

always @ (posedge clk or negedge rst_b)
begin //the behavior of the first operand
	if (!rst_b)
		alu_o_reg <= 0;
	else if(alu_o_sel)  begin//begin to get data from external bus
		alu_o_reg <= alu_o_dat;
	end
	else //preserve the data in the register
		alu_o_reg <= alu_o_reg;
end

always @ (posedge clk or negedge rst_b)
begin //the behavior of the second operand
	if (!rst_b)
		alu_t_reg <= 0;
	else if(alu_t_sel) begin
		alu_t_reg <= alu_t_dat;
	end
	else
		alu_t_reg <= alu_t_reg;
end

always @ (posedge clk or negedge rst_b)
begin //the behavior of the second operand
	if (!rst_b)
		alu_mod_reg <= 0;
	else if(alu_mod_sel) begin
		alu_mod_reg <= alu_mod_dat;
	end
	else
		alu_mod_reg <= alu_mod_reg;
end

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		en_inv_reg <= 0;
	else
		en_inv_reg <= en_inv;	
end
always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		en_mul_reg <= 0;
	else
		en_mul_reg <= en_mul;	
end

always @ (posedge clk or negedge rst_b) 
begin
	if (!rst_b)
		en_split_reg <= 0;
	else
		en_split_reg <= en_split;	
end

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		en_deg_reg <= 0;
	else
		en_deg_reg <= en_deg;	
end


always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		en_rshift_tmp1 <= 0;
	else
		en_rshift_tmp1 <= en_rshift;	
end
always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		en_rshift_tmp2 <= 0;
	else
		en_rshift_tmp2 <= en_rshift_tmp1;	
end
always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		rshift_done <= 0;
	else
		rshift_done <= en_rshift_tmp2;	
end

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		en_eval_reg <= 0;
	else
		en_eval_reg <= en_eval;	
end
//==========================================================
//below has been modified by Wangchen DAI in 29/01/2015
//==========================================================
//the FF16 module is designed and implemented by Wangchen DAI;
//FF16 module could provide GF(2^16) multiplication (3 clk cycles)
//as well as addition (1 clk cycle)
//f(x)=x^16+x^5+x^3+x^2+1 is the irreducible polynomial, 
//which is used to generate the finite field
//==========================================================

//
//----------------------------------------------------------
// logic computation part
//----------------------------------------------------------

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		alu_reg_dat <= 0;
	else
		case (trg_typ_reg)
				//ADD
				`ALU_TYP_W'd1:  begin
					alu_reg_dat 	<= add_sub_dat;
					alu_reg_dat2 	<= `DAT_W'b0;
				end
				//SPLIT
				`ALU_TYP_W'd2:  begin
					alu_reg_dat 	<= first_fragment_out;
					alu_reg_dat2	<= second_fragment_out;
				end
				//MUL
				`ALU_TYP_W'd3:  begin
					alu_reg_dat 	<= mul_dat;
					alu_reg_dat2	<= `DAT_W'b0;
				end	
				//BiggerThan
				`ALU_TYP_W'd4:  begin
					alu_reg_dat 	<= {non_zero_sel,`DAT_W_MINUS_ONE'd0};
					alu_reg_dat2	<= `DAT_W'b0;
				end
				//DIV
				`ALU_TYP_W'd5:  begin
					alu_reg_dat 	<= quotient_dat;
					alu_reg_dat2	<= remainder_dat;
				end	
				//INV
				`ALU_TYP_W'd6:  begin
					alu_reg_dat 	<= {inv_dat_out,128'b0};
					alu_reg_dat2	<= `DAT_W'b0;
				end
				//DEG
				`ALU_TYP_W'd7: begin
					alu_reg_dat 	<= {140'b0,poly_deg_out};
					alu_reg_dat2 	<= `DAT_W'b0;
				end
				//RSHIFT
				`ALU_TYP_W'd8: begin
					alu_reg_dat 	<= {16'b0,alu_o_reg[0:`DAT_W-17]};
					alu_reg_dat2 	<= {alu_o_reg[`DAT_W-16:`DAT_W-1],128'b0}; 
				end
				//GOPF_EVAL
				`ALU_TYP_W'd9: begin
					alu_reg_dat 	<= eval_r_dat;
					alu_reg_dat2	<= `DAT_W'b0;
				end
				default:  		begin
					alu_reg_dat 	<= alu_reg_dat;
					alu_reg_dat2	<= alu_reg_dat2;
				end	
		endcase
end

assign add_sub_dat = alu_o_reg_out ^ alu_t_reg_out;


assign multiplicand01 = (alu_typ_sel == `ALU_TYP_W'h3)? mul1_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval1_o_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandA_out: div1_o_out);
assign multiplicand02 = (alu_typ_sel == `ALU_TYP_W'h3)? mul2_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval2_o_out : div2_o_out;
assign multiplicand03 = (alu_typ_sel == `ALU_TYP_W'h3)? mul3_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval3_o_out : div3_o_out;
assign multiplicand04 = (alu_typ_sel == `ALU_TYP_W'h3)? mul4_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval4_o_out : div4_o_out;
assign multiplicand05 = (alu_typ_sel == `ALU_TYP_W'h3)? mul5_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval5_o_out : div5_o_out;
assign multiplicand06 = (alu_typ_sel == `ALU_TYP_W'h3)? mul6_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval6_o_out : div6_o_out;
assign multiplicand07 = (alu_typ_sel == `ALU_TYP_W'h3)? mul7_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval7_o_out : div7_o_out;
assign multiplicand08 = (alu_typ_sel == `ALU_TYP_W'h3)? mul8_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval8_o_out : div8_o_out;
assign multiplicand09 = (alu_typ_sel == `ALU_TYP_W'h3)? mul9_o_in :(alu_typ_sel == `ALU_TYP_W'd9)?  eval9_o_out : div9_o_out;

assign multiplier01 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval1_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier02 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval2_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier03 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval3_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier04 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval4_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier05 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval5_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier06 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval6_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier07 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval7_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier08 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval8_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);
assign multiplier09 = (alu_typ_sel == `ALU_TYP_W'h3)? mul_t_in : (alu_typ_sel == `ALU_TYP_W'd9)?  eval9_t_out : ((inv_en == 1'b1 || inv_enable == 1'b1)? operandB_out: div_t_out);

GOPF_MUL gopf_mul(
	//input
	.clk				(clk),
	.rst_b				(rst_b),
	.start				(en_mul_reg),
	.multiplicand		(alu_o_reg[0:`LDAT_W-2]),
	.multiplier			(alu_t_reg),
	.mod				(alu_mod_reg[0:`LDAT_W-2]),
	
	//output
	.mul_out			(mul_dat ),
	.mul_done			(mul_done),
	
	//output to MUL_ARRAY
	.mul1_o_out			(mul1_o_in),
	.mul2_o_out			(mul2_o_in),
	.mul3_o_out			(mul3_o_in),
	.mul4_o_out			(mul4_o_in),
	.mul5_o_out			(mul5_o_in),
	.mul6_o_out			(mul6_o_in),
	.mul7_o_out			(mul7_o_in),
	.mul8_o_out			(mul8_o_in),
	.mul9_o_out			(mul9_o_in),
	.mul_t_out			(mul_t_in),
	
	//input from MUL_ARRAY
	.mul1_r_dat			(mul1_r_dat),
	.mul2_r_dat			(mul2_r_dat),
	.mul3_r_dat			(mul3_r_dat),
	.mul4_r_dat			(mul4_r_dat),
	.mul5_r_dat			(mul5_r_dat),
	.mul6_r_dat			(mul6_r_dat),
	.mul7_r_dat			(mul7_r_dat),
	.mul8_r_dat			(mul8_r_dat),
	.mul9_r_dat			(mul9_r_dat)
);

GOPF_DIV gopf_div(
	//input
	.clk				(clk),
	.rst_b				(rst_b),
	.start				(en_inv_reg),
	.dividend			(alu_o_reg),
	.divisor			(alu_t_reg),
	
	//output
	.quotient_out		(quotient_dat),
	.remainder_out		(remainder_dat),
	.div_done			(div_done),
	
	//output to MUL_ARRAY
	.mul1_o_out			(div1_o_out),
	.mul2_o_out			(div2_o_out),
	.mul3_o_out			(div3_o_out),
	.mul4_o_out			(div4_o_out),
	.mul5_o_out			(div5_o_out),
	.mul6_o_out			(div6_o_out),
	.mul7_o_out			(div7_o_out),
	.mul8_o_out			(div8_o_out),
	.mul9_o_out			(div9_o_out),
	.mul_t_out			(div_t_out),	
	//input from MUL_ARRAY
	.mul1_r_dat			(mul1_r_dat),
	.mul2_r_dat			(mul2_r_dat),
	.mul3_r_dat			(mul3_r_dat),
	.mul4_r_dat			(mul4_r_dat),
	.mul5_r_dat			(mul5_r_dat),
	.mul6_r_dat			(mul6_r_dat),
	.mul7_r_dat			(mul7_r_dat),
	.mul8_r_dat			(mul8_r_dat),
	.mul9_r_dat			(mul9_r_dat),
	
	//output to INV_GENERATOR
	.inv_out			(inv_out),
	.inv_en				(inv_en),
	.inv_trg			(inv_trg),
	//input from INV_GENERATOR
	.inv_r_dat			(inv_dat_out)
);

MUL_ARRAY mul_array(
	//input
	.clk				(clk),
	.multiplicand01		(multiplicand01),
	.multiplier01		(multiplier01),
	.multiplicand02		(multiplicand02),
	.multiplier02		(multiplier02),
	.multiplicand03		(multiplicand03),
	.multiplier03		(multiplier03),
	.multiplicand04		(multiplicand04),
	.multiplier04		(multiplier04),
	.multiplicand05		(multiplicand05),
	.multiplier05		(multiplier05),
	.multiplicand06		(multiplicand06),
	.multiplier06		(multiplier06),
	.multiplicand07		(multiplicand07),
	.multiplier07		(multiplier07),
	.multiplicand08		(multiplicand08),
	.multiplier08		(multiplier08),
	.multiplicand09		(multiplicand09),
	.multiplier09		(multiplier09),
	
	//output
	.result01			(mul1_r_dat),
	.result02			(mul2_r_dat),
	.result03			(mul3_r_dat),
	.result04			(mul4_r_dat),
	.result05			(mul5_r_dat),	
	.result06			(mul6_r_dat),	
	.result07			(mul7_r_dat),
	.result08			(mul8_r_dat),
	.result09			(mul9_r_dat)	
);

 ALU_InvGenerator invgenerator(
	.clk				(clk),
	.rst				(invgenerator_rst), 		//from gopf_div
	.inv_in				(inv_dat_in),	//from gopf_div
	.inv_out			(inv_dat_out),	//to gopf_div
	.product_in			(mul1_r_dat),	//from mul_array
	.operandA_out		(operandA_out),	//from mul_array
	.operandB_out		(operandB_out),	//from mul_array
	.alu_o_sel			(invgenerator_trg)		//from gopf_div, pulse signal to trigger inverter
);



SPLIT split(
	//input
	.clk 				(clk),
	.rst_b				(rst_b),
	.start              (en_split_reg),
	.poly_in			(alu_o_reg[0:`DAT_W-1]),
	//output
	.first_fragment_out	(first_fragment_out),
	.second_fragment_out(second_fragment_out),
	.split_done			(split_done)
);


DEG deg(
	//input
	.clk 				(clk),
	.rst_b 				(rst_b),
	.start 				(en_deg_reg),
	.poly_in 			(alu_o_reg[0:`DAT_W-1]),
	//output
	.poly_deg_out       (poly_deg_out),
	.deg_done 			(deg_done)
);

GOPF_EVAL gopf_eval(
	//input
	.clk 				(clk),
	.rst_b 				(rst_b),
	.start				(en_eval_reg),
	.gopf 				(alu_o_reg),
	.gf2e_element 		(alu_t_reg),
	
	//output
	.eval_r_dat 		(eval_r_dat),
	.eval_done			(eval_done),
	
	//output to MUL_ARRAY
	.mul1_o_out 		(eval1_o_out),
	.mul2_o_out 		(eval2_o_out),
	.mul3_o_out 		(eval3_o_out),
	.mul4_o_out 		(eval4_o_out),
	.mul5_o_out 		(eval5_o_out),
	.mul6_o_out 		(eval6_o_out),
	.mul7_o_out 		(eval7_o_out),
	.mul8_o_out 		(eval8_o_out),
	.mul9_o_out 		(eval9_o_out),

	.mul1_t_out 		(eval1_t_out),	
	.mul2_t_out 		(eval2_t_out),	
	.mul3_t_out 		(eval3_t_out),	
	.mul4_t_out 		(eval4_t_out),	
	.mul5_t_out 		(eval5_t_out),	
	.mul6_t_out 		(eval6_t_out),	
	.mul7_t_out 		(eval7_t_out),	
	.mul8_t_out 		(eval8_t_out),	
	.mul9_t_out 		(eval9_t_out),	
	//input from MUL_ARRAY
	.mul1_r_dat 		(mul1_r_dat),
	.mul2_r_dat 		(mul2_r_dat),
	.mul3_r_dat 		(mul3_r_dat),
	.mul4_r_dat 		(mul4_r_dat),
	.mul5_r_dat 		(mul5_r_dat),
	.mul6_r_dat 		(mul6_r_dat),
	.mul7_r_dat 		(mul7_r_dat),
	.mul8_r_dat 		(mul8_r_dat),
	.mul9_r_dat 		(mul9_r_dat)
);

assign inv_dat_in = (trg_typ_reg==`ALU_TYP_W'd6)? alu_o_reg_out[0:m-1] : inv_out;
assign invgenerator_trg = (alu_typ_sel==`ALU_TYP_W'd6)? alu_o_sel_reg : inv_trg;
assign inv_enable = (alu_typ_sel==`ALU_TYP_W'd6)? 1'b1 : 1'b0;
assign invgenerator_rst = inv_en || inv_enable_reg;

always @(posedge clk or negedge rst_b) begin
	if (!rst_b)
		inv_enable_reg <= 0;
	else
		inv_enable_reg <= inv_enable;	
end

always @(posedge clk or negedge rst_b) begin
	if (!rst_b)
		alu_o_sel_reg <= 0;
	else
		alu_o_sel_reg <= alu_o_sel;	
end

endmodule

