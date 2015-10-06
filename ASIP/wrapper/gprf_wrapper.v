//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/gprf_wrapper.v
//  File Revision        : 3.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2014.12		Rev1.0	David 
//								2015.01		Rev1.1  David
//								2015.05		Rev1.2 	David
//								2015.06		Rev1.3 	David
//  ----------------------------------------------------------------------------
//  Description      : This module interface between data_ram and ins_decoder
//  ----------------------------------------------------------------------------
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"
module gprf_wrapper(
		//input
		input wire 						clk,
		input wire 						reset_b,
		input wire						t_cs,
		input wire						t_rw,
		//input from pc_if to clean gprf_t_sel
		input wire 						ipt_pcif_to_wrp_halt,
		//input from alu to indicate MUL, DIV, SPLIT, DEG is done
		input wire 						ipt_alu_to_wrp_done,
		//input from ins_decoder opr to wrapper
		input wire [`DLY_W-1:0]			ipt_decopr_to_wrp_delay,
		input wire						ipt_decopr_to_wrp_delay_sel,
		//input from ins_decoder src to wrapper, read only		
		input wire 						ipt_decsrc_to_wrp_imm_en,
		input wire  [`IMM_DAT_W-1:0]	ipt_decsrc_to_wrp_imm,
		input wire 						ipt_decsrc_to_wrp_en_b,
		
		input wire 						ipt_decsrc_to_wrp_r0_r_sel, 
										ipt_decsrc_to_wrp_r1_r_sel, 
										ipt_decsrc_to_wrp_r2_r_sel, 
										ipt_decsrc_to_wrp_r3_r_sel,
										ipt_decsrc_to_wrp_r4_r_sel, 
										ipt_decsrc_to_wrp_r5_r_sel, 
										ipt_decsrc_to_wrp_r6_r_sel, 
										ipt_decsrc_to_wrp_r7_r_sel,

		input wire 						ipt_decsrc_to_wrp_r0_t_sel, 
										ipt_decsrc_to_wrp_r1_t_sel, 
										ipt_decsrc_to_wrp_r2_t_sel, 
										ipt_decsrc_to_wrp_r3_t_sel,
										ipt_decsrc_to_wrp_r4_t_sel, 
										ipt_decsrc_to_wrp_r5_t_sel, 
										ipt_decsrc_to_wrp_r6_t_sel, 
										ipt_decsrc_to_wrp_r7_t_sel,
										

		input wire 						ipt_decsrc_to_wrp_rmod_t_sel,

		//input from ins_decoder dst to wrapper, write only
		input wire 						ipt_decdst_to_wrp_indir_addr_sel,
		
		input wire 						ipt_decdst_to_wrp_r0_r_sel, 
										ipt_decdst_to_wrp_r1_r_sel, 
										ipt_decdst_to_wrp_r2_r_sel, 
										ipt_decdst_to_wrp_r3_r_sel,
										ipt_decdst_to_wrp_r4_r_sel, 
										ipt_decdst_to_wrp_r5_r_sel, 
										ipt_decdst_to_wrp_r6_r_sel, 
										ipt_decdst_to_wrp_r7_r_sel,
										

				
		input wire 						ipt_decdst_to_wrp_r0_t_sel, 
										ipt_decdst_to_wrp_r1_t_sel, 
										ipt_decdst_to_wrp_r2_t_sel, 
										ipt_decdst_to_wrp_r3_t_sel,
										ipt_decdst_to_wrp_r4_t_sel, 
										ipt_decdst_to_wrp_r5_t_sel, 
										ipt_decdst_to_wrp_r6_t_sel, 
										ipt_decdst_to_wrp_r7_t_sel,
										

		input wire 						ipt_decdst_to_wrp_rmod_t_sel,					

		//input from dat_ram to wrapper, connected to gprf 
		input wire 	[`MEM_W-1:0]		ipt_dram_to_wrp_dat,
		//output from wrapper to gprf, data source from (imm or gprf) and control source from ins_decoder
		output reg 	[`DAT_W-1:0]		opt_wrp_to_gprf_dat,
			//write gprf
		output wire 					opt_wrp_to_gprf_r0_t_sel,
										opt_wrp_to_gprf_r1_t_sel,
										opt_wrp_to_gprf_r2_t_sel,
										opt_wrp_to_gprf_r3_t_sel,
										opt_wrp_to_gprf_r4_t_sel,
										opt_wrp_to_gprf_r5_t_sel,
										opt_wrp_to_gprf_r6_t_sel,
										opt_wrp_to_gprf_r7_t_sel,
										

										opt_wrp_to_gprf_rmod_t_sel,

									
			//read gprf
		output wire 					opt_wrp_to_bus1_gprf_r0_r_sel,
										opt_wrp_to_bus1_gprf_r1_r_sel,
										opt_wrp_to_bus1_gprf_r2_r_sel,
										opt_wrp_to_bus1_gprf_r3_r_sel,
										opt_wrp_to_bus1_gprf_r4_r_sel,
										opt_wrp_to_bus1_gprf_r5_r_sel,
										opt_wrp_to_bus1_gprf_r6_r_sel,
										opt_wrp_to_bus1_gprf_r7_r_sel,
										

										
										
			//read gprf
		output wire 					opt_wrp_to_bus2_gprf_r0_r_sel,
										opt_wrp_to_bus2_gprf_r1_r_sel,
										opt_wrp_to_bus2_gprf_r2_r_sel,
										opt_wrp_to_bus2_gprf_r3_r_sel,
										opt_wrp_to_bus2_gprf_r4_r_sel,
										opt_wrp_to_bus2_gprf_r5_r_sel,
										opt_wrp_to_bus2_gprf_r6_r_sel,
										opt_wrp_to_bus2_gprf_r7_r_sel,
										
										
		//input from gprf to wrapper, connected to gprf_t_dat or indirect referencing addr value (MOV @R[IDX0] Rx)
		input wire 	[`DAT_W-1:0] 		ipt_gprf_to_wrp_dat1,
		//input from gprf(indirect referencing as addr value) to wrapper, connected to dat_ram
		input wire 	[`DAT_W-1:0]		ipt_gprf_to_wrp_dat2,
		//output from wrp to dat_ram
		output wire [`MEM_W-1:0]		opt_wrp_to_dram_dat, // source from gprf 
		output reg  [`DMEMADDRW-1:0]	opt_wrp_to_dram_addr// source from gprf(indirect referencing)
);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg	[`MEM_W-1:0]		dram_to_wrp_dat_reg;

reg [`DAT_W-1:0] 		gprf_to_wrp_dat1_reg;
reg [`DAT_W-1:0] 		gprf_to_wrp_dat2_reg;



reg						decsrc_to_wrp_imm_en_reg;
reg [`IMM_DAT_W-1:0]	decsrc_to_wrp_imm_reg;
reg						decsrc_to_wrp_imm_en_tmp;
reg	[`IMM_DAT_W-1:0]	decsrc_to_wrp_imm_tmp;

reg 					decsrc_to_wrp_en_b_reg,		decsrc_to_wrp_en_b_tmp1,	decsrc_to_wrp_en_b_tmp2,
						decsrc_to_wrp_en_b_tmp3, 	decsrc_to_wrp_en_b_tmp4, 	decsrc_to_wrp_en_b_tmp5;

reg 					decsrc_to_wrp_r0_r_sel_tmp,decsrc_to_wrp_r1_r_sel_tmp,decsrc_to_wrp_r2_r_sel_tmp,decsrc_to_wrp_r3_r_sel_tmp,
						decsrc_to_wrp_r4_r_sel_tmp,decsrc_to_wrp_r5_r_sel_tmp,decsrc_to_wrp_r6_r_sel_tmp,decsrc_to_wrp_r7_r_sel_tmp;

reg 					decsrc_to_wrp_r0_t_sel_tmp,decsrc_to_wrp_r1_t_sel_tmp,decsrc_to_wrp_r2_t_sel_tmp,decsrc_to_wrp_r3_t_sel_tmp,
						decsrc_to_wrp_r4_t_sel_tmp,decsrc_to_wrp_r5_t_sel_tmp,decsrc_to_wrp_r6_t_sel_tmp,decsrc_to_wrp_r7_t_sel_tmp;


reg 					decsrc_to_wrp_rmod_t_sel_tmp;

reg						decdst_to_wrp_r0_r_sel_tmp,decdst_to_wrp_r1_r_sel_tmp,decdst_to_wrp_r2_r_sel_tmp,decdst_to_wrp_r3_r_sel_tmp,
						decdst_to_wrp_r4_r_sel_tmp,decdst_to_wrp_r5_r_sel_tmp,decdst_to_wrp_r6_r_sel_tmp,decdst_to_wrp_r7_r_sel_tmp;
						
						
reg						decdst_to_wrp_r0_t_sel_tmp,decdst_to_wrp_r1_t_sel_tmp,decdst_to_wrp_r2_t_sel_tmp,decdst_to_wrp_r3_t_sel_tmp,
						decdst_to_wrp_r4_t_sel_tmp,decdst_to_wrp_r5_t_sel_tmp,decdst_to_wrp_r6_t_sel_tmp,decdst_to_wrp_r7_t_sel_tmp;
						
reg 					decdst_to_wrp_rmod_t_sel_tmp;	

reg 					decdst_to_wrp_indir_addr_sel_tmp;
reg 					decdst_to_wrp_indir_addr_sel_reg;

reg 					sprf_to_gprf_r0_r_sel,sprf_to_gprf_r1_r_sel,sprf_to_gprf_r2_r_sel,sprf_to_gprf_r3_r_sel,
						sprf_to_gprf_r4_r_sel,sprf_to_gprf_r5_r_sel,sprf_to_gprf_r6_r_sel,sprf_to_gprf_r7_r_sel;
						
reg 					sprf_to_gprf_r0_r_sel_tmp,sprf_to_gprf_r1_r_sel_tmp,sprf_to_gprf_r2_r_sel_tmp,sprf_to_gprf_r3_r_sel_tmp,
						sprf_to_gprf_r4_r_sel_tmp,sprf_to_gprf_r5_r_sel_tmp,sprf_to_gprf_r6_r_sel_tmp,sprf_to_gprf_r7_r_sel_tmp;
					

reg 					opt_wrp_to_bus1_gprf_r0_r_sel_reg, opt_wrp_to_bus1_gprf_r1_r_sel_reg, opt_wrp_to_bus1_gprf_r2_r_sel_reg, opt_wrp_to_bus1_gprf_r3_r_sel_reg,
						opt_wrp_to_bus1_gprf_r4_r_sel_reg, opt_wrp_to_bus1_gprf_r5_r_sel_reg, opt_wrp_to_bus1_gprf_r6_r_sel_reg, opt_wrp_to_bus1_gprf_r7_r_sel_reg;


reg	[`DLY_W-1:0]		timer_cnt;	
reg 					halt;
//----------------------------------------------------------
// wrapper between dat_ram and gprf
//---------------------------------------------------------- 
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		dram_to_wrp_dat_reg <= `MEM_W'b0;
	else if (t_cs)
		dram_to_wrp_dat_reg <= ipt_dram_to_wrp_dat;
	else	
		dram_to_wrp_dat_reg <= dram_to_wrp_dat_reg;
 end
 


 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_to_wrp_dat1_reg <= `DAT_W'b0;
	else if (t_cs)
		gprf_to_wrp_dat1_reg <= ipt_gprf_to_wrp_dat1;
	else
		gprf_to_wrp_dat1_reg <= gprf_to_wrp_dat1_reg;
 end

 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_to_wrp_dat2_reg <= `DAT_W'b0;
	else if (t_cs)
		gprf_to_wrp_dat2_reg <= ipt_gprf_to_wrp_dat2;
	else
		gprf_to_wrp_dat2_reg <= gprf_to_wrp_dat2_reg;
 end


// decdst indir addr sel 
  always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_indir_addr_sel_tmp <= 1'b0;
	else if (t_cs)
		decdst_to_wrp_indir_addr_sel_tmp <= ipt_decdst_to_wrp_indir_addr_sel;
	else
		decdst_to_wrp_indir_addr_sel_tmp <= decdst_to_wrp_indir_addr_sel_tmp;
 end
 
  always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_indir_addr_sel_reg <= 1'b0;
	else if (t_cs)
		decdst_to_wrp_indir_addr_sel_reg <= decdst_to_wrp_indir_addr_sel_tmp;
	else
		decdst_to_wrp_indir_addr_sel_reg <= decdst_to_wrp_indir_addr_sel_reg;
 end


 
  always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_imm_en_tmp <= 1'b0;
	else if (t_cs)
		decsrc_to_wrp_imm_en_tmp <= ipt_decsrc_to_wrp_imm_en;
	else
		decsrc_to_wrp_imm_en_tmp <= decsrc_to_wrp_imm_en_tmp;
 end
  always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_imm_en_reg <= 1'b0;
	else if (t_cs)
		decsrc_to_wrp_imm_en_reg <= decsrc_to_wrp_imm_en_tmp;
	else
		decsrc_to_wrp_imm_en_reg <= decsrc_to_wrp_imm_en_reg;
 end
 
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_imm_tmp <= `DMEMADDRW'b0;
	else if (t_cs)
		decsrc_to_wrp_imm_tmp <= ipt_decsrc_to_wrp_imm;
	else
		decsrc_to_wrp_imm_tmp <= decsrc_to_wrp_imm_tmp;
 end
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_imm_reg <= `DMEMADDRW'b0;
	else if (t_cs)
		decsrc_to_wrp_imm_reg <= decsrc_to_wrp_imm_tmp;
	else
		decsrc_to_wrp_imm_reg <= decsrc_to_wrp_imm_reg;
 end
 
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_en_b_tmp1 <= 1'b1;
	else if (t_cs)
		decsrc_to_wrp_en_b_tmp1 <= ipt_decsrc_to_wrp_en_b;
	else
		decsrc_to_wrp_en_b_tmp1 <= decsrc_to_wrp_en_b_tmp1;	
 end
  always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_en_b_tmp2 <= 1'b1;
	else if (t_cs)
		decsrc_to_wrp_en_b_tmp2 <= decsrc_to_wrp_en_b_tmp1;
	else
		decsrc_to_wrp_en_b_tmp2 <= decsrc_to_wrp_en_b_tmp2;	
 end
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_en_b_tmp3 <= 1'b1;
	else if (t_cs)
		decsrc_to_wrp_en_b_tmp3 <= decsrc_to_wrp_en_b_tmp2;
	else
		decsrc_to_wrp_en_b_tmp3 <= decsrc_to_wrp_en_b_tmp3;	
 end
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_en_b_tmp4 <= 1'b1;
	else if (t_cs)
		decsrc_to_wrp_en_b_tmp4 <= decsrc_to_wrp_en_b_tmp3;
	else
		decsrc_to_wrp_en_b_tmp4 <= decsrc_to_wrp_en_b_tmp4;	
 end

 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_en_b_tmp5 <= 1'b1;
	else if (t_cs)
		decsrc_to_wrp_en_b_tmp5 <= decsrc_to_wrp_en_b_tmp4;
	else
		decsrc_to_wrp_en_b_tmp5 <= decsrc_to_wrp_en_b_tmp5;	
 end

  always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decsrc_to_wrp_en_b_reg <= 1'b1;
	else if (t_cs)
		decsrc_to_wrp_en_b_reg <= decsrc_to_wrp_en_b_tmp5;
	else
		decsrc_to_wrp_en_b_reg <= decsrc_to_wrp_en_b_reg;	
 end
 
always@ (decsrc_to_wrp_imm_en_reg 
or decsrc_to_wrp_imm_reg
or decsrc_to_wrp_en_b_reg
or ipt_dram_to_wrp_dat
or gprf_to_wrp_dat1_reg
) 
begin
	if (decsrc_to_wrp_imm_en_reg) 	//source from imm 
		opt_wrp_to_gprf_dat <= decsrc_to_wrp_imm_reg;
	else if (~decsrc_to_wrp_en_b_reg)// source from dram
		opt_wrp_to_gprf_dat <= ipt_dram_to_wrp_dat;
	else 							//source from gprf
		opt_wrp_to_gprf_dat <= gprf_to_wrp_dat1_reg;
end


assign opt_wrp_to_dram_dat = gprf_to_wrp_dat1_reg;

always @ (decdst_to_wrp_indir_addr_sel_reg
	or gprf_to_wrp_dat1_reg
	or gprf_to_wrp_dat2_reg)
begin
	if (decdst_to_wrp_indir_addr_sel_reg)	
		opt_wrp_to_dram_addr <= gprf_to_wrp_dat2_reg[`DMEMADDRW-1:0];
	else
		opt_wrp_to_dram_addr <= `DMEMADDRW'd0;	
end

//----------------------------------------------------------
// wrapper between ins_decoder and gprf
//---------------------------------------------------------- 
//src part
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r0_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r0_r_sel_tmp <= ipt_decsrc_to_wrp_r0_r_sel;
	else
		decsrc_to_wrp_r0_r_sel_tmp <= decsrc_to_wrp_r0_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r1_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r1_r_sel_tmp <= ipt_decsrc_to_wrp_r1_r_sel;
	else
		decsrc_to_wrp_r1_r_sel_tmp <= decsrc_to_wrp_r1_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r2_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r2_r_sel_tmp <= ipt_decsrc_to_wrp_r2_r_sel;
	else
		decsrc_to_wrp_r2_r_sel_tmp <= decsrc_to_wrp_r2_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r3_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r3_r_sel_tmp <= ipt_decsrc_to_wrp_r3_r_sel;
	else
		decsrc_to_wrp_r3_r_sel_tmp <= decsrc_to_wrp_r3_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r4_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r4_r_sel_tmp <= ipt_decsrc_to_wrp_r4_r_sel;
	else
		decsrc_to_wrp_r4_r_sel_tmp <= decsrc_to_wrp_r4_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r5_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r5_r_sel_tmp <= ipt_decsrc_to_wrp_r5_r_sel;
	else
		decsrc_to_wrp_r5_r_sel_tmp <= decsrc_to_wrp_r5_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r6_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r6_r_sel_tmp <= ipt_decsrc_to_wrp_r6_r_sel;
	else
		decsrc_to_wrp_r6_r_sel_tmp <= decsrc_to_wrp_r6_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r7_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r7_r_sel_tmp <= ipt_decsrc_to_wrp_r7_r_sel;
	else
		decsrc_to_wrp_r7_r_sel_tmp <= decsrc_to_wrp_r7_r_sel_tmp;
end


	//r_t_sel
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r0_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r0_t_sel_tmp <= ipt_decsrc_to_wrp_r0_t_sel;
	else
		decsrc_to_wrp_r0_t_sel_tmp <= decsrc_to_wrp_r0_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r1_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r1_t_sel_tmp <= ipt_decsrc_to_wrp_r1_t_sel;
	else
		decsrc_to_wrp_r1_t_sel_tmp <= decsrc_to_wrp_r1_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r2_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r2_t_sel_tmp <= ipt_decsrc_to_wrp_r2_t_sel;
	else
		decsrc_to_wrp_r2_t_sel_tmp <= decsrc_to_wrp_r2_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r3_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r3_t_sel_tmp <= ipt_decsrc_to_wrp_r3_t_sel;
	else
		decsrc_to_wrp_r3_t_sel_tmp <= decsrc_to_wrp_r3_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r4_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r4_t_sel_tmp <= ipt_decsrc_to_wrp_r4_t_sel;
	else
		decsrc_to_wrp_r4_t_sel_tmp <= decsrc_to_wrp_r4_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r5_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r5_t_sel_tmp <= ipt_decsrc_to_wrp_r5_t_sel;
	else
		decsrc_to_wrp_r5_t_sel_tmp <= decsrc_to_wrp_r5_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r6_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r6_t_sel_tmp <= ipt_decsrc_to_wrp_r6_t_sel;
	else
		decsrc_to_wrp_r6_t_sel_tmp <= decsrc_to_wrp_r6_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_r7_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_r7_t_sel_tmp <= ipt_decsrc_to_wrp_r7_t_sel;
	else
		decsrc_to_wrp_r7_t_sel_tmp <= decsrc_to_wrp_r7_t_sel_tmp;
end


always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decsrc_to_wrp_rmod_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decsrc_to_wrp_rmod_t_sel_tmp <= ipt_decsrc_to_wrp_rmod_t_sel;
	else
		decsrc_to_wrp_rmod_t_sel_tmp <= decsrc_to_wrp_rmod_t_sel_tmp;
end

//dst part
	//r_r_sel 
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r0_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r0_r_sel_tmp <= ipt_decdst_to_wrp_r0_r_sel;
	else
		decdst_to_wrp_r0_r_sel_tmp <= decdst_to_wrp_r0_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r1_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r1_r_sel_tmp <= ipt_decdst_to_wrp_r1_r_sel;
	else
		decdst_to_wrp_r1_r_sel_tmp <= decdst_to_wrp_r1_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r2_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r2_r_sel_tmp <= ipt_decdst_to_wrp_r2_r_sel;
	else
		decdst_to_wrp_r2_r_sel_tmp <= decdst_to_wrp_r2_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r3_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r3_r_sel_tmp <= ipt_decdst_to_wrp_r3_r_sel;
	else
		decdst_to_wrp_r3_r_sel_tmp <= decdst_to_wrp_r3_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r4_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r4_r_sel_tmp <= ipt_decdst_to_wrp_r4_r_sel;
	else
		decdst_to_wrp_r4_r_sel_tmp <= decdst_to_wrp_r4_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r5_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r5_r_sel_tmp <= ipt_decdst_to_wrp_r5_r_sel;
	else
		decdst_to_wrp_r5_r_sel_tmp <= decdst_to_wrp_r5_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r6_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r6_r_sel_tmp <= ipt_decdst_to_wrp_r6_r_sel;
	else
		decdst_to_wrp_r6_r_sel_tmp <= decdst_to_wrp_r6_r_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r7_r_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r7_r_sel_tmp <= ipt_decdst_to_wrp_r7_r_sel;
	else
		decdst_to_wrp_r7_r_sel_tmp <= decdst_to_wrp_r7_r_sel_tmp;
end

	//r_t_sel 
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r0_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r0_t_sel_tmp <= ipt_decdst_to_wrp_r0_t_sel;
	else
		decdst_to_wrp_r0_t_sel_tmp <= decdst_to_wrp_r0_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r1_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r1_t_sel_tmp <= ipt_decdst_to_wrp_r1_t_sel;
	else
		decdst_to_wrp_r1_t_sel_tmp <= decdst_to_wrp_r1_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r2_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r2_t_sel_tmp <= ipt_decdst_to_wrp_r2_t_sel;
	else
		decdst_to_wrp_r2_t_sel_tmp <= decdst_to_wrp_r2_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r3_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r3_t_sel_tmp <= ipt_decdst_to_wrp_r3_t_sel;
	else
		decdst_to_wrp_r3_t_sel_tmp <= decdst_to_wrp_r3_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r4_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r4_t_sel_tmp <= ipt_decdst_to_wrp_r4_t_sel;
	else
		decdst_to_wrp_r4_t_sel_tmp <= decdst_to_wrp_r4_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r5_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r5_t_sel_tmp <= ipt_decdst_to_wrp_r5_t_sel;
	else
		decdst_to_wrp_r5_t_sel_tmp <= decdst_to_wrp_r5_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r6_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r6_t_sel_tmp <= ipt_decdst_to_wrp_r6_t_sel;
	else
		decdst_to_wrp_r6_t_sel_tmp <= decdst_to_wrp_r6_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_r7_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_r7_t_sel_tmp <= ipt_decdst_to_wrp_r7_t_sel;
	else
		decdst_to_wrp_r7_t_sel_tmp <= decdst_to_wrp_r7_t_sel_tmp;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b) 
		decdst_to_wrp_rmod_t_sel_tmp <= 0;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)
		decdst_to_wrp_rmod_t_sel_tmp <= ipt_decdst_to_wrp_rmod_t_sel;
	else
		decdst_to_wrp_rmod_t_sel_tmp <= decdst_to_wrp_rmod_t_sel_tmp;
end


//----------------------------------------------------------
// timer setup to tune ipt_decdst_to_wrp_rx_t_sel
//----------------------------------------------------------
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		timer_cnt <= `DLY_W'd0;
	else if ((ipt_pcif_to_wrp_halt && !timer_cnt))
		timer_cnt <= `DLY_W'd0;
	else if (ipt_alu_to_wrp_done)	
		timer_cnt <= `DLY_W'd1;
	else if (t_cs && ~ipt_decopr_to_wrp_delay_sel)// start counting down
		timer_cnt <= timer_cnt - `DLY_W'd1;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)// update delay info
		timer_cnt <= ipt_decopr_to_wrp_delay;
	else
		timer_cnt <= timer_cnt;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		halt <= 1'b0;
	else if (ipt_pcif_to_wrp_halt && timer_cnt == `DLY_W'd0)
		halt <= 1'b1;
	else
		halt <= 1'b0;
