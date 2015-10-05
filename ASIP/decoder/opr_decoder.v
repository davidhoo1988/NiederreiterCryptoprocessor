//===============================================================================
//  File Name            : ./auto/opr_decoder.v
//  File Revision        : 1.0
//  Author               : David
//  History:            
//								2014.11		Rev 1.0		David J.W. HU
//								2015.08 	Rev 2.0 	David J.W. HU
//  ----------------------------------------------------------------------------
//  Description      : This module is decoding OPERAND TYPE of the instruction structure. 
//  				   Namely, to determine which operation would be triggered
//  ----------------------------------------------------------------------------

`include    "../include/define.v"
	
module opr_decoder(
	//input
	opr_code,
	dst_code,
	src_typ,
	dst_typ,
	//output
	opr_typ_sel,
	opr_div_mod_sel,
	
	alu_o_sel, //'1' for triggering the data fetch from external bus
	alu_t_sel, //'1' for triggering the data fetch from external bus
	alu_typ_sel,

	prng_t_sel,
	prng_typ_sel,

	sprf_typ_r0_sel,
	sprf_typ_r1_sel,


	src_dst_delay_sel,
	src_dst_delay
);

input wire [`OPR_W-1:0] 		opr_code;
input wire [`DST_W-1:0]			dst_code;
input wire [2:0] 				src_typ, dst_typ;

output reg [`OPR_W-1:0] 		opr_typ_sel;
output reg 						opr_div_mod_sel;

output reg 						alu_o_sel, alu_t_sel; 
output reg [`ALU_TYP_W-1:0] 	alu_typ_sel;

output reg 						prng_t_sel;
output reg [`PRNG_TYP_W-1:0]	prng_typ_sel;

output reg [`SPRF_TYP_W-1:0]	sprf_typ_r0_sel, sprf_typ_r1_sel;

output reg 						src_dst_delay_sel;
output reg [`DLY_W-1:0] 		src_dst_delay;

