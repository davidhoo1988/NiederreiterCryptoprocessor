//===============================================================================
//  File Name            : ./auto/ins_decoder.v
//  File Revision        : 1.0
//  Author               : David
//  History:            
//								2014.11		Rev 1.0		David J.W. HU
//								2015.08 	Rev 2.0 	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This is the top module for instruction decoder.   				   
//  ----------------------------------------------------------------------------

// synthesis translate_on
`include    "../include/define.v"


module ins_decoder(
	//input
	input 	[`INS_W-1:0]			instruction,
	//output from src
	output 							dec_src_dat_ram_addr_en_b,
	output 	[`DMEMADDRW-1:0]		dec_src_dat_ram_addr,
	output 							dec_src_imm_dat_sel,
	output 	[`IMM_DAT_W-1:0]		dec_src_imm_dat,
	output 							dec_src_indir_addr_sel,
	
	output 							dec_src_r0_r_sel,dec_src_r1_r_sel,dec_src_r2_r_sel,dec_src_r3_r_sel,
									dec_src_r4_r_sel,dec_src_r5_r_sel,dec_src_r6_r_sel,dec_src_r7_r_sel,

	output							dec_src_sprf0_r_sel,dec_src_sprf1_r_sel, 							

	output 							dec_src_r0_t_sel,dec_src_r1_t_sel,dec_src_r2_t_sel,dec_src_r3_t_sel,
									dec_src_r4_t_sel,dec_src_r5_t_sel,dec_src_r6_t_sel,dec_src_r7_t_sel,

	
	output 							dec_src_rmod_t_sel,
	//output from dst	
	output 							dec_dst_dat_ram_addr_en_b,
	output 							dec_dst_dat_ram_rw, // 1 read and 0 write
	output 	[`DMEMADDRW-1:0]		dec_dst_dat_ram_addr,
	output 							dec_dst_indir_addr_sel,
	

	output 							dec_dst_r0_r_sel,dec_dst_r1_r_sel,dec_dst_r2_r_sel,dec_dst_r3_r_sel,
									dec_dst_r4_r_sel,dec_dst_r5_r_sel,dec_dst_r6_r_sel,dec_dst_r7_r_sel,
									
	output							dec_dst_sprf0_r_sel,dec_dst_sprf1_r_sel,						

	output 							dec_dst_r0_t_sel,dec_dst_r1_t_sel,dec_dst_r2_t_sel,dec_dst_r3_t_sel,
									dec_dst_r4_t_sel,dec_dst_r5_t_sel,dec_dst_r6_t_sel,dec_dst_r7_t_sel,
									

	output 							dec_dst_rmod_t_sel,

	output 							dec_dst_jmp_addr_sel,
	output [`DST_W-1:0]				dec_dst_jmp_addr,
								
	//output from opr
	output [`OPR_W-1:0]				dec_opr_typ_sel,
	output 							dec_opr_div_mod_sel,
	
	output 							dec_alu_o_sel, //'1' for triggering the data fetch from external bus
	output 							dec_alu_t_sel, //'1' for triggering the data fetch from external bus
	output [`ALU_TYP_W-1:0]			dec_alu_typ_sel,
	
	output							dec_prng_t_sel,
	output [`PRNG_TYP_W-1:0]		dec_prng_typ_sel,
	
	output [`SPRF_TYP_W-1:0] 		dec_sprf_r0_typ_sel, dec_sprf_r1_typ_sel,
	
	output 							dec_delay_src_dst_sel,
	output [`DLY_W-1:0]				dec_delay_src_dst
);

wire [`OPR_W-1:0]	opr_code;
wire [`SRC_W-1:0]	src_code;
wire [`DST_W-1:0]	dst_code;

// these signals must be locked when instruction is 'nop'
wire 							dec_src_dat_ram_addr_en_b_norm;
wire 							dec_dst_dat_ram_addr_en_b_norm;

