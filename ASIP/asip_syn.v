//===============================================================================
//              Tcore processor top logic part
//  ----------------------------------------------------------------------------
//  File Name            : ./asip_syn.v
//  Author               : David J.W. HU	
//  Email                : davidhoo471494221@gmail.com
//  ----------------------------------------------------------------------------
//  Description      : This module include the Tcore's top logic part, it
//                          doesn't include the instruction memory and data
//                          memory.

// synthesis translate_on
//`define SYNTHESIS
`ifndef SYNTHESIS
	`include    "../include/define.v"
`else
	`include 	"./include/define.v"
`endif

module   asip_syn(
                clk,                // system clock
                reset_b,            // asynchronous reset       
                t_cs,               // Tcore chip select
                
				//Interface with ins memory
				ins_mem_dat,
				ins_mem_en_b,		
				ins_mem_addr,
				
				// Interface with data memory1 					
                dat_mem1_rw,        // dat memory1 read or write 1--read, 0 -- write
                dat_mem1_en_b,      // dat memory1 chip enable 
                dat_mem1_cs,        // dram block select signal
                dat_mem1_addr,      // to dat memory1 address 
                mem1_to_wrp_dat,    // From dat_ram1 
                wrp_to_mem1_dat     // To dat_ram1 
                ); 

//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
 input  wire                   		clk;
 input  wire                   		reset_b;
 input  wire                   		t_cs;

 
 input 	wire	[`INS_W-1:0]		ins_mem_dat;
 input  wire 	[`MEM_W-1:0]       	mem1_to_wrp_dat; 
 
 output wire						ins_mem_en_b;
 output wire	[`IMEMADDRW-1:0]	ins_mem_addr; 
 output wire                    	dat_mem1_rw; 
 output wire                    	dat_mem1_en_b;
 output wire 	[`DMEMCSW-1:0]   	dat_mem1_cs; 
 output wire 	[`SUBDMEMADDRW-1:0] dat_mem1_addr;  
 output wire 	[`MEM_W-1:0]       	wrp_to_mem1_dat;  
 

 

//----------------------------------------------------------  
// Tcore mem_wrapper module   
// with dat_ mem1 interface wire Declaration  
//----------------------------------------------------------   
 

//----------------------------------------------------------
// wrapper_top with ifetch interface wire Declaration
//---------------------------------------------------------- 
 wire   [`IMEMADDRW-1:0]    mv_PC;  
 wire	[`INS_W-1:0]		mv_ins_reg; 
 wire                       lock_rq;            
 wire                       pc_init_en;         
 wire   [`IMEMADDRW-1:0]    pc_init_addr;   
 
 wire						wrp_to_pcif_jmp_addr_sel;
 wire	[`DST_W-1:0]		wrp_to_pcif_jmp_addr;
 
 wire   [`INS_W-1:0]    	wrp_to_pcif_dat;

 wire   					pc_en_b;
 wire 						halt;

 
 
//----------------------------------------------------------
// wrapper_top with GPRF interface wire Declaration
//---------------------------------------------------------- 
 wire 	[`DAT_W-1:0]		wrp_to_gprf_dat;

 wire						wrp_to_gprf_r0_t_sel, wrp_to_gprf_r1_t_sel, wrp_to_gprf_r2_t_sel, wrp_to_gprf_r3_t_sel, 
							wrp_to_gprf_r4_t_sel, wrp_to_gprf_r5_t_sel, wrp_to_gprf_r6_t_sel, wrp_to_gprf_r7_t_sel, 
							wrp_to_gprf_rmod_t_sel;
							
							
 wire						wrp_to_gprf_bus1_r0_r_sel,wrp_to_gprf_bus1_r1_r_sel,wrp_to_gprf_bus1_r2_r_sel,wrp_to_gprf_bus1_r3_r_sel,
							wrp_to_gprf_bus1_r4_r_sel,wrp_to_gprf_bus1_r5_r_sel,wrp_to_gprf_bus1_r6_r_sel,wrp_to_gprf_bus1_r7_r_sel;

 wire						wrp_to_gprf_bus2_r0_r_sel,wrp_to_gprf_bus2_r1_r_sel,wrp_to_gprf_bus2_r2_r_sel,wrp_to_gprf_bus2_r3_r_sel,
							wrp_to_gprf_bus2_r4_r_sel,wrp_to_gprf_bus2_r5_r_sel,wrp_to_gprf_bus2_r6_r_sel,wrp_to_gprf_bus2_r7_r_sel;
				
//----------------------------------------------------------
// wrapper_top with SPRF interface wire Declaration
//---------------------------------------------------------- 
wire 	[`SPRF_TYP_W-1:0]	wrp_to_sprf_r0_typ_sel, 
							wrp_to_sprf_r1_typ_sel;


wire 						wrp_to_sprf0_r_sel, 
							wrp_to_sprf1_r_sel; 


