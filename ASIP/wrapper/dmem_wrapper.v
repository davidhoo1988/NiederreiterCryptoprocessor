//===============================================================================
//                         External Interface With Tcore
//                        and Memory Interface With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/dmem_wrapper.v
//  File Revision        : 3.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2014.12		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module interface between data_ram and ins_decoder
//  ----------------------------------------------------------------------------
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"
module dmem_wrapper(
		//input
		input wire 						clk,
		input wire 						reset_b,
		input wire						t_cs,
		input wire						t_rw,
		//input from ins_decoder src to wrapper, read only
		input wire						ipt_decsrc_to_wrp_en_b,
		input wire	[`DMEMADDRW-1:0]	ipt_decsrc_to_wrp_addr,													
		//input from ins_decoder dst to wrapper, write only
		input wire						ipt_decdst_to_wrp_en_b,		
		input wire						ipt_decdst_to_wrp_rw,
		input wire	[`DMEMADDRW-1:0]	ipt_decdst_to_wrp_addr,	
		//input from ins_decoder opr to wrapper
		input wire [`DLY_W-1:0]			ipt_decopr_to_wrp_delay,
		//input from sprf_wrapper to wrapper, for indirect referencing
		input wire [`DMEMADDRW-1:0]		ipt_sprfwrp_to_wrp_addr,
		//output from wrapper to dat_ram
		output wire 					opt_wrp_to_dram_en_b, // either from src or dst
		output wire 					opt_wrp_to_dram_rw,
		output wire [`DMEMADDRW-1:0]	opt_wrp_to_dram_addr // either from src or dst or gprf_indirect_address
);
//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 

reg	[`DMEMADDRW-1:0]	decsrc_to_wrp_addr_reg;

reg						decdst_to_wrp_rw_reg;
reg	[`DMEMADDRW-1:0]	decdst_to_wrp_addr_reg;


reg						decdst_to_wrp_rw_tmp1,decdst_to_wrp_rw_tmp2,decdst_to_wrp_rw_tmp3;
reg	[`DMEMADDRW-1:0]	decdst_to_wrp_addr_tmp1, decdst_to_wrp_addr_tmp2;

reg [`DMEMADDRW-1:0]	sprfwrp_to_wrp_addr_reg;
//----------------------------------------------------------
// wrapper between dat_ram and ins_decoder
//----------------------------------------------------------   
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_rw_tmp1 <= 1; //read by default
	else if (t_cs)
		decdst_to_wrp_rw_tmp1 <= ipt_decdst_to_wrp_rw;
	else
		decdst_to_wrp_rw_tmp1 <= decdst_to_wrp_rw_tmp1;
 end
 
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_rw_tmp2 <= 1; //read by default
	else if (t_cs)
		decdst_to_wrp_rw_tmp2 <= decdst_to_wrp_rw_tmp1;
	else
		decdst_to_wrp_rw_tmp2 <= decdst_to_wrp_rw_tmp2;
 end
 
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_rw_tmp3 <= 1; //read by default
	else if (t_cs)
		decdst_to_wrp_rw_tmp3 <= decdst_to_wrp_rw_tmp2;
	else
		decdst_to_wrp_rw_tmp3 <= decdst_to_wrp_rw_tmp3;
 end

 
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_addr_tmp1 <= `DMEMADDRW'b0;
	else if (t_cs)
		decdst_to_wrp_addr_tmp1 <= ipt_decdst_to_wrp_addr;
	else
		decdst_to_wrp_addr_tmp1 <= decdst_to_wrp_addr_tmp1;
 end
 
always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		decdst_to_wrp_addr_tmp2 <= `DMEMADDRW'b0;
	else if (t_cs)
		decdst_to_wrp_addr_tmp2 <= decdst_to_wrp_addr_tmp1;
	else
		decdst_to_wrp_addr_tmp2 <= decdst_to_wrp_addr_tmp2;
 end



always@ (decdst_to_wrp_rw_tmp1
or decdst_to_wrp_rw_tmp3
or ipt_decopr_to_wrp_delay
) 
begin
	decdst_to_wrp_rw_reg <= decdst_to_wrp_rw_tmp1;
	case (ipt_decopr_to_wrp_delay)
		`DLY_W'd2: //indirect referencing
				decdst_to_wrp_rw_reg <= decdst_to_wrp_rw_tmp3;
	endcase
end



//----------------------------------------------------------
// wrapper between dat_ram and sprf, for indirect addressing
//---------------------------------------------------------- 
 
 always@ (posedge clk or negedge reset_b) begin
	if (!reset_b)
		sprfwrp_to_wrp_addr_reg <= `DMEMADDRW'b0;
	else if (t_cs)
		sprfwrp_to_wrp_addr_reg <= ipt_sprfwrp_to_wrp_addr;
	else
		sprfwrp_to_wrp_addr_reg <= sprfwrp_to_wrp_addr_reg;
 end

//----------------------------------------------------------
// wrapper between dat_ram and gprf, for indirect addressing
//---------------------------------------------------------- 
 
assign opt_wrp_to_dram_en_b 		= 1'b0;
assign opt_wrp_to_dram_rw 			= decdst_to_wrp_rw_reg;
assign opt_wrp_to_dram_addr  	    = sprfwrp_to_wrp_addr_reg;


endmodule