wire 							dec_src_r0_r_sel_norm,dec_src_r1_r_sel_norm,dec_src_r2_r_sel_norm,dec_src_r3_r_sel_norm,
								dec_src_r4_r_sel_norm,dec_src_r5_r_sel_norm,dec_src_r6_r_sel_norm,dec_src_r7_r_sel_norm;
								
wire 							dec_src_r0_t_sel_norm,dec_src_r1_t_sel_norm,dec_src_r2_t_sel_norm,dec_src_r3_t_sel_norm,
								dec_src_r4_t_sel_norm,dec_src_r5_t_sel_norm,dec_src_r6_t_sel_norm,dec_src_r7_t_sel_norm;


wire 							dec_src_rmod_t_sel_norm;

wire 							dec_src_sprf0_r_sel_norm, dec_src_sprf1_r_sel_norm;

wire 							dec_dst_r0_t_sel_norm,dec_dst_r1_t_sel_norm,dec_dst_r2_t_sel_norm,dec_dst_r3_t_sel_norm,
								dec_dst_r4_t_sel_norm,dec_dst_r5_t_sel_norm,dec_dst_r6_t_sel_norm,dec_dst_r7_t_sel_norm;
								
wire 							dec_dst_rmod_t_sel_norm;

wire 							dec_dst_r0_r_sel_norm,dec_dst_r1_r_sel_norm,dec_dst_r2_r_sel_norm,dec_dst_r3_r_sel_norm,
								dec_dst_r4_r_sel_norm,dec_dst_r5_r_sel_norm,dec_dst_r6_r_sel_norm,dec_dst_r7_r_sel_norm;
						


wire 							dec_dst_sprf0_r_sel_norm, dec_dst_sprf1_r_sel_norm;
					

