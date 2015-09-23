//===============================================================================
//  File Name            : ./auto/gprf.v
//  File Revision        : 2.0
//  Author               : ws
//  History:            
//                              2008        Rev1.0  yaoyongbin
//                              2009.07     Rev2.0  ws
//								2014.12		Rev3.0	David J.W. HU
//								2015.01		Rev3.1	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This module is 
//
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================

// synthesis translate_on
`include    "../include/define.v"

module gprf(
input wire clk,
input wire rst_b,
	
input wire bus1_r0_t_sel,
input wire bus1_r1_t_sel,
input wire bus1_r2_t_sel,
input wire bus1_r3_t_sel,
input wire bus1_r4_t_sel,
input wire bus1_r5_t_sel,
input wire bus1_r6_t_sel,
input wire bus1_r7_t_sel,

input wire [`DAT_W-1:0] 	bus1_dat,

input wire bus1_rmod_t_sel,

input wire bus1_r0_r_sel,
input wire bus1_r1_r_sel,
input wire bus1_r2_r_sel,
input wire bus1_r3_r_sel,
input wire bus1_r4_r_sel,
input wire bus1_r5_r_sel,
input wire bus1_r6_r_sel,
input wire bus1_r7_r_sel,

input wire bus2_r0_r_sel,
input wire bus2_r1_r_sel,
input wire bus2_r2_r_sel,
input wire bus2_r3_r_sel,
input wire bus2_r4_r_sel,
input wire bus2_r5_r_sel,
input wire bus2_r6_r_sel,
input wire bus2_r7_r_sel,

input wire bus1_rmod_r_sel,

output reg [`DAT_W-1:0] 	bus1_gprf_r_dat,
output reg [`DAT_W-1:0] 	bus2_gprf_r_dat,
output reg [`LDAT_W-1:0]	bus1_gprf_rmod_r_dat
);

reg [`DAT_W-1:0] r[0:7];
reg	[`LDAT_W-1:0] rmod;

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[0] <= `DAT_W'd0;
else
case(bus1_r0_t_sel)
1'b1: r[0] <= bus1_dat;
default: r[0] <= r[0];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[1] <= `DAT_W'd0;
else
case(bus1_r1_t_sel)
1'b1: r[1] <= bus1_dat;
default: r[1] <= r[1];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[2] <= `DAT_W'd0;
else
case(bus1_r2_t_sel)
1'b1: r[2] <= bus1_dat;
default: r[2] <= r[2];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[3] <= `DAT_W'd0;
else
case(bus1_r3_t_sel)
1'b1: r[3] <= bus1_dat;
default: r[3] <= r[3];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[4] <= `DAT_W'd0;
else
case(bus1_r4_t_sel)
1'b1: r[4] <= bus1_dat;
default: r[4] <= r[4];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[5] <= `DAT_W'd0;
else
case(bus1_r5_t_sel)
1'b1: r[5] <= bus1_dat;
default: r[5] <= r[5];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[6] <= `DAT_W'd0;
else
case(bus1_r6_t_sel)
1'b1: r[6] <= bus1_dat;
default: r[6] <= r[6];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  r[7] <= `DAT_W'd0;
else
case(bus1_r7_t_sel)
1'b1: r[7] <= bus1_dat;
default: r[7] <= r[7];
endcase
end

always @ (posedge clk or negedge rst_b)
begin
if (!rst_b)  rmod <= `LDAT_W'd0;
else
case(bus1_rmod_t_sel)
1'd1: rmod <= {bus1_dat,1'b1};
default: rmod <= rmod;
endcase
end

//combinational logic
always @ (bus1_r0_r_sel or r[0]
or bus1_r1_r_sel or r[1]
or bus1_r2_r_sel or r[2]
or bus1_r3_r_sel or r[3]
or bus1_r4_r_sel or r[4]
or bus1_r5_r_sel or r[5]
or bus1_r6_r_sel or r[6]
or bus1_r7_r_sel or r[7]
) 
begin
	case (1'b1)
	bus1_r0_r_sel: bus1_gprf_r_dat <= r[0];
	bus1_r1_r_sel: bus1_gprf_r_dat <= r[1];
	bus1_r2_r_sel: bus1_gprf_r_dat <= r[2];
	bus1_r3_r_sel: bus1_gprf_r_dat <= r[3];
	bus1_r4_r_sel: bus1_gprf_r_dat <= r[4];
	bus1_r5_r_sel: bus1_gprf_r_dat <= r[5];
	bus1_r6_r_sel: bus1_gprf_r_dat <= r[6];
	bus1_r7_r_sel: bus1_gprf_r_dat <= r[7];
	default: bus1_gprf_r_dat <= 0;
	endcase
end

always @ (bus2_r0_r_sel or r[0]
or bus2_r1_r_sel or r[1]
or bus2_r2_r_sel or r[2]
or bus2_r3_r_sel or r[3]
or bus2_r4_r_sel or r[4]
or bus2_r5_r_sel or r[5]
or bus2_r6_r_sel or r[6]
or bus2_r7_r_sel or r[7]
) 
begin
	case (1'b1)
	bus2_r0_r_sel: bus2_gprf_r_dat <= r[0];
	bus2_r1_r_sel: bus2_gprf_r_dat <= r[1];
	bus2_r2_r_sel: bus2_gprf_r_dat <= r[2];
	bus2_r3_r_sel: bus2_gprf_r_dat <= r[3];
	bus2_r4_r_sel: bus2_gprf_r_dat <= r[4];
	bus2_r5_r_sel: bus2_gprf_r_dat <= r[5];
	bus2_r6_r_sel: bus2_gprf_r_dat <= r[6];
	bus2_r7_r_sel: bus2_gprf_r_dat <= r[7];
	default: bus2_gprf_r_dat <= `DAT_W'd0;
	endcase
end


always @ (bus1_rmod_r_sel or rmod) begin
	case (1'b1)
		bus1_rmod_r_sel: 	bus1_gprf_rmod_r_dat <= rmod;
		default:			bus1_gprf_rmod_r_dat <= `LDAT_W'd0;	
	endcase
end
endmodule