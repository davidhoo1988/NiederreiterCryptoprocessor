//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/memory_wrapper.v
//  File Revision        : 3.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//                              2008        Rev1.0  yaoyongbin
//                              2009.07     Rev2.0  tanxingliang 
//								2014.12		Rev3.0	David 
//								2015.05		Rev3.1 	David
//  ----------------------------------------------------------------------------
//  Description      : This module interface between Tcore and
//                     External and Memory (Instruction and Data Mem)
//  ----------------------------------------------------------------------------
//===============================================================================

// synthesis translate_on
`include    "../include/define.v"

module  wrapper_top(
				//input
                input wire 						clk,
                input wire 						reset_b,
                input wire						t_cs,
                input wire						t_rw,
				//input from pc_if to wrapper, connected to ins_ram
				input wire 						ipt_pcif_to_wrp_en_b,
				input wire	[`IMEMADDRW-1:0]	ipt_pcif_to_wrp_addr,
				input wire 						ipt_pcif_to_wrp_halt,
				//output from wrapper to ins_ram
				output wire 					opt_wrp_to_iram_en_b,
				output wire	[`IMEMADDRW-1:0] 	opt_wrp_to_iram_addr,
				
				//input from ins_ram to wrapper, connected to pc_if
				input wire 	[`INS_W-1:0]		ipt_iram_to_wrp_dat,
				//output from wrapper to pc_if
				output wire [`INS_W-1:0]		opt_wrp_to_pcif_dat,
				output wire 					opt_wrp_to_pcif_lockrq,
				output wire 					opt_wrp_to_pcif_jmp_addr_sel,
				output wire [`DST_W-1:0]		opt_wrp_to_pcif_jmp_addr,
				//input from ins_decoder opr to wrapper
				input wire [`DLY_W-1:0]			ipt_decopr_to_wrp_delay,
				input wire						ipt_decopr_to_wrp_delay_sel,
				input wire [`OPR_W-1:0]			ipt_decopr_to_wrp_opr_typ_sel,
				//***input from ins_decoder opr to prng_wrapper
				input wire 						ipt_decopr_to_prng_t_sel,
				input wire [`PRNG_TYP_W-1:0]	ipt_decopr_to_prng_typ_sel,
				//***input from ins_decoder opr to sprf_wrapper
				input wire [`SPRF_TYP_W-1:0] 	ipt_decopr_to_sprf_r0_typ_sel,
				input wire [`SPRF_TYP_W-1:0] 	ipt_decopr_to_sprf_r1_typ_sel,
				//input from ins_decoder src to wrapper, read only
				input wire						ipt_decsrc_to_wrp_en_b,
				input wire	[`DMEMADDRW-1:0]	ipt_decsrc_to_wrp_addr,
				input wire 						ipt_decsrc_to_wrp_imm_en,
				input wire  [`IMM_DAT_W-1:0]	ipt_decsrc_to_wrp_imm,
				input wire 						ipt_decsrc_to_wrp_indir_addr_sel,
				
				input wire 						ipt_decsrc_to_wrp_r0_r_sel, ipt_decsrc_to_wrp_r1_r_sel, ipt_decsrc_to_wrp_r2_r_sel, ipt_decsrc_to_wrp_r3_r_sel,
												ipt_decsrc_to_wrp_r4_r_sel, ipt_decsrc_to_wrp_r5_r_sel, ipt_decsrc_to_wrp_r6_r_sel, ipt_decsrc_to_wrp_r7_r_sel,

				input wire 						ipt_decsrc_to_wrp_r0_t_sel, ipt_decsrc_to_wrp_r1_t_sel, ipt_decsrc_to_wrp_r2_t_sel, ipt_decsrc_to_wrp_r3_t_sel,
												ipt_decsrc_to_wrp_r4_t_sel, ipt_decsrc_to_wrp_r5_t_sel, ipt_decsrc_to_wrp_r6_t_sel, ipt_decsrc_to_wrp_r7_t_sel,

				input wire 						ipt_decsrc_to_wrp_rmod_t_sel,								
				
				input wire 						ipt_decsrc_to_sprf0_r_sel, 
												ipt_decsrc_to_sprf1_r_sel, 

				//input from ins_decoder dst to wrapper, write only
				input wire						ipt_decdst_to_wrp_en_b,		
				input wire						ipt_decdst_to_wrp_rw,
				input wire	[`DMEMADDRW-1:0]	ipt_decdst_to_wrp_addr,
				input wire						ipt_decdst_to_wrp_indir_addr_sel,
				
				input wire 						ipt_decdst_to_wrp_r0_r_sel, ipt_decdst_to_wrp_r1_r_sel, ipt_decdst_to_wrp_r2_r_sel, ipt_decdst_to_wrp_r3_r_sel,
												ipt_decdst_to_wrp_r4_r_sel, ipt_decdst_to_wrp_r5_r_sel, ipt_decdst_to_wrp_r6_r_sel, ipt_decdst_to_wrp_r7_r_sel,
												
				input wire 						ipt_decdst_to_sprf0_r_sel, 
												ipt_decdst_to_sprf1_r_sel, 
												
				input wire 						ipt_decdst_to_wrp_r0_t_sel, ipt_decdst_to_wrp_r1_t_sel, ipt_decdst_to_wrp_r2_t_sel, ipt_decdst_to_wrp_r3_t_sel,
												ipt_decdst_to_wrp_r4_t_sel, ipt_decdst_to_wrp_r5_t_sel, ipt_decdst_to_wrp_r6_t_sel, ipt_decdst_to_wrp_r7_t_sel,
																
				input wire 						ipt_decdst_to_wrp_rmod_t_sel,
												
				input wire 						ipt_decdst_to_wrp_jmp_addr_sel,				
				input wire 	[`DST_W-1:0]		ipt_decdst_to_wrp_jmp_addr,
				//output from wrapper to dat_ram
				output wire 					opt_wrp_to_dram_en_b, // either from src or dst
				output wire 					opt_wrp_to_dram_rw,
				output wire [`DMEMCSW-1:0]		opt_wrp_to_dram_cs,
				output wire [`SUBDMEMADDRW-1:0]	opt_wrp_to_dram_addr, // either from src or dst
				
				//input from sprf to wrapper, connected to gprf
				input wire 	[`SPRF_DAT_W-1:0]	ipt_sprf_to_wrp_dat,

				//input from dat_ram to wrapper, connected to gprf 
				input wire 	[`MEM_W-1:0]		ipt_dram_to_wrp_dat,
				//output from wrapper to gprf, data source from (imm or gprf or alu) and control source from ins_decoder
				output reg 	[`DAT_W-1:0]		opt_wrp_to_gprf_dat,

					//write gprf
				output wire 					opt_wrp_to_gprf_r0_t_sel,opt_wrp_to_gprf_r1_t_sel,opt_wrp_to_gprf_r2_t_sel,opt_wrp_to_gprf_r3_t_sel,
												opt_wrp_to_gprf_r4_t_sel,opt_wrp_to_gprf_r5_t_sel,opt_wrp_to_gprf_r6_t_sel,opt_wrp_to_gprf_r7_t_sel,
												
												opt_wrp_to_gprf_rmod_t_sel,
				
					//read gprf
				output wire 					opt_wrp_to_bus1_gprf_r0_r_sel,opt_wrp_to_bus1_gprf_r1_r_sel,opt_wrp_to_bus1_gprf_r2_r_sel,opt_wrp_to_bus1_gprf_r3_r_sel,
												opt_wrp_to_bus1_gprf_r4_r_sel,opt_wrp_to_bus1_gprf_r5_r_sel,opt_wrp_to_bus1_gprf_r6_r_sel,opt_wrp_to_bus1_gprf_r7_r_sel,

					//read gprf
				output wire 					opt_wrp_to_bus2_gprf_r0_r_sel,opt_wrp_to_bus2_gprf_r1_r_sel,opt_wrp_to_bus2_gprf_r2_r_sel,opt_wrp_to_bus2_gprf_r3_r_sel,
												opt_wrp_to_bus2_gprf_r4_r_sel,opt_wrp_to_bus2_gprf_r5_r_sel,opt_wrp_to_bus2_gprf_r6_r_sel,opt_wrp_to_bus2_gprf_r7_r_sel,
									
				//input from gprf to wrapper, connect to gprf_t_dat or alu op1 or sprf_t_dat or dram
				input wire	[`DAT_W-1:0]		ipt_gprf_to_wrp_dat1,
				//input from gprf to wrapper, connect to alu op2 or indrect register referencing
				input wire	[`DAT_W-1:0]		ipt_gprf_to_wrp_dat2,
				//input from gprf to wrapper, connect to alu op1
				input wire 	[`LDAT_W-1:0] 		ipt_gprf_to_wrp_mod,
				//output from wrp to dat_ram
				output wire [`MEM_W-1:0]		opt_wrp_to_dram_dat, // source from gprf to dram
				
				// input from ins_decoder to alu_wrp, connected to alu
				input wire						ipt_decopr_to_alu_o_sel,
				input wire						ipt_decopr_to_alu_t_sel,
				input wire	[`ALU_TYP_W-1:0]	ipt_decopr_to_alu_typ_sel,
				input wire 						ipt_decopr_to_wrp_div_mod_sel,
				// output from alu_wrp to alu, ctl source from ins_decoder and data source from gprf
				output wire 					opt_wrp_to_alu_o_sel,
				output wire						opt_wrp_to_alu_t_sel,
				output wire [`ALU_TYP_W-1:0]	opt_wrp_to_alu_typ_sel,
				
				output wire [`LDAT_W-1:0]		opt_wrp_to_alu_o_dat,
				output wire [`DAT_W-1:0]		opt_wrp_to_alu_t_dat,
				
				// input from alu to alu_wrp, connected to gprf for storage.
				input wire	[`DAT_W-1:0]		ipt_alu_to_wrp_dat,
				input wire 	[`DAT_W-1:0]		ipt_alu_to_wrp_dat2,
				input wire 						ipt_alu_to_wrp_done,
				/***
				prng
				***/
				// output from prng_wrp to prng, ctl source from ins_decoder and intermediate data source from ins_decoder src
				output wire [`PRNG_DAT_W-1:0]	opt_wrp_to_prng_t_dat,
				output wire 					opt_wrp_to_prng_t_sel,
				output wire [`PRNG_TYP_W-1:0]	opt_wrp_to_prng_typ_sel,
				// input from prng to prng_wrp, connected to gprf to store the generated random number.
				input wire  [`PRNG_DAT_W-1:0]  	ipt_prng_to_wrp_dat,
				/***
				sprf
				***/
				output wire [`SPRF_TYP_W-1:0] 	opt_wrp_to_sprf_r0_typ_sel,
				output wire [`SPRF_TYP_W-1:0] 	opt_wrp_to_sprf_r1_typ_sel,

				output wire 					opt_wrp_to_sprf0_r_sel,
				output wire 					opt_wrp_to_sprf1_r_sel,

				output wire [`SPRF_DAT_W-1:0] 	opt_wrp_to_sprf_t_dat
               ); 