assign dec_src_dat_ram_addr_en_b 	= (instruction !=`INS_W'b0)? dec_src_dat_ram_addr_en_b_norm : 1'b1;
assign dec_dst_dat_ram_addr_en_b 	= (instruction !=`INS_W'b0)? dec_dst_dat_ram_addr_en_b_norm : 1'b1;

assign dec_src_r0_r_sel				= (instruction !=`INS_W'b0)? dec_src_r0_r_sel_norm : 1'b0;
assign dec_src_r1_r_sel				= (instruction !=`INS_W'b0)? dec_src_r1_r_sel_norm : 1'b0;
assign dec_src_r2_r_sel				= (instruction !=`INS_W'b0)? dec_src_r2_r_sel_norm : 1'b0;
assign dec_src_r3_r_sel				= (instruction !=`INS_W'b0)? dec_src_r3_r_sel_norm : 1'b0;
assign dec_src_r4_r_sel				= (instruction !=`INS_W'b0)? dec_src_r4_r_sel_norm : 1'b0;
assign dec_src_r5_r_sel				= (instruction !=`INS_W'b0)? dec_src_r5_r_sel_norm : 1'b0;
assign dec_src_r6_r_sel				= (instruction !=`INS_W'b0)? dec_src_r6_r_sel_norm : 1'b0;
assign dec_src_r7_r_sel				= (instruction !=`INS_W'b0)? dec_src_r7_r_sel_norm : 1'b0;


assign dec_src_r0_t_sel				= (instruction !=`INS_W'b0)? dec_src_r0_t_sel_norm : 1'b0;
assign dec_src_r1_t_sel				= (instruction !=`INS_W'b0)? dec_src_r1_t_sel_norm : 1'b0;
assign dec_src_r2_t_sel				= (instruction !=`INS_W'b0)? dec_src_r2_t_sel_norm : 1'b0;
assign dec_src_r3_t_sel				= (instruction !=`INS_W'b0)? dec_src_r3_t_sel_norm : 1'b0;
assign dec_src_r4_t_sel				= (instruction !=`INS_W'b0)? dec_src_r4_t_sel_norm : 1'b0;
assign dec_src_r5_t_sel				= (instruction !=`INS_W'b0)? dec_src_r5_t_sel_norm : 1'b0;
assign dec_src_r6_t_sel				= (instruction !=`INS_W'b0)? dec_src_r6_t_sel_norm : 1'b0;
assign dec_src_r7_t_sel				= (instruction !=`INS_W'b0)? dec_src_r7_t_sel_norm : 1'b0;


assign dec_src_rmod_t_sel 			= (instruction !=`INS_W'b0)? dec_src_rmod_t_sel_norm : 1'b0;

assign dec_src_sprf0_r_sel			= (instruction !=`INS_W'b0)? dec_src_sprf0_r_sel_norm : 1'b0;
assign dec_src_sprf1_r_sel			= (instruction !=`INS_W'b0)? dec_src_sprf1_r_sel_norm : 1'b0;


assign dec_dst_r0_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r0_t_sel_norm : 1'b0;
assign dec_dst_r1_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r1_t_sel_norm : 1'b0;
assign dec_dst_r2_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r2_t_sel_norm : 1'b0;
assign dec_dst_r3_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r3_t_sel_norm : 1'b0;
assign dec_dst_r4_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r4_t_sel_norm : 1'b0;
assign dec_dst_r5_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r5_t_sel_norm : 1'b0;
assign dec_dst_r6_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r6_t_sel_norm : 1'b0;
assign dec_dst_r7_t_sel				= (instruction !=`INS_W'b0)? dec_dst_r7_t_sel_norm : 1'b0;



assign dec_dst_r0_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r0_r_sel_norm : 1'b0;
assign dec_dst_r1_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r1_r_sel_norm : 1'b0;
assign dec_dst_r2_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r2_r_sel_norm : 1'b0;
assign dec_dst_r3_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r3_r_sel_norm : 1'b0;
assign dec_dst_r4_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r4_r_sel_norm : 1'b0;
assign dec_dst_r5_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r5_r_sel_norm : 1'b0;
assign dec_dst_r6_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r6_r_sel_norm : 1'b0;
assign dec_dst_r7_r_sel				= (instruction !=`INS_W'b0)? dec_dst_r7_r_sel_norm : 1'b0;


assign dec_dst_sprf0_r_sel			= (instruction !=`INS_W'b0)? dec_dst_sprf0_r_sel_norm : 1'b0;
assign dec_dst_sprf1_r_sel			= (instruction !=`INS_W'b0)? dec_dst_sprf1_r_sel_norm : 1'b0;


assign dec_dst_rmod_t_sel 			= (instruction !=`INS_W'b0)? dec_dst_rmod_t_sel_norm : 1'b0;

ins_slicer ins_slicer(
	//input
	.instruction	(instruction),
	//output
	.bus1_opr_code	(opr_code),
	.bus1_src_code	(src_code),
	.bus1_dst_code	(dst_code)
);

opr_decoder opr_decoder(
	//input
	.opr_code		(opr_code),
	.dst_code 		(dst_code),
	.src_typ		(src_code[`SRC_W-1:`SRC_W-3]),
	.dst_typ		(dst_code[`DST_W-1:`DST_W-3]),
	//output
	.opr_typ_sel	(dec_opr_typ_sel),
	.opr_div_mod_sel(dec_opr_div_mod_sel),

	.alu_o_sel		(dec_alu_o_sel	), //'1' for triggering the data fetch from external bus
	.alu_t_sel		(dec_alu_t_sel	), //'1' for triggering the data fetch from external bus
	.alu_typ_sel	(dec_alu_typ_sel),
	
	.prng_t_sel		(dec_prng_t_sel	),
	.prng_typ_sel	(dec_prng_typ_sel),

	.sprf_typ_r0_sel(dec_sprf_r0_typ_sel),
	.sprf_typ_r1_sel(dec_sprf_r1_typ_sel),

	.src_dst_delay_sel (dec_delay_src_dst_sel),
	.src_dst_delay	(dec_delay_src_dst) //indicate cycle delay between src and dst
);

src_decoder src_decoder(
	//input
	.src_code			(src_code),
	.opr_code 			(opr_code),
	//output
	.dat_ram_addr_en_b	(dec_src_dat_ram_addr_en_b_norm),
	.dat_ram_addr		(dec_src_dat_ram_addr),
	.imm_dat_sel		(dec_src_imm_dat_sel),
	.imm_dat			(dec_src_imm_dat),
	.indir_addr_sel 	(dec_src_indir_addr_sel),
	
	.r0_r_sel			(dec_src_r0_r_sel_norm),.r1_r_sel(dec_src_r1_r_sel_norm),.r2_r_sel(dec_src_r2_r_sel_norm),.r3_r_sel(dec_src_r3_r_sel_norm),
	.r4_r_sel			(dec_src_r4_r_sel_norm),.r5_r_sel(dec_src_r5_r_sel_norm),.r6_r_sel(dec_src_r6_r_sel_norm),.r7_r_sel(dec_src_r7_r_sel_norm),
	
	.r0_t_sel			(dec_src_r0_t_sel_norm),.r1_t_sel(dec_src_r1_t_sel_norm),.r2_t_sel(dec_src_r2_t_sel_norm),.r3_t_sel(dec_src_r3_t_sel_norm),
	.r4_t_sel			(dec_src_r4_t_sel_norm),.r5_t_sel(dec_src_r5_t_sel_norm),.r6_t_sel(dec_src_r6_t_sel_norm),.r7_t_sel(dec_src_r7_t_sel_norm),
	.rmod_t_sel 		(dec_src_rmod_t_sel_norm),

	.sprf0_r_sel 		(dec_src_sprf0_r_sel_norm), .sprf1_r_sel (dec_src_sprf1_r_sel_norm)	
);

dst_decoder dst_decoder(
	//input
	.dst_code			(dst_code),
	.opr_code			(opr_code),
	//output
	.dat_ram_addr_en_b	(dec_dst_dat_ram_addr_en_b_norm),
	.dat_ram_rw			(dec_dst_dat_ram_rw), // 1 read and 0 write
	.dat_ram_addr		(dec_dst_dat_ram_addr),
	.indir_addr_sel		(dec_dst_indir_addr_sel),
	
	.r0_r_sel			(dec_dst_r0_r_sel_norm),.r1_r_sel(dec_dst_r1_r_sel_norm),.r2_r_sel(dec_dst_r2_r_sel_norm),.r3_r_sel(dec_dst_r3_r_sel_norm),
	.r4_r_sel			(dec_dst_r4_r_sel_norm),.r5_r_sel(dec_dst_r5_r_sel_norm),.r6_r_sel(dec_dst_r6_r_sel_norm),.r7_r_sel(dec_dst_r7_r_sel_norm),
	
	.sprf0_r_sel 		(dec_dst_sprf0_r_sel_norm),	.sprf1_r_sel 		(dec_dst_sprf1_r_sel_norm),

	.r0_t_sel			(dec_dst_r0_t_sel_norm),.r1_t_sel(dec_dst_r1_t_sel_norm),.r2_t_sel(dec_dst_r2_t_sel_norm),.r3_t_sel(dec_dst_r3_t_sel_norm),
	.r4_t_sel			(dec_dst_r4_t_sel_norm),.r5_t_sel(dec_dst_r5_t_sel_norm),.r6_t_sel(dec_dst_r6_t_sel_norm),.r7_t_sel(dec_dst_r7_t_sel_norm),	
	.rmod_t_sel 		(dec_dst_rmod_t_sel_norm),

	.jmp_addr_sel		(dec_dst_jmp_addr_sel),
	.jmp_addr			(dec_dst_jmp_addr)
);


endmodule