wire 	[`SPRF_DAT_W-1:0] 	opt_wrp_to_sprf_t_dat;
//----------------------------------------------------------
// alu_wrapper with ALU interface wire Declaration
//---------------------------------------------------------- 
wire						aluwrp_to_alu_o_sel;
wire						aluwrp_to_alu_t_sel;
wire	[`ALU_TYP_W-1:0]	aluwrp_to_alu_typ_sel;

wire	[`DAT_W-1:0]		aluwrp_to_alu_o_dat;
wire	[`DAT_W-1:0]		aluwrp_to_alu_t_dat;


//----------------------------------------------------------
// ins_decoder interface wire Declaration
//---------------------------------------------------------- 
wire	[`DLY_W-1:0]		dec_opr_delay;
wire 						dec_src_dat_ram_addr_en_b;
wire	[`DMEMADDRW-1:0]	dec_src_dat_ram_addr;

wire 						dec_dst_dat_ram_addr_en_b;
wire 						dec_dst_dat_ram_rw;
wire	[`DMEMADDRW-1:0]	dec_dst_dat_ram_addr;
wire 						dec_dst_indir_addr_sel;

wire						dec_src_imm_dat_sel;
wire 	[`IMM_DAT_W-1:0]	dec_src_imm_dat;

wire 						dec_src_r0_r_sel,	dec_src_r1_r_sel,	dec_src_r2_r_sel,	dec_src_r3_r_sel,
							dec_src_r4_r_sel,	dec_src_r5_r_sel,	dec_src_r6_r_sel,	dec_src_r7_r_sel;


wire 						dec_src_r0_t_sel,	dec_src_r1_t_sel,	dec_src_r2_t_sel,	dec_src_r3_t_sel,
							dec_src_r4_t_sel,	dec_src_r5_t_sel,	dec_src_r6_t_sel,	dec_src_r7_t_sel;


wire 						dec_src_rmod_t_sel;

wire 						dec_src_sprf0_r_sel, dec_src_sprf1_r_sel;

wire 						dec_dst_r0_t_sel,	dec_dst_r1_t_sel,	dec_dst_r2_t_sel,	dec_dst_r3_t_sel,
							dec_dst_r4_t_sel,	dec_dst_r5_t_sel,	dec_dst_r6_t_sel,	dec_dst_r7_t_sel;


wire 						dec_dst_rmod_t_sel;

wire 						dec_dst_r0_r_sel,	dec_dst_r1_r_sel,	dec_dst_r2_r_sel,	dec_dst_r3_r_sel,
							dec_dst_r4_r_sel,	dec_dst_r5_r_sel,	dec_dst_r6_r_sel,	dec_dst_r7_r_sel;

wire 						dec_dst_sprf0_r_sel, dec_dst_sprf1_r_sel;
							
wire						dec_dst_jmp_addr_sel;
wire	[`DST_W-1:0]		dec_dst_jmp_addr;

wire	[`OPR_W-1:0]		dec_opr_typ_sel;
wire 						dec_opr_div_mod_sel;					

wire						dec_opr_prng_t_sel;
wire	[`PRNG_TYP_W-1:0]	dec_opr_prng_typ_sel;

wire 	[`SPRF_TYP_W-1:0]	dec_opr_sprf_r0_typ_sel, dec_opr_sprf_r1_typ_sel; 



wire                        dec_alu_o_sel,		dec_alu_t_sel;	
wire 	[`ALU_TYP_W-1:0]	dec_alu_typ_sel;

wire	[`DLY_W-1:0]		dec_delay_src_dst;						
wire						dec_delay_src_dst_sel;

//----------------------------------------------------------
// gprf interface wire Declaration
//---------------------------------------------------------- 
wire 						gprf_bus1_r0_r_sel,		gprf_bus1_r1_r_sel,		gprf_bus1_r2_r_sel,		gprf_bus1_r3_r_sel,
							gprf_bus1_r4_r_sel,		gprf_bus1_r5_r_sel,		gprf_bus1_r6_r_sel,		gprf_bus1_r7_r_sel;					
							
wire						gprf_bus2_r0_r_sel,		gprf_bus2_r1_r_sel,		gprf_bus2_r2_r_sel,		gprf_bus2_r3_r_sel,
							gprf_bus2_r4_r_sel,		gprf_bus2_r5_r_sel,		gprf_bus2_r6_r_sel,		gprf_bus2_r7_r_sel;

wire	[`DAT_W-1:0]		gprf_bus1_r_dat;
wire 	[`DAT_W-1:0]		gprf_bus2_r_dat;
wire 	[`LDAT_W-1:0]		gprf_rmod_r_dat;

wire 						gprf_bus1_r0_t_sel,		gprf_bus1_r1_t_sel,		gprf_bus1_r2_t_sel,		gprf_bus1_r3_t_sel,
							gprf_bus1_r4_t_sel,		gprf_bus1_r5_t_sel,		gprf_bus1_r6_t_sel,		gprf_bus1_r7_t_sel,
							gprf_rmod_t_sel;
							
wire 	[`DAT_W-1:0]		gprf_bus1_t_dat;	