//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 

wire [`DAT_W-1:0]	wrp_to_gprf_t_dat;
wire				opt_aluwrp_to_pcif_jmp_sel;
wire 				opt_aluwrp_to_imem_done;
wire [`DAT_W-1:0]	opt_aluwrp_to_gprf_t_dat, opt_aluwrp_to_gprf_t_dat2;

wire [`DMEMADDRW-1:0] gprfwrp_to_dram_addr, sprfwrp_to_dram_addr;

wire [`PRNG_DAT_W-1:0] opt_prngwrp_to_gprf_dat;
		



//----------------------------------------------------------
// wrapper between ins_ram and pc_if
//----------------------------------------------------------    
imem_wrapper imem_wrapper(
		//input
		.clk							( clk						),
		.reset_b						( reset_b					),
		.t_cs							( t_cs						),
		.t_rw							( t_rw						),
		//input from pc_if to wrapper, connected to ins_ram
		.ipt_pcif_to_wrp_en_b			( ipt_pcif_to_wrp_en_b		),
		.ipt_pcif_to_wrp_addr			( ipt_pcif_to_wrp_addr		),
		//output from wrapper to ins_ram
		.opt_wrp_to_iram_en_b			( opt_wrp_to_iram_en_b		),
		.opt_wrp_to_iram_addr			( opt_wrp_to_iram_addr		),
		
		//input from ins_ram to wrapper, connected to pc_if
		.ipt_iram_to_wrp_dat			( ipt_iram_to_wrp_dat		),
		//output from wrapper to pc_if
		.opt_wrp_to_pcif_dat			( opt_wrp_to_pcif_dat		),
		.opt_wrp_to_pcif_lockrq			( opt_wrp_to_pcif_lockrq	),
		.opt_wrp_to_pcif_jmp_addr_sel	( opt_wrp_to_pcif_jmp_addr_sel),
		.opt_wrp_to_pcif_jmp_addr		( opt_wrp_to_pcif_jmp_addr	),
		//input from ins_decoder opr to wrapper
		.ipt_decopr_to_wrp_opr_typ_sel	( ipt_decopr_to_wrp_opr_typ_sel),
		.ipt_decopr_to_wrp_delay		( ipt_decopr_to_wrp_delay	),
		.ipt_decopr_to_wrp_delay_sel	( ipt_decopr_to_wrp_delay_sel),
		//input from ins_decoder dst to wrapper, used to transfer jmp addr for JMP instructions
		.ipt_decdst_to_wrp_jmp_addr_sel	( ipt_decdst_to_wrp_jmp_addr_sel),
		.ipt_decdst_to_wrp_jmp_addr		( ipt_decdst_to_wrp_jmp_addr),
		//input from alu to wrapper, used for conditional jmp instruction
		.ipt_alu_to_wrp_jmp_addr_sel	( opt_aluwrp_to_pcif_jmp_sel),
		//input from alu to wrapper, used for MUL and DIV
		.ipt_alu_to_wrp_alu_done 		( opt_aluwrp_to_imem_done 	)
);
//----------------------------------------------------------
// wrapper between data_ram and ins_decoder
//---------------------------------------------------------- 
dmem_wrapper dmem_wrapper(
		//input
		.clk							( clk						),
		.reset_b						( reset_b					),
		.t_cs							( t_cs						),
		.t_rw							( t_rw						),
		//input from ins_decoder opr to wrapper
		.ipt_decopr_to_wrp_delay		( ipt_decopr_to_wrp_delay	),
		//input from ins_decoder src to wrapper, read only
		.ipt_decsrc_to_wrp_en_b			( ipt_decsrc_to_wrp_en_b	),
		.ipt_decsrc_to_wrp_addr			( ipt_decsrc_to_wrp_addr	),													
		//input from ins_decoder dst to wrapper, write only
		.ipt_decdst_to_wrp_en_b			( ipt_decdst_to_wrp_en_b	),		
		.ipt_decdst_to_wrp_rw			( ipt_decdst_to_wrp_rw		),
		.ipt_decdst_to_wrp_addr			( ipt_decdst_to_wrp_addr	),	
		//input from sprf_wrapper to wrapper, for indirect referencing
		.ipt_sprfwrp_to_wrp_addr 		( sprfwrp_to_dram_addr		),
		//output from wrapper to dat_ram
		.opt_wrp_to_dram_en_b			( opt_wrp_to_dram_en_b		), // either from src or dst
		.opt_wrp_to_dram_rw				( opt_wrp_to_dram_rw		),
		.opt_wrp_to_dram_cs 			( opt_wrp_to_dram_cs 		),
		.opt_wrp_to_dram_addr			( opt_wrp_to_dram_addr		) // either from src or dst or gprf_indirect_address
);
//----------------------------------------------------------
// wrapper between gprf and data_ram, ins_decoder
//---------------------------------------------------------- 
gprf_wrapper gprf_wrapper(
		//input
		.clk							( clk						),
		.reset_b						( reset_b					),
		.t_cs							( t_cs						),
		.t_rw							( t_rw						),
		//input from pc_if to clean gprf_t_sel
		.ipt_pcif_to_wrp_halt		    ( ipt_pcif_to_wrp_halt		),
		//input from alu to indicate MUL, DIV, SPLIT, DEG is done
		.ipt_alu_to_wrp_done            ( ipt_alu_to_wrp_done 		),
		//input from ins_decoder opr to wrapper
		.ipt_decopr_to_wrp_delay		( ipt_decopr_to_wrp_delay	),
		.ipt_decopr_to_wrp_delay_sel	( ipt_decopr_to_wrp_delay_sel),
		//input from ins_decoder src to wrapper, read only		
		.ipt_decsrc_to_wrp_imm_en		( ipt_decsrc_to_wrp_imm_en	),
		.ipt_decsrc_to_wrp_imm			( ipt_decsrc_to_wrp_imm		),
		.ipt_decsrc_to_wrp_en_b			( ipt_decsrc_to_wrp_en_b	),
		
		.ipt_decsrc_to_wrp_r0_r_sel		( ipt_decsrc_to_wrp_r0_r_sel), 
		.ipt_decsrc_to_wrp_r1_r_sel		( ipt_decsrc_to_wrp_r1_r_sel), 
		.ipt_decsrc_to_wrp_r2_r_sel		( ipt_decsrc_to_wrp_r2_r_sel), 
		.ipt_decsrc_to_wrp_r3_r_sel		( ipt_decsrc_to_wrp_r3_r_sel),
		.ipt_decsrc_to_wrp_r4_r_sel		( ipt_decsrc_to_wrp_r4_r_sel), 
		.ipt_decsrc_to_wrp_r5_r_sel		( ipt_decsrc_to_wrp_r5_r_sel), 
		.ipt_decsrc_to_wrp_r6_r_sel		( ipt_decsrc_to_wrp_r6_r_sel), 
		.ipt_decsrc_to_wrp_r7_r_sel		( ipt_decsrc_to_wrp_r7_r_sel),
		
		.ipt_decsrc_to_wrp_r0_t_sel		( ipt_decsrc_to_wrp_r0_t_sel), 
		.ipt_decsrc_to_wrp_r1_t_sel		( ipt_decsrc_to_wrp_r1_t_sel), 
		.ipt_decsrc_to_wrp_r2_t_sel		( ipt_decsrc_to_wrp_r2_t_sel), 
		.ipt_decsrc_to_wrp_r3_t_sel		( ipt_decsrc_to_wrp_r3_t_sel),
		.ipt_decsrc_to_wrp_r4_t_sel		( ipt_decsrc_to_wrp_r4_t_sel), 
		.ipt_decsrc_to_wrp_r5_t_sel		( ipt_decsrc_to_wrp_r5_t_sel), 
		.ipt_decsrc_to_wrp_r6_t_sel		( ipt_decsrc_to_wrp_r6_t_sel), 
		.ipt_decsrc_to_wrp_r7_t_sel		( ipt_decsrc_to_wrp_r7_t_sel),


		.ipt_decsrc_to_wrp_rmod_t_sel	( ipt_decsrc_to_wrp_rmod_t_sel),

		//input from ins_decoder dst to wrapper, write/read
		.ipt_decdst_to_wrp_indir_addr_sel( ipt_decdst_to_wrp_indir_addr_sel),

		.ipt_decdst_to_wrp_r0_r_sel		( ipt_decdst_to_wrp_r0_r_sel), 
		.ipt_decdst_to_wrp_r1_r_sel		( ipt_decdst_to_wrp_r1_r_sel), 
		.ipt_decdst_to_wrp_r2_r_sel		( ipt_decdst_to_wrp_r2_r_sel), 
		.ipt_decdst_to_wrp_r3_r_sel		( ipt_decdst_to_wrp_r3_r_sel),
		.ipt_decdst_to_wrp_r4_r_sel		( ipt_decdst_to_wrp_r4_r_sel), 
		.ipt_decdst_to_wrp_r5_r_sel		( ipt_decdst_to_wrp_r5_r_sel), 
		.ipt_decdst_to_wrp_r6_r_sel		( ipt_decdst_to_wrp_r6_r_sel), 
		.ipt_decdst_to_wrp_r7_r_sel		( ipt_decdst_to_wrp_r7_r_sel),
					
		.ipt_decdst_to_wrp_r0_t_sel		( ipt_decdst_to_wrp_r0_t_sel), 
		.ipt_decdst_to_wrp_r1_t_sel		( ipt_decdst_to_wrp_r1_t_sel), 
		.ipt_decdst_to_wrp_r2_t_sel		( ipt_decdst_to_wrp_r2_t_sel), 
		.ipt_decdst_to_wrp_r3_t_sel		( ipt_decdst_to_wrp_r3_t_sel),
		.ipt_decdst_to_wrp_r4_t_sel		( ipt_decdst_to_wrp_r4_t_sel),  
		.ipt_decdst_to_wrp_r5_t_sel		( ipt_decdst_to_wrp_r5_t_sel),  
		.ipt_decdst_to_wrp_r6_t_sel		( ipt_decdst_to_wrp_r6_t_sel),  
		.ipt_decdst_to_wrp_r7_t_sel		( ipt_decdst_to_wrp_r7_t_sel), 

		.ipt_decdst_to_wrp_rmod_t_sel	( ipt_decdst_to_wrp_rmod_t_sel),
		//input from dat_ram to wrapper, connected to gprf 
		.ipt_dram_to_wrp_dat			( ipt_dram_to_wrp_dat		),
		//output from wrapper to gprf, data source from (imm or gprf or alu or dram) and control source from ins_decoder
		.opt_wrp_to_gprf_dat			( wrp_to_gprf_t_dat			),

			//write gprf
		.opt_wrp_to_gprf_r0_t_sel		( opt_wrp_to_gprf_r0_t_sel	),
		.opt_wrp_to_gprf_r1_t_sel		( opt_wrp_to_gprf_r1_t_sel	),
		.opt_wrp_to_gprf_r2_t_sel		( opt_wrp_to_gprf_r2_t_sel	),
		.opt_wrp_to_gprf_r3_t_sel		( opt_wrp_to_gprf_r3_t_sel	),
		.opt_wrp_to_gprf_r4_t_sel		( opt_wrp_to_gprf_r4_t_sel	),
		.opt_wrp_to_gprf_r5_t_sel		( opt_wrp_to_gprf_r5_t_sel	),
		.opt_wrp_to_gprf_r6_t_sel		( opt_wrp_to_gprf_r6_t_sel	),
		.opt_wrp_to_gprf_r7_t_sel		( opt_wrp_to_gprf_r7_t_sel	),
		
		.opt_wrp_to_gprf_rmod_t_sel 	( opt_wrp_to_gprf_rmod_t_sel),				
			//read gprf
		.opt_wrp_to_bus1_gprf_r0_r_sel	( opt_wrp_to_bus1_gprf_r0_r_sel),
		.opt_wrp_to_bus1_gprf_r1_r_sel	( opt_wrp_to_bus1_gprf_r1_r_sel),
		.opt_wrp_to_bus1_gprf_r2_r_sel	( opt_wrp_to_bus1_gprf_r2_r_sel),
		.opt_wrp_to_bus1_gprf_r3_r_sel	( opt_wrp_to_bus1_gprf_r3_r_sel),
		.opt_wrp_to_bus1_gprf_r4_r_sel	( opt_wrp_to_bus1_gprf_r4_r_sel),
		.opt_wrp_to_bus1_gprf_r5_r_sel	( opt_wrp_to_bus1_gprf_r5_r_sel),
		.opt_wrp_to_bus1_gprf_r6_r_sel	( opt_wrp_to_bus1_gprf_r6_r_sel),
		.opt_wrp_to_bus1_gprf_r7_r_sel	( opt_wrp_to_bus1_gprf_r7_r_sel),
								
			//read gprf
		.opt_wrp_to_bus2_gprf_r0_r_sel  ( opt_wrp_to_bus2_gprf_r0_r_sel),
		.opt_wrp_to_bus2_gprf_r1_r_sel	( opt_wrp_to_bus2_gprf_r1_r_sel),
		.opt_wrp_to_bus2_gprf_r2_r_sel	( opt_wrp_to_bus2_gprf_r2_r_sel),
		.opt_wrp_to_bus2_gprf_r3_r_sel	( opt_wrp_to_bus2_gprf_r3_r_sel),
		.opt_wrp_to_bus2_gprf_r4_r_sel	( opt_wrp_to_bus2_gprf_r4_r_sel),
		.opt_wrp_to_bus2_gprf_r5_r_sel	( opt_wrp_to_bus2_gprf_r5_r_sel),
		.opt_wrp_to_bus2_gprf_r6_r_sel	( opt_wrp_to_bus2_gprf_r6_r_sel),
		.opt_wrp_to_bus2_gprf_r7_r_sel	( opt_wrp_to_bus2_gprf_r7_r_sel),

		//input from gprf to wrapper, connect to dat_ram
		.ipt_gprf_to_wrp_dat1 			( ipt_gprf_to_wrp_dat1  ),
		.ipt_gprf_to_wrp_dat2		    ( ipt_gprf_to_wrp_dat2	),
		//output from wrp to dat_ram, source from gprf or imm
		.opt_wrp_to_dram_dat 			( opt_wrp_to_dram_dat		),
		.opt_wrp_to_dram_addr			( gprfwrp_to_dram_addr		)
);