always @(opr_code or dst_code or src_typ or dst_typ)
begin
	opr_typ_sel			<= opr_typ_sel;
	opr_div_mod_sel     <= 0;
	
	alu_o_sel 			<= 0;
	alu_t_sel 			<= 0;
	alu_typ_sel 		<= alu_typ_sel;
	
	prng_t_sel 			<= 0;
	prng_typ_sel		<= 0;
	
	sprf_typ_r0_sel 	<= 0;
	sprf_typ_r1_sel 	<= 0;


	src_dst_delay_sel 	<= 0;
	src_dst_delay 		<= src_dst_delay;
	
	
	case (opr_code)
		//MOV
		`OPR_W'd1: begin
					case ({src_typ,dst_typ})
						//MOV @IDX Rx
						{3'b101,3'b000}: begin
							opr_typ_sel			<= opr_code;
							src_dst_delay_sel 	<= 1;
							src_dst_delay 		<= `DLY_W'd4;
						end	
						//MOV @IDX Rmod
						{3'b101,3'b100}: begin
							opr_typ_sel			<= opr_code;
							src_dst_delay_sel 	<= 1;
							src_dst_delay 		<= `DLY_W'd4;
						end	
						//MOV imm Rx
						{3'b010,3'b000}: begin
									opr_typ_sel			<= opr_code;
									src_dst_delay_sel 	<= 1;
									src_dst_delay 		<= `DLY_W'd1; //actually '0' is enough, but we have to tune memory transfer delay	
						end
						//MOV Rx Ry || MOV Ry IDX[x]
						{3'b000,3'b000}: begin
									opr_typ_sel			<= opr_code;
									src_dst_delay_sel 	<= 1;
									src_dst_delay 		<= `DLY_W'd1;
									
									case (dst_code[`SRC_W-4:0])
										`DST_GPRF_W'd32:		sprf_typ_r0_sel <= `SPRF_TYP_W'd1;
										`DST_GPRF_W'd33:		sprf_typ_r1_sel <= `SPRF_TYP_W'd1;
									endcase	
						end
						//MOV Rx Rmod
						{3'b000,3'b100}: begin
									opr_typ_sel			<= opr_code;
									src_dst_delay_sel 	<= 1;
									src_dst_delay 		<= `DLY_W'd1;		
						end
						//MOV Rx @IDX[y]
						{3'b000,3'b101}: begin
									opr_typ_sel 		<= opr_code;
									src_dst_delay_sel 	<= 1;
									src_dst_delay 		<= `DLY_W'd2;
						end
					endcase
		end
		//ADD
		`OPR_W'd2: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd1;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd4;
					end			
		//SUB
		`OPR_W'd3: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd2;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd4;
					end
		//MUL
		`OPR_W'd4: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd3;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd255;
					end
		//DIV
		`OPR_W'd5: begin
					if (src_typ == 3'b100)
						opr_div_mod_sel <= 1;
					else
						opr_div_mod_sel <= 0;

					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd5;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd255;
					end
		//PRNG
		`OPR_W'd6: begin
						case ({src_typ,dst_typ})
						//PRNG #seed Rx
							{3'b010,3'b000}: begin 
								opr_typ_sel			<= opr_code;
								prng_t_sel			<= 1;
								prng_typ_sel		<= `PRNG_TYP_W'd2;
								src_dst_delay_sel 	<= 1;
								src_dst_delay 		<= `DLY_W'd3;
							end
						//PRNG Rx
							{3'b000,3'b000}: begin 
								opr_typ_sel			<= opr_code;
								prng_t_sel			<= 0;
								prng_typ_sel		<= `PRNG_TYP_W'd1;
								src_dst_delay_sel 	<= 1;
								src_dst_delay 		<= `DLY_W'd4;	
							end
						endcase
					end
		//IDX
		`OPR_W'd7: begin
						case (dst_typ)
						//IDX++
							3'b000: begin
								opr_typ_sel 		<= opr_code;
								src_dst_delay_sel 	<= 1;
								src_dst_delay 		<= `DLY_W'd2;

								case (dst_code[`SRC_W-4:0])
										`DST_GPRF_W'd32:		sprf_typ_r0_sel <= `SPRF_TYP_W'd2;
										`DST_GPRF_W'd33:		sprf_typ_r1_sel <= `SPRF_TYP_W'd2;
								endcase	
							end
						//IDX--
							3'b001: begin
								opr_typ_sel <= opr_code;
								src_dst_delay_sel 	<= 1;
								src_dst_delay 		<= `DLY_W'd2;

								case (dst_code[`SRC_W-4:0])
										`DST_GPRF_W'd32:		sprf_typ_r0_sel <= `SPRF_TYP_W'd3;
										`DST_GPRF_W'd33:		sprf_typ_r1_sel <= `SPRF_TYP_W'd3;
								endcase	
							end
						endcase
					end	
		//INV
		`OPR_W'd8: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd6;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd21;	
					end		
		//SPLIT
		`OPR_W'd9: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd2;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd255;	
					end		
		//DEG
		`OPR_W'd10: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd7;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd255;	
					end				
		//RSHIFT
		`OPR_W'd11: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd8;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd255;	
		end	
		//EVAL
		`OPR_W'd12: begin
					if (src_typ == 3'b100)
						opr_div_mod_sel <= 1;
					else
						opr_div_mod_sel <= 0;
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd9;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd21;	
		end							
		//JMP,  unconditional jump instruction			
		`OPR_W'd16: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 0;
					alu_t_sel 			<= 0;
					alu_typ_sel 		<= `ALU_TYP_W'd0;
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd3;
					end	
		//JRE,  conditional jump instruction	
		`OPR_W'd17: begin
					opr_typ_sel			<= opr_code;
					alu_o_sel 			<= 1;
					alu_t_sel 			<= 1;
					alu_typ_sel 		<= `ALU_TYP_W'd4; //judge whether it is '0' or not.
					src_dst_delay_sel 	<= 1;
					src_dst_delay 		<= `DLY_W'd7;
					end
	endcase
end

endmodule