//----------------------------------------------------------
// alu interface wire Declaration
//---------------------------------------------------------- 
wire 	[`LDAT_W-1:0]		alu_o_dat;
wire	[`DAT_W-1:0]		alu_t_dat;

wire	[`DAT_W-1:0]		alu_r_dat;
wire 	[`DAT_W-1:0] 		alu_remainder_dat;

wire						alu_o_sel;
wire						alu_t_sel;
wire	[`ALU_TYP_W-1:0]	alu_typ_sel;

wire 						alu_done;
//----------------------------------------------------------
// prng interface wire Declaration
//---------------------------------------------------------- 
wire 	[`PRNG_TYP_W-1:0] 	prng_typ_sel;
wire 	[`PRNG_DAT_W-1:0]	prng_t_dat;
wire 						prng_t_sel;
wire 	[`PRNG_DAT_W-1:0]	prng_r_dat;


//----------------------------------------------------------
// sprf interface wire Declaration
//---------------------------------------------------------- 
wire 	[`SPRF_DAT_W-1:0]		sprf_r0_r_dat, 	sprf_r1_r_dat;
wire 	[`SPRF_DAT_W-1:0] 		sprf_r_dat;

wire 	[`SPRF_TYP_W-1:0]		sprf_r0_typ_sel,sprf_r1_typ_sel;

wire 	[`SPRF_DAT_W-1:0] 		sprf_t_dat;
						