//----------------------------------------------------------
// wrapper between alu and gprf, ins_ram
//---------------------------------------------------------- 
alu_wrapper alu_wrapper(
		.clk                			( clk             				),
        .reset_b            			( reset_b         				),
		.t_cs               			( t_cs            				),
		// input from ins_decoder to alu_wrp, connected to alu
		.ipt_decopr_to_wrp_delay		( ipt_decopr_to_wrp_delay		),
		.ipt_decopr_to_alu_o_sel		( ipt_decopr_to_alu_o_sel		),
		.ipt_decopr_to_alu_t_sel		( ipt_decopr_to_alu_t_sel		),
		.ipt_decopr_to_alu_typ_sel		( ipt_decopr_to_alu_typ_sel		),
		.ipt_decopr_to_wrp_div_mod_sel	( ipt_decopr_to_wrp_div_mod_sel ),
		// input from gprf to alu_wrp, connected to alu
		.ipt_gprf_to_wrp_dat1			( ipt_gprf_to_wrp_dat1			),
		.ipt_gprf_to_wrp_dat2			( ipt_gprf_to_wrp_dat2			),
		.ipt_gprf_to_wrp_mod 			( ipt_gprf_to_wrp_mod 			),
		// input from sprf to alu_wrp, connected to alu
		.ipt_sprf_to_wrp_dat 			( ipt_sprf_to_wrp_dat 			),
		// output from alu_wrp to alu, ctl source from ins_decoder and data source from gprf
		.opt_wrp_to_alu_o_sel			( opt_wrp_to_alu_o_sel			),
		.opt_wrp_to_alu_t_sel			( opt_wrp_to_alu_t_sel			),
		.opt_wrp_to_alu_typ_sel			( opt_wrp_to_alu_typ_sel		),
		
		.opt_wrp_to_alu_o_dat			( opt_wrp_to_alu_o_dat			),
		.opt_wrp_to_alu_t_dat			( opt_wrp_to_alu_t_dat			),
		
		// input from alu to alu_wrp, connected to gprf for storage.
		.ipt_alu_to_wrp_dat				( ipt_alu_to_wrp_dat			),
		.ipt_alu_to_wrp_dat2 			( ipt_alu_to_wrp_dat2 			),
		.ipt_alu_to_wrp_done 			( ipt_alu_to_wrp_done 			),
		// output from alu_wrp to gprf, store the result
		.opt_wrp_to_gprf_t_dat			( opt_aluwrp_to_gprf_t_dat		),
		// output from alu_wrp to pc_if, trigger jmp_sel
		.opt_wrp_to_pcif_jmp_sel		( opt_aluwrp_to_pcif_jmp_sel    ),
		// output from alu_wrp to imem, trigger instruction fetch
		.opt_wrp_to_imem_done 			( opt_aluwrp_to_imem_done 		)	
		
);

