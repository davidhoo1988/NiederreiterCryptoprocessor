//===============================================================================
//  File Name            : ./auto/bus.v
//  File Revision        : 2.0
//  Author               : ws
//  History:            
//                              2008        Rev1.0  yaoyongbin
//                              2009.07     Rev2.0  ws
//  ----------------------------------------------------------------------------
//  Description      : This module is 
//
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================
// synthesis translate_off
`include    "timescale.v"
// synthesis translate_on
`include    "define.v"

module bus(
alu1_r_dat,
alu1_r_cry_dat,
alu2_r_dat,
alu2_r_cry_dat,
ldst1_r_dat,
ldst2_r_dat,
ldst3_r_dat,
gprf_r_dat,
imm,
bus_dat
);
input wire [`DAT_W-1:0] alu1_r_dat;
input wire [`DAT_W-1:0] alu2_r_dat;
input wire [`DAT_W-1:0] alu2_r_cry_dat;
input wire [`DAT_W-1:0] ldst1_r_dat;
input wire [`DAT_W-1:0] gprf_r_dat;
input wire [`DAT_W-1:0] imm;
output wire [`DAT_W-1:0] bus_dat;

//set all values to `DAT_W'b0 expect the one is expected to be transferred.
assign bus_dat = imm | alu1_r_dat | alu2_r_dat | alu2_r_cry_dat | ldst1_r_dat |  gprf_r_dat;

endmodule