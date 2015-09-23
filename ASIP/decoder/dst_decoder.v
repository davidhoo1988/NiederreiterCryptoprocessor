//===============================================================================
//  File Name            : ./auto/dst_decoder.v
//  File Revision        : 2.0
//  Author               : ws
//  History:            
//                              2008        Rev1.0  yaoyongbin
//                              2009.07     Rev2.0  ws
//								2015.08 	Rev 3.0 	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This module is decoding OPERAND2 of the instruction structure. 
//  				   Note OPERAND1 can be register or memory.
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================

// synthesis translate_on
`include    "../include/define.v"


module dst_decoder(
	//input
	dst_code,
	opr_code,
	//output
	dat_ram_addr_en_b,
	dat_ram_rw, // 1 read and 0 write
	dat_ram_addr,
	indir_addr_sel,
	
	r0_r_sel,
	r1_r_sel,
	r2_r_sel,
	r3_r_sel,
	r4_r_sel,
	r5_r_sel,
	r6_r_sel,
	r7_r_sel,
	

	sprf0_r_sel,
	sprf1_r_sel,


	r0_t_sel,
	r1_t_sel,
	r2_t_sel,
	r3_t_sel,
	r4_t_sel,
	r5_t_sel,
	r6_t_sel,
	r7_t_sel,
	rmod_t_sel,
	
	jmp_addr_sel,
	jmp_addr
);

input wire [`DST_W-1:0] 	dst_code;
input wire [`OPR_W-1:0]		opr_code;

output reg 					dat_ram_addr_en_b;
output reg 					dat_ram_rw;
output reg [`DMEMADDRW-1:0] dat_ram_addr;
output reg					indir_addr_sel;

output reg 	r0_r_sel,	
			r1_r_sel,	
			r2_r_sel,	
			r3_r_sel,
			r4_r_sel,
			r5_r_sel,
			r6_r_sel,
			r7_r_sel;
		

output reg 	sprf0_r_sel,
			sprf1_r_sel;
			
			
output reg 	r0_t_sel,	
			r1_t_sel,	
			r2_t_sel,	
			r3_t_sel,
			r4_t_sel,
			r5_t_sel,
			r6_t_sel,
			r7_t_sel;
			

output reg  rmod_t_sel;

output reg 					jmp_addr_sel;
output reg  [`DST_W-1:0]	jmp_addr;			
			
always @(dst_code or opr_code) begin	
	dat_ram_addr_en_b 	<= 1; //0 effective 
	dat_ram_rw 			<= 1; //1 read and 0 write
	dat_ram_addr 		<= 0;
	indir_addr_sel      <= 0; //no direct referencing by default
	
	r0_r_sel <= 0;
	r1_r_sel <= 0;
	r2_r_sel <= 0;
	r3_r_sel <= 0;
	r4_r_sel <= 0;
	r5_r_sel <= 0;
	r6_r_sel <= 0;
	r7_r_sel <= 0;
	
	sprf0_r_sel <= 0;
	sprf1_r_sel <= 0;
	
	
	r0_t_sel <= 0;
	r1_t_sel <= 0;
	r2_t_sel <= 0;
	r3_t_sel <= 0;
	r4_t_sel <= 0;
	r5_t_sel <= 0;
	r6_t_sel <= 0;
	r7_t_sel <= 0;
	
	rmod_t_sel <= 0;

	jmp_addr_sel <= 0;
	jmp_addr <= jmp_addr;
	
	//MOV instruction
	if (opr_code == `OPR_W'd1) begin 
		case (dst_code[`DST_W-1:`DST_W-3])
			3'b000:	begin
						case (dst_code[`DST_W-4:0]) // assume GPRF dst
							`DST_GPRF_W'd0:		r0_t_sel <= 1;
							`DST_GPRF_W'd1:		r1_t_sel <= 1;
							`DST_GPRF_W'd2:		r2_t_sel <= 1;
							`DST_GPRF_W'd3:		r3_t_sel <= 1;
							`DST_GPRF_W'd4:		r4_t_sel <= 1;
							`DST_GPRF_W'd5:		r5_t_sel <= 1;
							`DST_GPRF_W'd6:		r6_t_sel <= 1;
							`DST_GPRF_W'd7:		r7_t_sel <= 1;			
						endcase
					end	
			3'b001:	begin				 		// assume Dat_Ram dst
						dat_ram_addr_en_b 	<= 1'b0; //0 effective 
						dat_ram_rw 			<= 1'b0;		//1 read and 0 write
						dat_ram_addr 		<= dst_code[`DST_W-4:0];
					end
			3'b100: begin
						rmod_t_sel <= 1;	
					end
			3'b101: begin
						dat_ram_addr_en_b 	<= 1'b0; 		//0 effective
						dat_ram_rw 			<= 1'b0;		//1 read and 0 write
						indir_addr_sel 		<= 1'b1;
						case (dst_code[`DST_W-4:0]) // assume SPRF
							`SRC_GPRF_W'd32:		sprf0_r_sel <= 1;
							`SRC_GPRF_W'd33:		sprf1_r_sel <= 1;
						endcase	
					end		   	
		endcase
	end	
	//ALU instruction --- ADD, SUB, MUL, DIV, INV, SPLIT, DEG, RSHIFT, EVAL  OR PRNG instruction
	else if (opr_code == `OPR_W'd2 || opr_code == `OPR_W'd3 || opr_code == `OPR_W'd4 || opr_code == `OPR_W'd5 || opr_code == `OPR_W'd6 || opr_code == `OPR_W'd8 || opr_code == `OPR_W'd9 || opr_code == `OPR_W'd10 || opr_code == `OPR_W'd11 || opr_code == `OPR_W'd12) begin
		case (dst_code[`DST_W-4:0])
			`DST_GPRF_W'd0: begin
				r0_r_sel <= 1;
				r0_t_sel <= 1;
			end
			`DST_GPRF_W'd1: begin
				r1_r_sel <= 1;
				r1_t_sel <= 1;
			end
			`DST_GPRF_W'd2: begin
				r2_r_sel <= 1;
				r2_t_sel <= 1;
			end
			`DST_GPRF_W'd3: begin
				r3_r_sel <= 1;
				r3_t_sel <= 1;
			end
			`DST_GPRF_W'd4: begin
				r4_r_sel <= 1;
				r4_t_sel <= 1;
			end
			`DST_GPRF_W'd5: begin
				r5_r_sel <= 1;
				r5_t_sel <= 1;
			end
			`DST_GPRF_W'd6: begin
				r6_r_sel <= 1;
				r6_t_sel <= 1;
			end
			`DST_GPRF_W'd7: begin
				r7_r_sel <= 1;
				r7_t_sel <= 1;
			end
		endcase
	end
	
	
	//JMP instruction
	else if (opr_code == `OPR_W'd16) begin
		jmp_addr_sel	<= 1'b1;
		jmp_addr 		<= dst_code;
	end
	//JRE instruction, compared with R31 by default
	else if (opr_code == `OPR_W'd17) begin
		jmp_addr_sel	<= 1'b0;
		jmp_addr 		<= dst_code;
	end
end	

endmodule