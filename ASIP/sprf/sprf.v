//===============================================================================
//  File Name            : ./auto/sprf.v
//  File Revision        : 2.0
//  Author               : ws
//  History:            
//								2015.05		Rev1.0	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This module is the specific purpose register file, used for
//					   addressing gprf with variable: Rx, Ry
//  ----------------------------------------------------------------------------
//===============================================================================

// synthesis translate_on

`include    "../include/define.v"

module sprf(
//input
input wire clk,
input wire rst_b,

input wire [`SPRF_DAT_W-1:0]		sprf_t_dat,

input wire [`SPRF_TYP_W-1:0]		r0_typ_sel,
input wire [`SPRF_TYP_W-1:0]		r1_typ_sel,


input wire 							r0_r_sel,
input wire 							r1_r_sel,


//output
output wire [`SPRF_DAT_W-1:0] 		sprf_r_dat0,
output wire [`SPRF_DAT_W-1:0] 		sprf_r_dat1,

output reg [`SPRF_DAT_W-1:0] 		sprf_r_dat
);

reg [`SPRF_DAT_W-1:0] r[0:1];

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)  r[0] <= `DAT_W'd0;
	else
		case(r0_typ_sel)
			`SPRF_TYP_W'd1: 		r[0] <= sprf_t_dat;
			`SPRF_TYP_W'd2: 		r[0] <= r[0] + 1'b1;
			`SPRF_TYP_W'd3: 		r[0] <= r[0] - 1'b1;
			default: 				r[0] <= r[0];
		endcase
end

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)  r[1] <= `DAT_W'd0;
	else
		case(r1_typ_sel)
			`SPRF_TYP_W'd1: 		r[1] <= sprf_t_dat;
			`SPRF_TYP_W'd2: 		r[1] <= r[1] + 1'b1;
			`SPRF_TYP_W'd3: 		r[1] <= r[1] - 1'b1;
			default: 				r[1] <= r[1];
		endcase
end


assign sprf_r_dat0 = r[0];
assign sprf_r_dat1 = r[1];


always @ (r[0] or r[1]  
	or r0_r_sel or r1_r_sel) 
begin
	case(1'b1)
		r0_r_sel:  sprf_r_dat <=  r[0];
		r1_r_sel:  sprf_r_dat <=  r[1];
		default:   sprf_r_dat <= `DAT_W'd0;
	endcase
	
end

endmodule