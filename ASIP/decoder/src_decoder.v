//===============================================================================
//  File Name            : ./auto/src_decoder.v
//  File Revision        : 2.0
//  Author               : ws
//  History:            
//                              2008        Rev1.0  yaoyongbin
//                              2009.07     Rev2.0  ws
//								2015.08 	Rev 3.0 	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This module is decoding OPERAND1 of the instruction structure. 
//  				   Note OPERAND1 can be register, memory or immediate data.
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================
`include    "../include/define.v"

module src_decoder(
	src_code,
	opr_code,

	dat_ram_addr_en_b,
	dat_ram_addr,
	imm_dat_sel,
	imm_dat,
	indir_addr_sel,
	//GPRF read
	r0_r_sel,
	r1_r_sel,
	r2_r_sel,
	r3_r_sel,
	r4_r_sel,
	r5_r_sel,
	r6_r_sel,
	r7_r_sel,

	//GPRF write
	r0_t_sel,
	r1_t_sel,
	r2_t_sel,
	r3_t_sel,
	r4_t_sel,
	r5_t_sel,
	r6_t_sel,
	r7_t_sel,	
	rmod_t_sel,

	//sprf read
	sprf0_r_sel,
	sprf1_r_sel
);

input wire [`SRC_W-1:0] 		src_code;
input wire [`OPR_W-1:0]			opr_code;

output reg 						dat_ram_addr_en_b;
output reg [`DMEMADDRW-1:0] 	dat_ram_addr;
output reg						imm_dat_sel;
output reg [`IMM_DAT_W-1:0] 	imm_dat;
output reg 						indir_addr_sel;

output reg 						r0_r_sel,
								r1_r_sel,
								r2_r_sel,
								r3_r_sel,
								r4_r_sel,
								r5_r_sel,
								r6_r_sel,
								r7_r_sel;
							

output reg 						r0_t_sel,
								r1_t_sel,
								r2_t_sel,
								r3_t_sel,
								r4_t_sel,
								r5_t_sel,
								r6_t_sel,
								r7_t_sel,
								rmod_t_sel;


output reg 						sprf0_r_sel,
								sprf1_r_sel;

always @(src_code or opr_code)
begin
	dat_ram_addr_en_b <= 1; //0 effective 
	dat_ram_addr <= 0;
	imm_dat_sel <= 0;
	imm_dat <= 0;
	indir_addr_sel <= 0;

	r0_r_sel <= 0;
	r1_r_sel <= 0;
	r2_r_sel <= 0;
	r3_r_sel <= 0;
	r4_r_sel <= 0;
	r5_r_sel <= 0;
	r6_r_sel <= 0;
	r7_r_sel <= 0;

	r0_t_sel <= 0;
	r1_t_sel <= 0;
	r2_t_sel <= 0;
	r3_t_sel <= 0;
	r4_t_sel <= 0;
	r5_t_sel <= 0;
	r6_t_sel <= 0;
	r7_t_sel <= 0;
	rmod_t_sel <= 0;

	sprf0_r_sel <= 0;
	sprf1_r_sel <= 0;

	case (src_code[`SRC_W-1:`SRC_W-3])
		3'b000:	begin
					if (opr_code == `OPR_W'd5 || opr_code == `OPR_W'd9 || opr_code == `OPR_W'd11) begin // if DIV or SPLIT or RSHIFT
						case (src_code[`SRC_W-4:0]) // assume GPRF src
							`SRC_GPRF_W'd0:		begin 
												r0_r_sel <= 1; 
												r0_t_sel <= 1;
												end
							`SRC_GPRF_W'd1:		begin 
												r1_r_sel <= 1; 
												r1_t_sel <= 1;
												end
							`SRC_GPRF_W'd2:		begin 
												r2_r_sel <= 1; 
												r2_t_sel <= 1;
												end
							`SRC_GPRF_W'd3:		begin 
												r3_r_sel <= 1; 
												r3_t_sel <= 1;
												end
							`SRC_GPRF_W'd4:		begin 
												r4_r_sel <= 1; 
												r4_t_sel <= 1;
												end
							`SRC_GPRF_W'd5:		begin 
												r5_r_sel <= 1; 
												r5_t_sel <= 1;
												end
							`SRC_GPRF_W'd6:		begin
												r6_r_sel <= 1; 
												r6_t_sel <= 1;
												end
							`SRC_GPRF_W'd7:		begin 
												r7_r_sel <= 1; 
												r7_t_sel <= 1;
												end	
						endcase	
					end	
					
					else begin 
						if (opr_code == `OPR_W'd17)	//JRE, compared with R7 by default
							r7_r_sel <= 1;
						else
							r7_r_sel <= 0;

						case (src_code[`SRC_W-4:0]) // assume GPRF src
								`SRC_GPRF_W'd0:		r0_r_sel <= 1;
								`SRC_GPRF_W'd1:		r1_r_sel <= 1;
								`SRC_GPRF_W'd2:		r2_r_sel <= 1;
								`SRC_GPRF_W'd3:		r3_r_sel <= 1;
								`SRC_GPRF_W'd4:		r4_r_sel <= 1;
								`SRC_GPRF_W'd5:		r5_r_sel <= 1;
								`SRC_GPRF_W'd6:		r6_r_sel <= 1;
								`SRC_GPRF_W'd7:		r7_r_sel <= 1;
								
								`SRC_GPRF_W'd32:	sprf0_r_sel <= 1;
								`SRC_GPRF_W'd33:	sprf1_r_sel <= 1;
						endcase
					end
				end
				
		3'b010:	begin						//assume immediate data src
					imm_dat_sel <= 1;
					imm_dat <= src_code[`SRC_W-4:0];
				end	

		3'b100: begin						//assume gprf rmod src
					if (opr_code == `OPR_W'd5)
						r7_t_sel <= 1;
					else
						r7_t_sel <= 0;
				end				

		3'b101:	begin						// assume indirect register-referecing --- @IDX
				dat_ram_addr_en_b 	<= 1'b0; 		//0 effective
				indir_addr_sel 		<= 1'b1;
				case (src_code[`SRC_W-4:0]) // assume SPRF
					`SRC_GPRF_W'd32:		sprf0_r_sel <= 1;
					`SRC_GPRF_W'd33:		sprf1_r_sel <= 1;
				endcase	

		end				
	endcase
	
end
endmodule