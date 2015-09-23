//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./wrapper/sprf_wrapper.v
//  File Revision        : 1.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2015.05		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module interface between prng and ins_decoder
//  ----------------------------------------------------------------------------
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"
module sprf_wrapper(
		input wire 						clk,
        input wire 						reset_b,
		input wire 						t_cs,
		
		// input from ins_decoder to sprf_wrp, connected to sprf
		input wire  [`DLY_W-1:0]		ipt_decopr_to_wrp_delay,

		// input from ins_decoder to sprf_wrp, connected to sprf
		input wire	[`SPRF_TYP_W-1:0]	ipt_decopr_to_sprf_r0_typ_sel,
		input wire	[`SPRF_TYP_W-1:0]	ipt_decopr_to_sprf_r1_typ_sel,

		input wire 						ipt_decsrc_to_sprf0_r_sel,
		input wire						ipt_decsrc_to_sprf1_r_sel,

		input wire 						ipt_decdst_to_sprf0_r_sel,
		input wire						ipt_decdst_to_sprf1_r_sel,


		//input from ins_decoder to sprf_wrp, to control opt_wrp_to_dram_addr
		input wire 						ipt_decsrc_to_wrp_indir_addr_sel,
		input wire 						ipt_decdst_to_wrp_indir_addr_sel,

		// input from sprf to sprf_wrp, connected to dmem_wrapper
		input wire  [`SPRF_DAT_W-1:0] 	ipt_sprf_to_wrp_dat,
		// output from sprf_wrp to sprf
		output wire [`SPRF_TYP_W-1:0]	opt_wrp_to_sprf_r0_typ_sel,
		output wire [`SPRF_TYP_W-1:0]	opt_wrp_to_sprf_r1_typ_sel,


		output wire 					opt_wrp_to_sprf0_r_sel,	
		output wire 					opt_wrp_to_sprf1_r_sel,	
		// input from gprf to sprf_wrp, to update IDX with gprf values 
		input wire	[`SPRF_DAT_W-1:0]	ipt_gprf_to_wrp_dat,
		// output from sprf_wrp to sprf
		output wire [`SPRF_DAT_W-1:0]	opt_wrp_to_sprf_t_dat,
		//output from sprf_wrp to dmem_wrapper, src indirect addr referencing
		output wire [`DMEMADDRW-1:0] 	opt_wrp_to_dram_addr

);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
(* max_fanout = "50" *) 
reg [`SPRF_TYP_W-1:0] 	sprf_r0_typ_sel_tmp1,	sprf_r1_typ_sel_tmp1;

reg [`SPRF_TYP_W-1:0] 	sprf_r0_typ_sel_tmp2,	sprf_r1_typ_sel_tmp2;

reg 					sprf0_r_sel_tmp1,	sprf1_r_sel_tmp1;

reg						sprf0_r_sel_tmp2, 	sprf1_r_sel_tmp2;

reg	[`SPRF_DAT_W-1:0]	sprf_t_dat;

reg 					decsrc_to_wrp_indir_addr_sel_reg, decdst_to_wrp_indir_addr_sel_reg;
reg [`DMEMADDRW-1:0]	dram_addr_tmp;

//----------------------------------------------------------
// wrapper between gprf and ins_decoder
//---------------------------------------------------------- 
//first stage
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf_r0_typ_sel_tmp1 <= 0;
	else if (t_cs)
		sprf_r0_typ_sel_tmp1 <= ipt_decopr_to_sprf_r0_typ_sel;
	else	
		sprf_r0_typ_sel_tmp1 <= sprf_r0_typ_sel_tmp1;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf_r1_typ_sel_tmp1 <= 0;
	else if (t_cs)
		sprf_r1_typ_sel_tmp1 <= ipt_decopr_to_sprf_r1_typ_sel;
	else	
		sprf_r1_typ_sel_tmp1 <= sprf_r1_typ_sel_tmp1;
end



//second stage
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf_r0_typ_sel_tmp2 <= 0;
	else if (t_cs)
		sprf_r0_typ_sel_tmp2 <= sprf_r0_typ_sel_tmp1;
	else	
		sprf_r0_typ_sel_tmp2 <= sprf_r0_typ_sel_tmp2;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf_r1_typ_sel_tmp2 <= 0;
	else if (t_cs)
		sprf_r1_typ_sel_tmp2 <= sprf_r1_typ_sel_tmp1;
	else	
		sprf_r1_typ_sel_tmp2 <= sprf_r1_typ_sel_tmp2;
end


assign opt_wrp_to_sprf_r0_typ_sel = sprf_r0_typ_sel_tmp2;
assign opt_wrp_to_sprf_r1_typ_sel = sprf_r1_typ_sel_tmp2;

//first stage
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf0_r_sel_tmp1 <= 0;
	else if (t_cs)
		sprf0_r_sel_tmp1 <= ipt_decsrc_to_sprf0_r_sel | ipt_decdst_to_sprf0_r_sel;
	else	
		sprf0_r_sel_tmp1 <= sprf0_r_sel_tmp1;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf1_r_sel_tmp1 <= 0;
	else if (t_cs)
		sprf1_r_sel_tmp1 <= ipt_decsrc_to_sprf1_r_sel | ipt_decdst_to_sprf1_r_sel;
	else	
		sprf1_r_sel_tmp1 <= sprf1_r_sel_tmp1;
end

assign opt_wrp_to_sprf0_r_sel = sprf0_r_sel_tmp1;
assign opt_wrp_to_sprf1_r_sel = sprf1_r_sel_tmp1;

//----------------------------------------------------------
// wrapper between sprf and gprf
//----------------------------------------------------------
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf_t_dat <= 0;
	else if (t_cs)
		sprf_t_dat <= ipt_gprf_to_wrp_dat[`SPRF_DAT_W-1:0];
	else
		sprf_t_dat <= sprf_t_dat;
end

assign opt_wrp_to_sprf_t_dat = sprf_t_dat;

//----------------------------------------------------------
// wrapper between sprf and dram
//----------------------------------------------------------
always @(posedge clk or negedge reset_b) begin // read dram
	if (!reset_b)
		decsrc_to_wrp_indir_addr_sel_reg <= 0;
	else
		decsrc_to_wrp_indir_addr_sel_reg <= ipt_decsrc_to_wrp_indir_addr_sel;	
end

always @(posedge clk or negedge reset_b) begin // write dram
	if (!reset_b)
		decdst_to_wrp_indir_addr_sel_reg <= 0;
	else
		decdst_to_wrp_indir_addr_sel_reg <= ipt_decdst_to_wrp_indir_addr_sel;	
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		dram_addr_tmp <= 0;
	else if (t_cs && (decsrc_to_wrp_indir_addr_sel_reg | decdst_to_wrp_indir_addr_sel_reg))
		dram_addr_tmp <= ipt_sprf_to_wrp_dat[`DMEMADDRW-1:0];	
	else
		dram_addr_tmp <= `DMEMADDRW'b0;
end

assign opt_wrp_to_dram_addr = dram_addr_tmp;

endmodule