//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/alu_wrapper.v
//  File Revision        : 3.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2014.12		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module interface between alu and gprf
//  ----------------------------------------------------------------------------
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"
module alu_wrapper(
		input wire 						clk,
        input wire 						reset_b,
		input wire 						t_cs,
		
		// input from ins_decoder to alu_wrp, connected to alu
		input wire  [`DLY_W-1:0]		ipt_decopr_to_wrp_delay,
		input wire 						ipt_decopr_to_wrp_div_mod_sel,
		// input from ins_decoder to alu_wrp, connected to alu
		input wire						ipt_decopr_to_alu_o_sel,
		input wire						ipt_decopr_to_alu_t_sel,
		input wire	[`ALU_TYP_W-1:0]	ipt_decopr_to_alu_typ_sel,

		// input from gprf to alu_wrp, connected to alu
		input wire	[`DAT_W-1:0]		ipt_gprf_to_wrp_dat1,
		input wire	[`DAT_W-1:0]		ipt_gprf_to_wrp_dat2,
		input wire 	[`LDAT_W-1:0]		ipt_gprf_to_wrp_mod,
		// input from sprf to alu_wrp, connected to alu
		input wire 	[`SPRF_DAT_W-1:0] 	ipt_sprf_to_wrp_dat,
		// output from alu_wrp to alu, ctl source from ins_decoder and data source from gprf
		output wire 					opt_wrp_to_alu_o_sel,
		output wire						opt_wrp_to_alu_t_sel,
		output wire [`ALU_TYP_W-1:0]	opt_wrp_to_alu_typ_sel,
		
		output wire [`LDAT_W-1:0]		opt_wrp_to_alu_o_dat,
		output wire [`DAT_W-1:0]		opt_wrp_to_alu_t_dat,
		
		// input from alu to alu_wrp: I--connected to gprf for storage. II--connected to pc_if for conditional jmp.
		input wire	[`DAT_W-1:0]		ipt_alu_to_wrp_dat,
		// input from alu to alu_wrp: DIV remainder value, connected to gprf for storage
		input wire  [`DAT_W-1:0]		ipt_alu_to_wrp_dat2,
		input wire  					ipt_alu_to_wrp_done,
		// output from alu_wrp to gprf, store the result
		output wire	[`DAT_W-1:0]		opt_wrp_to_gprf_t_dat,
		// output from alu_wrp to pc_if, trigger jmp_sel
		output wire 					opt_wrp_to_pcif_jmp_sel,
		// output from alu_wrp to imem, trigger instruction fetch
		output wire 					opt_wrp_to_imem_done						
);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg [`ALU_TYP_W-1:0] 	alu_typ_sel_tmp1, alu_typ_sel_tmp2;
reg						alu_o_sel_tmp1, alu_o_sel_tmp2;
reg 					alu_t_sel_tmp1, alu_t_sel_tmp2;
reg 					div_mod_sel_tmp1, div_mod_sel_tmp2;

reg [`LDAT_W-1:0] 		gprf_mod_r_dat;
reg	[`DAT_W-1:0]		gprf_t_dat, gprf_t_dat2;
reg [`LDAT_W-1:0]		gprf_bus1_r_dat;
reg [`DAT_W-1:0] 		gprf_bus2_r_dat;
reg [`SPRF_DAT_W-1:0]   sprf_r_dat;

reg 					alu_done_tmp1, alu_done_tmp2, alu_done_tmp3;
//----------------------------------------------------------
// wrapper between alu and ins_decoder
//---------------------------------------------------------- 
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_typ_sel_tmp1 <= 0;
	else if (t_cs)
		alu_typ_sel_tmp1 <= ipt_decopr_to_alu_typ_sel;
	else	
		alu_typ_sel_tmp1 <= alu_typ_sel_tmp1;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_typ_sel_tmp2 <= 0;
	else if (t_cs)
		alu_typ_sel_tmp2 <= alu_typ_sel_tmp1;
	else	
		alu_typ_sel_tmp2 <= alu_typ_sel_tmp2;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_o_sel_tmp1 <= 0;
	else if (t_cs)
		alu_o_sel_tmp1 <= ipt_decopr_to_alu_o_sel;
	else
		alu_o_sel_tmp1 <= alu_o_sel_tmp1;
