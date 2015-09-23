//===============================================================================
//  File Name            : ./auto/imm_decoder.v
//  File Revision        : 2.0
//  Author               : ws
//  History:            
//                              2008        Rev1.0  yaoyongbin
//                              2009.07     Rev2.0  ws
//								2014.11		Rev3.0	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This module is designed to divide the instructions fetched from ins_ram
//					into three different partitions.
// 	instruction structure:
//
//     MSB        	bit24---bit20    	bit19---bit10  		bit9---bit0   
//    -------------------------------------------------------------------------
//					| OPERATION 		| OPERAND1          | OPERAND2
//    -------------------------------------------------------------------------
//	Example:
//			MOV rx addr;	MOV rx addr;	MOV imm rx;	Mov imm addr;
//			ADD rx ry;		ADD addr rx;	 
//  ----------------------------------------------------------------------------

// synthesis translate_on
`include    "../include/define.v"


module ins_slicer(
	input wire [`INS_W-1:0] instruction,
	
	output wire [`OPR_W-1:0] bus1_opr_code,
	output wire [`SRC_W-1:0] bus1_src_code,
	output wire [`DST_W-1:0] bus1_dst_code
);

assign bus1_opr_code = instruction[`INS_W-1:`INS_W-`OPR_W];
assign bus1_src_code = instruction[`INS_W-`OPR_W-1:`DST_W];
assign bus1_dst_code = instruction[`DST_W-1:0];

endmodule