//----------------------------------------------------------
// wrapper between prng and gprf, ins_ram
//---------------------------------------------------------- 
prng_wrapper prng_wrapper(
		.clk							( clk							),
        .reset_b						( reset_b						),
		.t_cs							( t_cs							),
		// input from ins_decoder to prng_wrp, connected to prng
		.ipt_decopr_to_wrp_delay		( ipt_decopr_to_wrp_delay		),
		// input from ins_decoder to prng_wrp, connected to prng
		.ipt_decopr_to_prng_t_sel		( ipt_decopr_to_prng_t_sel		),
		.ipt_decopr_to_prng_typ_sel		( ipt_decopr_to_prng_typ_sel	),
		// input from ins_decoder to prng_wrp, connected to prng
		.ipt_decsrc_to_prng_imm			( ipt_decsrc_to_wrp_imm			),
		// output from prng_wrp to prng, ctl source from ins_decoder and intermediate data from ins_decoder src
		.opt_wrp_to_prng_t_sel			( opt_wrp_to_prng_t_sel			),
		.opt_wrp_to_prng_typ_sel		( opt_wrp_to_prng_typ_sel		),
		
		.opt_wrp_to_prng_t_dat			( opt_wrp_to_prng_t_dat			),	

		// input from prng to prng_wrp: 
		.ipt_prng_to_wrp_dat			( ipt_prng_to_wrp_dat			),
		// output from prng_wrp to gprf, store the result
		.opt_wrp_to_gprf_t_dat			( opt_prngwrp_to_gprf_dat		)	
);

