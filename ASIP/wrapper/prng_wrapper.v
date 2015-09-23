//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./wrapper/gprf_wrapper.v
//  File Revision        : 1.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2015.04		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module interface between prng and ins_decoder
//  ----------------------------------------------------------------------------
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"
module prng_wrapper(
		input wire 						clk,
        input wire 						reset_b,
		input wire 						t_cs,
		
		// input from ins_decoder to prng_wrp, connected to prng
		input wire  [`DLY_W-1:0]		ipt_decopr_to_wrp_delay,
		// input from ins_decoder to prng_wrp, connected to prng
		input wire						ipt_decopr_to_prng_t_sel,
		input wire	[`PRNG_TYP_W-1:0]	ipt_decopr_to_prng_typ_sel,
		// input from ins_decoder to prng_wrp, connected to prng
		input wire 	[`IMM_DAT_W-1:0]	ipt_decsrc_to_prng_imm,
		// output from prng_wrp to prng, ctl source from ins_decoder and intermediate data from ins_decoder src
		output wire						opt_wrp_to_prng_t_sel,
		output wire [`PRNG_TYP_W-1:0]	opt_wrp_to_prng_typ_sel,
		
		output wire [`PRNG_DAT_W-1:0]	opt_wrp_to_prng_t_dat,	

		// input from prng to prng_wrp: 
		input wire	[`PRNG_DAT_W-1:0]		ipt_prng_to_wrp_dat,
		// output from prng_wrp to gprf, store the result
		output wire	[`PRNG_DAT_W-1:0]		opt_wrp_to_gprf_t_dat		
);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg [`PRNG_TYP_W-1:0] 	prng_typ_sel_tmp1;
reg 					prng_t_sel_tmp1;
reg [`IMM_DAT_W-1:0]	prng_t_dat_tmp1;
reg	[`DAT_W-1:0]		gprf_t_dat;

//----------------------------------------------------------
// wrapper between prng and ins_decoder
//---------------------------------------------------------- 
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		prng_typ_sel_tmp1 <= 0;
	else if (t_cs)
		prng_typ_sel_tmp1 <= ipt_decopr_to_prng_typ_sel;
	else	
		prng_typ_sel_tmp1 <= prng_typ_sel_tmp1;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		prng_t_sel_tmp1 <= 0;
	else if (t_cs)
		prng_t_sel_tmp1 <= ipt_decopr_to_prng_t_sel;
	else
		prng_t_sel_tmp1 <= prng_t_sel_tmp1;
end

always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		prng_t_dat_tmp1 <= 0;
	else if (t_cs)
		prng_t_dat_tmp1 <= ipt_decsrc_to_prng_imm;
	else
		prng_t_dat_tmp1 <= prng_t_dat_tmp1;
end

assign opt_wrp_to_prng_typ_sel = prng_typ_sel_tmp1;
assign opt_wrp_to_prng_t_sel   = prng_t_sel_tmp1;
assign opt_wrp_to_prng_t_dat   = prng_t_dat_tmp1;

//----------------------------------------------------------
// wrapper between prng and gprf
//----------------------------------------------------------
always @(posedge clk or negedge reset_b) begin
	if (!reset_b)
		gprf_t_dat <= 0;
	else if (t_cs)
		gprf_t_dat <= ipt_prng_to_wrp_dat + `PRNG_DAT_W'd7287;
	else
		gprf_t_dat <= gprf_t_dat;
end

assign opt_wrp_to_gprf_t_dat = gprf_t_dat;

endmodule