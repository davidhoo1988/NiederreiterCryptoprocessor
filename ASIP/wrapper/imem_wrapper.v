//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/imem_wrapper.v
//  File Revision        : 3.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2014.12		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module interface between ins_ram and pc_if
//  ----------------------------------------------------------------------------
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"
module imem_wrapper(
		//input
		input wire 						clk,
		input wire 						reset_b,
		input wire						t_cs,
		input wire						t_rw,
		//input from pc_if to wrapper, connected to ins_ram
		input wire 						ipt_pcif_to_wrp_en_b,
		input wire	[`IMEMADDRW-1:0]	ipt_pcif_to_wrp_addr,
		//output from wrapper to ins_ram
		output wire 					opt_wrp_to_iram_en_b,
		output wire	[`IMEMADDRW-1:0] 	opt_wrp_to_iram_addr,
		
		//input from ins_ram to wrapper, connected to pc_if
		input wire 	[`INS_W-1:0]		ipt_iram_to_wrp_dat,
		//output from wrapper to pc_if
		output wire [`INS_W-1:0]		opt_wrp_to_pcif_dat,
		output wire 					opt_wrp_to_pcif_lockrq,
		output reg 						opt_wrp_to_pcif_jmp_addr_sel,
		output wire	[`DST_W-1:0]		opt_wrp_to_pcif_jmp_addr,
		//input from ins_decoder opr to wrapper
		input wire  [`OPR_W-1:0]		ipt_decopr_to_wrp_opr_typ_sel,
		input wire 	[`DLY_W-1:0]		ipt_decopr_to_wrp_delay,
		input wire						ipt_decopr_to_wrp_delay_sel,
		//input from ins_decoder dst to wrapper, used to transfer jmp addr for JMP instructions
		input wire 						ipt_decdst_to_wrp_jmp_addr_sel,
		input wire	[`DST_W-1:0]		ipt_decdst_to_wrp_jmp_addr,	
		//input from alu to wrapper, used for conditional jmp instruction
		input wire 						ipt_alu_to_wrp_jmp_addr_sel,
		//input from alu to wrapper, used for MUL and DIV	
		input wire 						ipt_alu_to_wrp_alu_done
);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg 					pcif_to_wrp_en_b_reg;
reg	[`IMEMADDRW-1:0] 	pcif_to_wrp_addr_reg;
reg	[`INS_W-1:0]		iram_to_wrp_dat_reg; 
reg						decdst_to_wrp_jmp_addr_sel_reg;
reg [`DST_W-1:0]		decdst_to_wrp_jmp_addr_reg;

reg	[`DLY_W-1:0]		timer_cnt;	

reg 					alu_done_tmp1, alu_done_tmp2;

//----------------------------------------------------------
// wrapper between ins_ram and pc_if
//----------------------------------------------------------    
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
			pcif_to_wrp_en_b_reg <= 0;
	else if (t_cs)
			pcif_to_wrp_en_b_reg <= ipt_pcif_to_wrp_en_b;
	else	
			pcif_to_wrp_en_b_reg <= pcif_to_wrp_en_b_reg;

end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		pcif_to_wrp_addr_reg <= `IMEMADDRW'b0;
	else if (t_cs)
		pcif_to_wrp_addr_reg <= ipt_pcif_to_wrp_addr;
	else	
		pcif_to_wrp_addr_reg <= pcif_to_wrp_addr_reg;
end

always@	(posedge clk or negedge reset_b) begin
	if (!reset_b)
		iram_to_wrp_dat_reg <= `INS_W'b0;
	else if (t_cs)
		iram_to_wrp_dat_reg <= ipt_iram_to_wrp_dat;
	else	
		iram_to_wrp_dat_reg <= iram_to_wrp_dat_reg;
end

assign opt_wrp_to_iram_en_b = pcif_to_wrp_en_b_reg;
assign opt_wrp_to_iram_addr = pcif_to_wrp_addr_reg;
assign opt_wrp_to_pcif_dat 	= iram_to_wrp_dat_reg;

//----------------------------------------------------------
// wrapper between ins_decoder and pc_if, 
// updating mv_PC for JMP instructions
//---------------------------------------------------------- 
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_jmp_addr_sel_reg <= 1'b0;
	else if (t_cs)	
		decdst_to_wrp_jmp_addr_sel_reg <= ipt_decdst_to_wrp_jmp_addr_sel;
	else
		decdst_to_wrp_jmp_addr_sel_reg <= decdst_to_wrp_jmp_addr_sel_reg;
end

always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_jmp_addr_reg <= `DST_W'b0;
	else if (t_cs)
		decdst_to_wrp_jmp_addr_reg <= ipt_decdst_to_wrp_jmp_addr;
	else
		decdst_to_wrp_jmp_addr_reg <= decdst_to_wrp_jmp_addr_reg;
end

always@ (ipt_decopr_to_wrp_opr_typ_sel or timer_cnt) begin
	if (ipt_decopr_to_wrp_opr_typ_sel==`OPR_W'd16 && timer_cnt == ipt_decopr_to_wrp_delay)//jmp
		opt_wrp_to_pcif_jmp_addr_sel <= decdst_to_wrp_jmp_addr_sel_reg;
	else if (ipt_decopr_to_wrp_opr_typ_sel==`OPR_W'd17 && timer_cnt == `DLY_W'd3)//jnz
		opt_wrp_to_pcif_jmp_addr_sel <= ipt_alu_to_wrp_jmp_addr_sel;
	else //arithmetic
		opt_wrp_to_pcif_jmp_addr_sel <= 1'b0;
end

assign opt_wrp_to_pcif_jmp_addr 	= decdst_to_wrp_jmp_addr_reg;

//----------------------------------------------------------
// delay alu_done to trigger pcif_lockrq
//---------------------------------------------------------- 
/*always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_done_tmp1 <= 0;
	else if (t_cs)
		alu_done_tmp1 <= ipt_alu_to_wrp_alu_done;
	else
		alu_done_tmp1 <= alu_done_tmp1;	
end	
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		alu_done_tmp2 <= 0;
	else if (t_cs)
		alu_done_tmp2 <= alu_done_tmp1;
	else
		alu_done_tmp2 <= alu_done_tmp2;	
end*/	
//----------------------------------------------------------
// timer setup to lock pc_if periodically 
//----------------------------------------------------------
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b || ipt_alu_to_wrp_alu_done)
		timer_cnt <= `DLY_W'd0;
	else if (t_cs && ~ipt_decopr_to_wrp_delay_sel)// start counting down
		timer_cnt <= timer_cnt - `DLY_W'd1;
	else if (t_cs && ipt_decopr_to_wrp_delay_sel)// update delay info
		timer_cnt <= ipt_decopr_to_wrp_delay;
	else
		timer_cnt <= timer_cnt;
end

assign opt_wrp_to_pcif_lockrq = (ipt_iram_to_wrp_dat != `ALLNOP)? ((timer_cnt != `DLY_W'd0)? 1:0) : 1; //1--lock pc_if; 0--unlock

endmodule