sprf_wrapper sprf_wrapper(
		.clk							( clk							),
        .reset_b						( reset_b						),
		.t_cs 							( t_cs 							),
		
		// input from ins_decoder to sprf_wrp, connected to sprf
		.ipt_decopr_to_wrp_delay 		( ipt_decopr_to_wrp_delay 		),

		// input from ins_decoder to sprf_wrp, connected to sprf
		.ipt_decopr_to_sprf_r0_typ_sel 	( ipt_decopr_to_sprf_r0_typ_sel ),
		.ipt_decopr_to_sprf_r1_typ_sel	( ipt_decopr_to_sprf_r1_typ_sel ),

		.ipt_decsrc_to_sprf0_r_sel		( ipt_decsrc_to_sprf0_r_sel 	),
		.ipt_decsrc_to_sprf1_r_sel		( ipt_decsrc_to_sprf1_r_sel 	),
	
		.ipt_decdst_to_sprf0_r_sel		( ipt_decdst_to_sprf0_r_sel 	),
		.ipt_decdst_to_sprf1_r_sel		( ipt_decdst_to_sprf1_r_sel 	),

		//input from ins_decoder to sprf_wrp, to control opt_wrp_to_dram_addr
		.ipt_decsrc_to_wrp_indir_addr_sel(ipt_decsrc_to_wrp_indir_addr_sel),
		.ipt_decdst_to_wrp_indir_addr_sel(ipt_decdst_to_wrp_indir_addr_sel),
		// input from sprf to sprf_wrp, connected to dmem_wrapper
		.ipt_sprf_to_wrp_dat 			( ipt_sprf_to_wrp_dat 			),
		// output from sprf_wrp to sprf
		.opt_wrp_to_sprf_r0_typ_sel 	( opt_wrp_to_sprf_r0_typ_sel 	),
		.opt_wrp_to_sprf_r1_typ_sel 	( opt_wrp_to_sprf_r1_typ_sel 	),

		.opt_wrp_to_sprf0_r_sel 		( opt_wrp_to_sprf0_r_sel 		),
		.opt_wrp_to_sprf1_r_sel 		( opt_wrp_to_sprf1_r_sel 		),
		// input from gprf to sprf_wrp, to update IDX with gprf values 
		.ipt_gprf_to_wrp_dat 			( ipt_gprf_to_wrp_dat1[`SPRF_DAT_W-1:0]),
		// output from sprf_wrp to sprf
		.opt_wrp_to_sprf_t_dat			( opt_wrp_to_sprf_t_dat			),
		//output from sprf_wrp to dmem_wrapper, src indirect addr referencing
		.opt_wrp_to_dram_addr			( sprfwrp_to_dram_addr 		 	)
);

//if it is 'MOV', then output wrapper signal, 
//else if it is 'PRNG', then output prng_wrapper signal,
//else it is 'ADD, SUB, MUL, INV' and thus output alu_wrapper signal.
always @(ipt_decopr_to_wrp_opr_typ_sel or wrp_to_gprf_t_dat
or opt_aluwrp_to_gprf_t_dat or opt_prngwrp_to_gprf_dat) 
begin
	if (ipt_decopr_to_wrp_opr_typ_sel == `OPR_W'd1) //MOV Operation
		opt_wrp_to_gprf_dat = wrp_to_gprf_t_dat;
	else if (ipt_decopr_to_wrp_opr_typ_sel == `OPR_W'd6) //PRNG Operation
		opt_wrp_to_gprf_dat = opt_prngwrp_to_gprf_dat;
	else
		opt_wrp_to_gprf_dat = opt_aluwrp_to_gprf_t_dat; // ALU Operation
end

endmodule

//=============================END==============================================