end
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_o_sel_tmp2 <= 0;
	else if (t_cs)
		alu_o_sel_tmp2 <= alu_o_sel_tmp1;
	else
		alu_o_sel_tmp2 <= alu_o_sel_tmp2;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_t_sel_tmp1 <= 0;
	else if (t_cs)
		alu_t_sel_tmp1 <= ipt_decopr_to_alu_t_sel;
	else
		alu_t_sel_tmp1 <= alu_t_sel_tmp1;
end
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_t_sel_tmp2 <= 0;
	else if (t_cs)
		alu_t_sel_tmp2 <= alu_t_sel_tmp1;
	else
		alu_t_sel_tmp2 <= alu_t_sel_tmp2;
end


always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		div_mod_sel_tmp1 <= 0;
	else if (t_cs)
		div_mod_sel_tmp1 <= ipt_decopr_to_wrp_div_mod_sel;	
	else
		div_mod_sel_tmp1 <= div_mod_sel_tmp1;	
end
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		div_mod_sel_tmp2 <= 0;
	else if (t_cs)
		div_mod_sel_tmp2 <= div_mod_sel_tmp1;	
	else
		div_mod_sel_tmp2 <= div_mod_sel_tmp2;	
end

assign opt_wrp_to_alu_typ_sel = alu_typ_sel_tmp2;
assign opt_wrp_to_alu_o_sel   = alu_o_sel_tmp2;
assign opt_wrp_to_alu_t_sel   = alu_t_sel_tmp2;

//----------------------------------------------------------
// wrapper between alu and gprf
//----------------------------------------------------------
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_bus1_r_dat <= 0;
	else if (t_cs)
		gprf_bus1_r_dat <= ipt_gprf_to_wrp_dat1;
	else
		gprf_bus1_r_dat <= gprf_bus1_r_dat;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_bus2_r_dat <= 0;
	else if (t_cs)
		gprf_bus2_r_dat <= ipt_gprf_to_wrp_dat2;
	else
		gprf_bus2_r_dat <= gprf_bus2_r_dat;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_mod_r_dat <= 0;
	else if (t_cs)
		gprf_mod_r_dat <= ipt_gprf_to_wrp_mod;
	else
		gprf_mod_r_dat <= gprf_mod_r_dat;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_t_dat <= 0;
	else if (t_cs)
		gprf_t_dat <= ipt_alu_to_wrp_dat;
	else
		gprf_t_dat <= gprf_t_dat;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_t_dat2 <= 0;
	else if (t_cs)
		gprf_t_dat2 <= ipt_alu_to_wrp_dat2;
	else
		gprf_t_dat2 <= gprf_t_dat2;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprf_r_dat <= 0;
	else if (t_cs)
		sprf_r_dat <= ipt_sprf_to_wrp_dat;
	else
		sprf_r_dat <= sprf_r_dat;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_done_tmp1 <= 0;
	else if (t_cs)
		alu_done_tmp1 <= ipt_alu_to_wrp_done;
	else
		alu_done_tmp1 <= alu_done_tmp1;		
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_done_tmp2 <= 0;
	else if (t_cs)
		alu_done_tmp2 <= alu_done_tmp1;
	else
		alu_done_tmp2 <= alu_done_tmp2;		
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_done_tmp3 <= 0;
	else if (t_cs)
		alu_done_tmp3 <= alu_done_tmp2;
	else
		alu_done_tmp3 <= alu_done_tmp3;		
end
//----------------------------------------------------------
// wrapper between alu and pcif, gprf, sprf, imem
//----------------------------------------------------------
assign opt_wrp_to_alu_o_dat = div_mod_sel_tmp2 ? gprf_mod_r_dat : {gprf_bus1_r_dat,1'b0};
assign opt_wrp_to_alu_t_dat = gprf_bus2_r_dat | {124'b0, sprf_r_dat}; //DAT_W - SPRF_DAT_W
assign opt_wrp_to_gprf_t_dat = ((alu_typ_sel_tmp1==`ALU_TYP_W'd5  && alu_done_tmp2==1'b1) || (alu_typ_sel_tmp1==`ALU_TYP_W'd2 && alu_done_tmp2==1'b1) || (alu_typ_sel_tmp1==`ALU_TYP_W'd8 && alu_done_tmp2==1'b1)) ? gprf_t_dat2 : gprf_t_dat; //if DIV, SPLIT, RSHIFT, gprf_t_dat and gprf_t_dat2 are output sequentially.
assign opt_wrp_to_pcif_jmp_sel = gprf_t_dat[`DAT_W-1];


assign opt_wrp_to_imem_done = alu_done_tmp1;
endmodule