//----------------------------------------------------------
// Instance wrapper interface
//----------------------------------------------------------               
wrapper_top    wrapper_top(
                .clk                		( clk             ),
                .reset_b            		( reset_b         ),
                .t_cs               		( t_cs            ),
                .t_rw               		( 1'b1            ),
				//input from pc_if to wrapper, connected to ins_ram
				.ipt_pcif_to_wrp_en_b		( pc_en_b         ),
				.ipt_pcif_to_wrp_addr		( mv_PC			  ),
				.ipt_pcif_to_wrp_halt		( halt			  ),
				//output from wrapper to ins_ram
				.opt_wrp_to_iram_en_b		( ins_mem_en_b    ),
				.opt_wrp_to_iram_addr		( ins_mem_addr    ),
				
				//input from ins_ram to wrapper, connected to pc_if
				.ipt_iram_to_wrp_dat		( ins_mem_dat     			),
				//output from wrapper to pc_if
				.opt_wrp_to_pcif_dat		( wrp_to_pcif_dat 			),
				.opt_wrp_to_pcif_lockrq		( lock_rq		  			),
				.opt_wrp_to_pcif_jmp_addr_sel( wrp_to_pcif_jmp_addr_sel ),
				.opt_wrp_to_pcif_jmp_addr	( wrp_to_pcif_jmp_addr		),
				//input from ins_decoder opr to wrapper
				.ipt_decopr_to_wrp_delay	( dec_delay_src_dst			),
				.ipt_decopr_to_wrp_delay_sel( dec_delay_src_dst_sel		),
				.ipt_decopr_to_wrp_opr_typ_sel(	dec_opr_typ_sel			),
				.ipt_decopr_to_prng_t_sel	( dec_opr_prng_t_sel		),
				.ipt_decopr_to_prng_typ_sel	( dec_opr_prng_typ_sel		),
				.ipt_decopr_to_sprf_r0_typ_sel( dec_opr_sprf_r0_typ_sel ),
				.ipt_decopr_to_sprf_r1_typ_sel( dec_opr_sprf_r1_typ_sel ),
				//input from ins_decoder src to wrapper, read only
				.ipt_decsrc_to_wrp_en_b		( dec_src_dat_ram_addr_en_b ),
				.ipt_decsrc_to_wrp_addr		( dec_src_dat_ram_addr 		),
				.ipt_decsrc_to_wrp_imm_en	( dec_src_imm_dat_sel		),
				.ipt_decsrc_to_wrp_imm		( dec_src_imm_dat			),
				.ipt_decsrc_to_wrp_indir_addr_sel (dec_src_indir_addr_sel),
				

				.ipt_decsrc_to_wrp_r0_r_sel	( dec_src_r0_r_sel			), 
				.ipt_decsrc_to_wrp_r1_r_sel	( dec_src_r1_r_sel			), 
				.ipt_decsrc_to_wrp_r2_r_sel	( dec_src_r2_r_sel			), 
				.ipt_decsrc_to_wrp_r3_r_sel	( dec_src_r3_r_sel			),
				.ipt_decsrc_to_wrp_r4_r_sel	( dec_src_r4_r_sel			), 
				.ipt_decsrc_to_wrp_r5_r_sel	( dec_src_r5_r_sel			), 
				.ipt_decsrc_to_wrp_r6_r_sel	( dec_src_r6_r_sel			), 
				.ipt_decsrc_to_wrp_r7_r_sel	( dec_src_r7_r_sel			),
								
				.ipt_decsrc_to_wrp_r0_t_sel	( dec_src_r0_t_sel			), 
				.ipt_decsrc_to_wrp_r1_t_sel	( dec_src_r1_t_sel			), 
				.ipt_decsrc_to_wrp_r2_t_sel	( dec_src_r2_t_sel			), 
				.ipt_decsrc_to_wrp_r3_t_sel	( dec_src_r3_t_sel			),
				.ipt_decsrc_to_wrp_r4_t_sel	( dec_src_r4_t_sel			), 
				.ipt_decsrc_to_wrp_r5_t_sel	( dec_src_r5_t_sel			), 
				.ipt_decsrc_to_wrp_r6_t_sel	( dec_src_r6_t_sel			), 
				.ipt_decsrc_to_wrp_r7_t_sel	( dec_src_r7_t_sel			),
				
				.ipt_decsrc_to_wrp_rmod_t_sel(dec_src_rmod_t_sel		),

				.ipt_decsrc_to_sprf0_r_sel  ( dec_src_sprf0_r_sel		), 
				.ipt_decsrc_to_sprf1_r_sel  ( dec_src_sprf1_r_sel		),  
				
				//input from ins_decoder dst to wrapper, write/read
				.ipt_decdst_to_wrp_en_b		( dec_dst_dat_ram_addr_en_b ),
				.ipt_decdst_to_wrp_rw		( dec_dst_dat_ram_rw   		),
				.ipt_decdst_to_wrp_addr		( dec_dst_dat_ram_addr 		),
				.ipt_decdst_to_wrp_indir_addr_sel (dec_dst_indir_addr_sel),
				
				.ipt_decdst_to_wrp_r0_r_sel	( dec_dst_r0_r_sel			), 
				.ipt_decdst_to_wrp_r1_r_sel	( dec_dst_r1_r_sel			), 
				.ipt_decdst_to_wrp_r2_r_sel	( dec_dst_r2_r_sel			), 
				.ipt_decdst_to_wrp_r3_r_sel ( dec_dst_r3_r_sel			),
				.ipt_decdst_to_wrp_r4_r_sel	( dec_dst_r4_r_sel			), 
				.ipt_decdst_to_wrp_r5_r_sel	( dec_dst_r5_r_sel			), 
				.ipt_decdst_to_wrp_r6_r_sel	( dec_dst_r6_r_sel			), 
				.ipt_decdst_to_wrp_r7_r_sel	( dec_dst_r7_r_sel			),

				.ipt_decdst_to_sprf0_r_sel  ( dec_dst_sprf0_r_sel		), 
				.ipt_decdst_to_sprf1_r_sel  ( dec_dst_sprf1_r_sel		),  

				.ipt_decdst_to_wrp_r0_t_sel ( dec_dst_r0_t_sel			),
				.ipt_decdst_to_wrp_r1_t_sel ( dec_dst_r1_t_sel			), 
				.ipt_decdst_to_wrp_r2_t_sel ( dec_dst_r2_t_sel			), 
				.ipt_decdst_to_wrp_r3_t_sel ( dec_dst_r3_t_sel			),
				.ipt_decdst_to_wrp_r4_t_sel	( dec_dst_r4_t_sel			), 
				.ipt_decdst_to_wrp_r5_t_sel	( dec_dst_r5_t_sel			), 
				.ipt_decdst_to_wrp_r6_t_sel	( dec_dst_r6_t_sel			), 
				.ipt_decdst_to_wrp_r7_t_sel	( dec_dst_r7_t_sel			),
					
				.ipt_decdst_to_wrp_rmod_t_sel(dec_dst_rmod_t_sel		),

				.ipt_decdst_to_wrp_jmp_addr_sel	(dec_dst_jmp_addr_sel	),
				.ipt_decdst_to_wrp_jmp_addr	( dec_dst_jmp_addr			),
				
				//output from wrapper to dat_ram, source from ins_decoder src or dst part.
				.opt_wrp_to_dram_en_b		( dat_mem1_en_b   ),
				.opt_wrp_to_dram_rw			( dat_mem1_rw	  ),
				.opt_wrp_to_dram_cs 		( dat_mem1_cs     ),
				.opt_wrp_to_dram_addr		( dat_mem1_addr   ),
				
				//input from sprf to wrapper,
				.ipt_sprf_to_wrp_dat        ( sprf_r_dat 	),
				//input from dat_ram to wrapper, connected to gprf 
				.ipt_dram_to_wrp_dat		( mem1_to_wrp_dat ),
				//output from wrapper to gprf (either from imm or dat_ram or gprf or alu)
				.opt_wrp_to_gprf_dat		( wrp_to_gprf_dat ),

				.opt_wrp_to_gprf_r0_t_sel	( wrp_to_gprf_r0_t_sel ),
				.opt_wrp_to_gprf_r1_t_sel	( wrp_to_gprf_r1_t_sel ),
				.opt_wrp_to_gprf_r2_t_sel	( wrp_to_gprf_r2_t_sel ),
				.opt_wrp_to_gprf_r3_t_sel	( wrp_to_gprf_r3_t_sel ),
				.opt_wrp_to_gprf_r4_t_sel	( wrp_to_gprf_r4_t_sel ),
				.opt_wrp_to_gprf_r5_t_sel	( wrp_to_gprf_r5_t_sel ),
				.opt_wrp_to_gprf_r6_t_sel	( wrp_to_gprf_r6_t_sel ),
				.opt_wrp_to_gprf_r7_t_sel	( wrp_to_gprf_r7_t_sel ),

				.opt_wrp_to_gprf_rmod_t_sel ( wrp_to_gprf_rmod_t_sel),

				.opt_wrp_to_bus1_gprf_r0_r_sel ( wrp_to_gprf_bus1_r0_r_sel ),
				.opt_wrp_to_bus1_gprf_r1_r_sel ( wrp_to_gprf_bus1_r1_r_sel ),
				.opt_wrp_to_bus1_gprf_r2_r_sel ( wrp_to_gprf_bus1_r2_r_sel ),
				.opt_wrp_to_bus1_gprf_r3_r_sel ( wrp_to_gprf_bus1_r3_r_sel ),
				.opt_wrp_to_bus1_gprf_r4_r_sel ( wrp_to_gprf_bus1_r4_r_sel ),
				.opt_wrp_to_bus1_gprf_r5_r_sel ( wrp_to_gprf_bus1_r5_r_sel ),
				.opt_wrp_to_bus1_gprf_r6_r_sel ( wrp_to_gprf_bus1_r6_r_sel ),
				.opt_wrp_to_bus1_gprf_r7_r_sel ( wrp_to_gprf_bus1_r7_r_sel ),
				
				
				.opt_wrp_to_bus2_gprf_r0_r_sel ( wrp_to_gprf_bus2_r0_r_sel ),
				.opt_wrp_to_bus2_gprf_r1_r_sel ( wrp_to_gprf_bus2_r1_r_sel ),
				.opt_wrp_to_bus2_gprf_r2_r_sel ( wrp_to_gprf_bus2_r2_r_sel ),
				.opt_wrp_to_bus2_gprf_r3_r_sel ( wrp_to_gprf_bus2_r3_r_sel ),
				.opt_wrp_to_bus2_gprf_r4_r_sel ( wrp_to_gprf_bus2_r4_r_sel ),
				.opt_wrp_to_bus2_gprf_r5_r_sel ( wrp_to_gprf_bus2_r5_r_sel ),
				.opt_wrp_to_bus2_gprf_r6_r_sel ( wrp_to_gprf_bus2_r6_r_sel ),
				.opt_wrp_to_bus2_gprf_r7_r_sel ( wrp_to_gprf_bus2_r7_r_sel ),
				
				//input from gprf to wrapper, connect to dat_ram or gprf_t_dat or alu op1
				.ipt_gprf_to_wrp_dat1			( gprf_bus1_r_dat ),
				.ipt_gprf_to_wrp_mod			( gprf_rmod_r_dat  ),
				//input from gprf to wrapper, connect to dat_ram for indirect referencing OR connect to alu op2
				.ipt_gprf_to_wrp_dat2			( gprf_bus2_r_dat ),

				//output from wrapper to dram, the data source is from ins_decoder (gprf-based).
				.opt_wrp_to_dram_dat			( wrp_to_mem1_dat ),
				
				// output from wrapper to sprf	
				.opt_wrp_to_sprf_r0_typ_sel		( wrp_to_sprf_r0_typ_sel),
				.opt_wrp_to_sprf_r1_typ_sel		( wrp_to_sprf_r1_typ_sel),

				.opt_wrp_to_sprf0_r_sel 		( wrp_to_sprf0_r_sel 	),
				.opt_wrp_to_sprf1_r_sel 		( wrp_to_sprf1_r_sel 	),

				.opt_wrp_to_sprf_t_dat			( opt_wrp_to_sprf_t_dat ),
				// input from ins_decoder to alu_wrp, connected to alu
				.ipt_decopr_to_alu_o_sel		( dec_alu_o_sel		),
				.ipt_decopr_to_alu_t_sel		( dec_alu_t_sel		),
				.ipt_decopr_to_alu_typ_sel		( dec_alu_typ_sel	),
				.ipt_decopr_to_wrp_div_mod_sel	( dec_opr_div_mod_sel 	),
				// output from alu_wrp to alu, ctl source from ins_decoder and data source from gprf
				.opt_wrp_to_alu_o_sel			( alu_o_sel			),
				.opt_wrp_to_alu_t_sel			( alu_t_sel			),
				.opt_wrp_to_alu_typ_sel			( alu_typ_sel		),
				
				.opt_wrp_to_alu_o_dat			( alu_o_dat			),
				.opt_wrp_to_alu_t_dat			( alu_t_dat			),
				
				// input from alu to alu_wrp, connected to gprf for storage.
				.ipt_alu_to_wrp_dat				( alu_r_dat			),
				.ipt_alu_to_wrp_dat2			( alu_remainder_dat ),
				.ipt_alu_to_wrp_done			( alu_done 			),
				// output from prng_wrp to prng, ctl source from ins_decoder and intermediate data source from ins_decoder src
				.opt_wrp_to_prng_t_dat			( prng_t_dat		),
				.opt_wrp_to_prng_t_sel			( prng_t_sel		),
				.opt_wrp_to_prng_typ_sel		( prng_typ_sel		),
				// input from prng to prng_wrp, connected to gprf to store the generated random number.
				.ipt_prng_to_wrp_dat			( prng_r_dat		)
);   


//----------------------------------------------------------
// Instance pc_if 
//----------------------------------------------------------   
pc_if  pc_if (
		//input
        .clk            ( clk            ),                 
        .reset_b        ( reset_b        ),  
		.t_cs           ( t_cs           ),		
        .lock_rq        ( lock_rq        ),     // From outside external_mem           
        .pc_init_en     ( pc_init_en     ),     // From outside external_mem             
        .pc_init_addr   ( pc_init_addr   ),     // From outside external_mem             
        .rpt_again      ( 1'b0      ),     // From repeat_pc     
        .rpt_start_addr ( 10'b0 	),     // From repeat_pc        
        .jmp_pc_sel     ( wrp_to_pcif_jmp_addr_sel),     // From jump_pc      
        .jmp_imm_data   ( wrp_to_pcif_jmp_addr),     // From jump_pc      
        .ins_mem_i      ( wrp_to_pcif_dat ),     // From outside external_mem  
		//output          
        .pc_en_b        ( pc_en_b    	),     // To outside external_mem, if pc_if locked, set it to '1'              
        .halt           ( halt         ),     // To outside, indicates whether pc_if is locked or not   
		.mv_PC          ( mv_PC         ),     // To outside 
		.mv_ins_reg     ( mv_ins_reg    )      // To outside DC_Configure
        );        

assign pc_init_en 	= 1'b0;
assign pc_init_addr = `IMEMADDRW'b0;		
//----------------------------------------------------------
// Instance decoder 
//----------------------------------------------------------       
ins_decoder ins_decoder(
	//input
	.instruction				(mv_ins_reg),
	
	//output from src, ram-based, imm-based, gprf-based
	.dec_src_dat_ram_addr_en_b	(dec_src_dat_ram_addr_en_b),
	.dec_src_dat_ram_addr		(dec_src_dat_ram_addr),
	.dec_src_imm_dat_sel		(dec_src_imm_dat_sel),
	.dec_src_imm_dat			(dec_src_imm_dat),
	.dec_src_indir_addr_sel		(dec_src_indir_addr_sel),

	.dec_src_r0_r_sel			(dec_src_r0_r_sel),		
	.dec_src_r1_r_sel			(dec_src_r1_r_sel),
	.dec_src_r2_r_sel			(dec_src_r2_r_sel),		
	.dec_src_r3_r_sel			(dec_src_r3_r_sel),
	.dec_src_r4_r_sel			(dec_src_r4_r_sel),		
	.dec_src_r5_r_sel			(dec_src_r5_r_sel),
	.dec_src_r6_r_sel			(dec_src_r6_r_sel),		
	.dec_src_r7_r_sel			(dec_src_r7_r_sel),
	

	.dec_src_sprf0_r_sel		(dec_src_sprf0_r_sel),
	.dec_src_sprf1_r_sel		(dec_src_sprf1_r_sel),


	.dec_src_r0_t_sel			(dec_src_r0_t_sel),		
	.dec_src_r1_t_sel			(dec_src_r1_t_sel),
	.dec_src_r2_t_sel			(dec_src_r2_t_sel),		
	.dec_src_r3_t_sel			(dec_src_r3_t_sel),
	.dec_src_r4_t_sel			(dec_src_r4_t_sel),		
	.dec_src_r5_t_sel			(dec_src_r5_t_sel),
	.dec_src_r6_t_sel			(dec_src_r6_t_sel),		
	.dec_src_r7_t_sel			(dec_src_r7_t_sel),

	.dec_src_rmod_t_sel			(dec_src_rmod_t_sel),
	//output from dst	
	.dec_dst_dat_ram_addr_en_b  (dec_dst_dat_ram_addr_en_b),
	.dec_dst_dat_ram_rw 		(dec_dst_dat_ram_rw),// 1 read and 0 write
	.dec_dst_dat_ram_addr		(dec_dst_dat_ram_addr),
	.dec_dst_indir_addr_sel		(dec_dst_indir_addr_sel),
	
	.dec_dst_r0_r_sel			(dec_dst_r0_r_sel),		
	.dec_dst_r1_r_sel			(dec_dst_r1_r_sel),
	.dec_dst_r2_r_sel			(dec_dst_r2_r_sel),		
	.dec_dst_r3_r_sel			(dec_dst_r3_r_sel),
	.dec_dst_r4_r_sel			(dec_dst_r4_r_sel),		
	.dec_dst_r5_r_sel			(dec_dst_r5_r_sel),
	.dec_dst_r6_r_sel			(dec_dst_r6_r_sel),		
	.dec_dst_r7_r_sel			(dec_dst_r7_r_sel),

	.dec_dst_sprf0_r_sel		(dec_dst_sprf0_r_sel),
	.dec_dst_sprf1_r_sel		(dec_dst_sprf1_r_sel),

	.dec_dst_r0_t_sel			(dec_dst_r0_t_sel),		
	.dec_dst_r1_t_sel			(dec_dst_r1_t_sel),
	.dec_dst_r2_t_sel			(dec_dst_r2_t_sel),		
	.dec_dst_r3_t_sel			(dec_dst_r3_t_sel),
	.dec_dst_r4_t_sel			(dec_dst_r4_t_sel),		
	.dec_dst_r5_t_sel			(dec_dst_r5_t_sel),
	.dec_dst_r6_t_sel			(dec_dst_r6_t_sel),		
	.dec_dst_r7_t_sel			(dec_dst_r7_t_sel),

	.dec_dst_rmod_t_sel 		(dec_dst_rmod_t_sel),

	.dec_dst_jmp_addr_sel		(dec_dst_jmp_addr_sel),
	.dec_dst_jmp_addr			(dec_dst_jmp_addr	),
	//output from opr
	.dec_opr_typ_sel			(dec_opr_typ_sel	),
	.dec_opr_div_mod_sel 		(dec_opr_div_mod_sel 	),
	
	.dec_alu_o_sel				(dec_alu_o_sel		), //'1' for triggering the data fetch from external bus
	.dec_alu_t_sel				(dec_alu_t_sel		), //'1' for triggering the data fetch from external bus
	.dec_alu_typ_sel			(dec_alu_typ_sel	),
	

	.dec_prng_t_sel				(dec_opr_prng_t_sel			),
	.dec_prng_typ_sel			(dec_opr_prng_typ_sel		),

	.dec_sprf_r0_typ_sel		(dec_opr_sprf_r0_typ_sel	), //'1' for tiggering MOV Rx IDx[y]; 2' for triggering IDX++; '3' for triggering IDX--
	.dec_sprf_r1_typ_sel  		(dec_opr_sprf_r1_typ_sel	),

	.dec_delay_src_dst_sel		(dec_delay_src_dst_sel	),
	.dec_delay_src_dst			(dec_delay_src_dst		)//indicate cycle delay between src and dst	
);


//----------------------------------------------------------
// Instance gprf 
//----------------------------------------------------------  
gprf  gprf(
		//input
		.clk			(clk			   ),
		.rst_b			(reset_b       	   ),	
		
		.bus1_r0_t_sel	(gprf_bus1_r0_t_sel),
		.bus1_r1_t_sel	(gprf_bus1_r1_t_sel),
		.bus1_r2_t_sel	(gprf_bus1_r2_t_sel),
		.bus1_r3_t_sel	(gprf_bus1_r3_t_sel),
		.bus1_r4_t_sel	(gprf_bus1_r4_t_sel),
		.bus1_r5_t_sel	(gprf_bus1_r5_t_sel),
		.bus1_r6_t_sel	(gprf_bus1_r6_t_sel),
		.bus1_r7_t_sel	(gprf_bus1_r7_t_sel),
		.bus1_rmod_t_sel(gprf_bus1_rmod_t_sel),	
		
		.bus1_dat		(gprf_bus1_t_dat   	),

		
		.bus1_r0_r_sel	(gprf_bus1_r0_r_sel),
		.bus1_r1_r_sel	(gprf_bus1_r1_r_sel),
		.bus1_r2_r_sel	(gprf_bus1_r2_r_sel),
		.bus1_r3_r_sel	(gprf_bus1_r3_r_sel),
		.bus1_r4_r_sel	(gprf_bus1_r4_r_sel),
		.bus1_r5_r_sel	(gprf_bus1_r5_r_sel),
		.bus1_r6_r_sel	(gprf_bus1_r6_r_sel),
		.bus1_r7_r_sel	(gprf_bus1_r7_r_sel),

	
		.bus2_r0_r_sel	(gprf_bus2_r0_r_sel),
		.bus2_r1_r_sel	(gprf_bus2_r1_r_sel),
		.bus2_r2_r_sel	(gprf_bus2_r2_r_sel),
		.bus2_r3_r_sel	(gprf_bus2_r3_r_sel),
		.bus2_r4_r_sel	(gprf_bus2_r4_r_sel),
		.bus2_r5_r_sel	(gprf_bus2_r5_r_sel),
		.bus2_r6_r_sel	(gprf_bus2_r6_r_sel),
		.bus2_r7_r_sel	(gprf_bus2_r7_r_sel),

		.bus1_rmod_r_sel		(1'b1),	
		//output
		.bus1_gprf_r_dat 		(gprf_bus1_r_dat   		),
		.bus2_gprf_r_dat 		(gprf_bus2_r_dat   		),
		.bus1_gprf_rmod_r_dat 	(gprf_rmod_r_dat 		)
);

assign gprf_bus1_r0_r_sel = wrp_to_gprf_bus1_r0_r_sel;
assign gprf_bus1_r1_r_sel = wrp_to_gprf_bus1_r1_r_sel;
assign gprf_bus1_r2_r_sel = wrp_to_gprf_bus1_r2_r_sel;
assign gprf_bus1_r3_r_sel = wrp_to_gprf_bus1_r3_r_sel;
assign gprf_bus1_r4_r_sel = wrp_to_gprf_bus1_r4_r_sel; 
assign gprf_bus1_r5_r_sel = wrp_to_gprf_bus1_r5_r_sel; 
assign gprf_bus1_r6_r_sel = wrp_to_gprf_bus1_r6_r_sel;
assign gprf_bus1_r7_r_sel = wrp_to_gprf_bus1_r7_r_sel;


assign gprf_bus1_r0_t_sel = wrp_to_gprf_r0_t_sel; 
assign gprf_bus1_r1_t_sel = wrp_to_gprf_r1_t_sel; 
assign gprf_bus1_r2_t_sel = wrp_to_gprf_r2_t_sel;
assign gprf_bus1_r3_t_sel = wrp_to_gprf_r3_t_sel;
assign gprf_bus1_r4_t_sel = wrp_to_gprf_r4_t_sel; 
assign gprf_bus1_r5_t_sel = wrp_to_gprf_r5_t_sel; 
assign gprf_bus1_r6_t_sel = wrp_to_gprf_r6_t_sel;
assign gprf_bus1_r7_t_sel = wrp_to_gprf_r7_t_sel;

assign gprf_bus1_rmod_t_sel= wrp_to_gprf_rmod_t_sel;

assign gprf_bus1_t_dat 	  = wrp_to_gprf_dat;

assign gprf_bus2_r0_r_sel = wrp_to_gprf_bus2_r0_r_sel;
assign gprf_bus2_r1_r_sel = wrp_to_gprf_bus2_r1_r_sel;
assign gprf_bus2_r2_r_sel = wrp_to_gprf_bus2_r2_r_sel;
assign gprf_bus2_r3_r_sel = wrp_to_gprf_bus2_r3_r_sel;
assign gprf_bus2_r4_r_sel = wrp_to_gprf_bus2_r4_r_sel; 
assign gprf_bus2_r5_r_sel = wrp_to_gprf_bus2_r5_r_sel; 
assign gprf_bus2_r6_r_sel = wrp_to_gprf_bus2_r6_r_sel;
assign gprf_bus2_r7_r_sel = wrp_to_gprf_bus2_r7_r_sel;

//----------------------------------------------------------
// Instance alu 
//----------------------------------------------------------
ALU alu(
		// input
		.clk			( clk 			),
		.rst_b			( reset_b		),
		.alu_o_sel		( alu_o_sel 	), //'1' for triggering the data fetch from external bus
		.alu_t_sel		( alu_t_sel		), //'1' for triggering the data fetch from external bus
		.alu_mod_sel	( 1'b1			),
		.alu_o_dat		( alu_o_dat 	),   //operand data from bus
		.alu_t_dat		( alu_t_dat		),
		.alu_mod_dat	( gprf_rmod_r_dat),
		.alu_typ_sel	( alu_typ_sel	), //4'b0001 for add; 4'b0010 for sub; 4'b0011 for mul; 
		// output	
		.alu_r_dat1		( alu_r_dat		),
		.alu_r_dat2		( alu_remainder_dat),
		.compute_done	( alu_done)
);

//----------------------------------------------------------
// Instance prng 
//----------------------------------------------------------
prng_lcg prng(
		// input
		.clk 			( clk			),
		.rst_b			( reset_b		),
		.prng_typ_sel	( prng_typ_sel	), //'0' halting prng, '1' for triggering the prng, '2' for updating initial seed
		.prng_t_dat		( prng_t_dat	), //initial seed value of RNG
		.prng_t_sel		( prng_t_sel	),
		// output
		.prng_r_dat		( prng_r_dat	)
);

//----------------------------------------------------------
// Instance sprf 
//----------------------------------------------------------
sprf sprf(
		//input
		.clk 			( clk 			),
		.rst_b 			( reset_b 		),

		.sprf_t_dat		( sprf_t_dat 	),

		.r0_typ_sel 	( sprf_r0_typ_sel),
		.r1_typ_sel 	( sprf_r1_typ_sel),

		.r0_r_sel 		( sprf0_r_sel 	 ),
		.r1_r_sel 		( sprf1_r_sel 	 ),

		//output
		.sprf_r_dat0 	( sprf_r0_r_dat	),
		.sprf_r_dat1 	( sprf_r1_r_dat	),

		.sprf_r_dat 	( sprf_r_dat 	)
);


assign sprf_t_dat = opt_wrp_to_sprf_t_dat;


assign sprf_r0_typ_sel = wrp_to_sprf_r0_typ_sel;
assign sprf_r1_typ_sel = wrp_to_sprf_r1_typ_sel;


assign sprf0_r_sel = wrp_to_sprf0_r_sel; 
assign sprf1_r_sel = wrp_to_sprf1_r_sel; 

endmodule

//=============================END==============================================