end

assign opt_wrp_to_gprf_r0_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r0_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r0_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r1_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r1_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r1_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r2_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r2_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r2_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r3_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r3_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r3_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r4_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r4_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r4_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r5_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r5_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r5_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r6_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r6_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r6_t_sel_tmp : 1'b0);
assign opt_wrp_to_gprf_r7_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_r7_t_sel_tmp : ((~halt && timer_cnt == `DLY_W'd1)? decsrc_to_wrp_r7_t_sel_tmp : 1'b0);

assign opt_wrp_to_gprf_rmod_t_sel = (~halt && timer_cnt == `DLY_W'd0)? decdst_to_wrp_rmod_t_sel_tmp : 1'b0;

assign opt_wrp_to_bus1_gprf_r0_r_sel =  decsrc_to_wrp_r0_r_sel_tmp; 
assign opt_wrp_to_bus1_gprf_r1_r_sel =  decsrc_to_wrp_r1_r_sel_tmp;
assign opt_wrp_to_bus1_gprf_r2_r_sel =  decsrc_to_wrp_r2_r_sel_tmp;
assign opt_wrp_to_bus1_gprf_r3_r_sel =  decsrc_to_wrp_r3_r_sel_tmp;
assign opt_wrp_to_bus1_gprf_r4_r_sel =  decsrc_to_wrp_r4_r_sel_tmp;
assign opt_wrp_to_bus1_gprf_r5_r_sel =  decsrc_to_wrp_r5_r_sel_tmp;
assign opt_wrp_to_bus1_gprf_r6_r_sel =  decsrc_to_wrp_r6_r_sel_tmp;
assign opt_wrp_to_bus1_gprf_r7_r_sel =  decsrc_to_wrp_r7_r_sel_tmp;


assign opt_wrp_to_bus2_gprf_r0_r_sel = decdst_to_wrp_r0_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r1_r_sel = decdst_to_wrp_r1_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r2_r_sel = decdst_to_wrp_r2_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r3_r_sel = decdst_to_wrp_r3_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r4_r_sel = decdst_to_wrp_r4_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r5_r_sel = decdst_to_wrp_r5_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r6_r_sel = decdst_to_wrp_r6_r_sel_tmp;
assign opt_wrp_to_bus2_gprf_r7_r_sel = decdst_to_wrp_r7_r_sel_tmp;

endmodule