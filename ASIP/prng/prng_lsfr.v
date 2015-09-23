//===============================================================================
//                         Pseudo Random Number Generator With Tcore
//  ----------------------------------------------------------------------------
//  File Name            : ./auto/prng.v
//  File Revision        : 1.0
//  Author               : David J.W. HU
//  Email                 :davidhoo471494221@gmail.com
//  History:            
//								2015.3		Rev1.0	David 
//  ----------------------------------------------------------------------------
//  Description      : This module is the random number generator of our processor
//						The generating polynomial is x^25 + x^3 + 1
//  ----------------------------------------------------------------------------
//===============================================================================


// synthesis translate_on
`include "../include/define.v"
`timescale 1ns/1ns


 module prng_lsfr
(
	input wire 					clk,
	input wire 					rst_b,
	input wire 	[`PRNG_TYP_W-1:0]	prng_typ_sel, //'0' halting prng, '1' for triggering the prng, '2' for updating initial seed
	input wire 	[`PRNG_DAT_W-1:0]	prng_t_dat, //initial value of LSFR
	input wire 						prng_t_sel,
	output reg  [`PRNG_DAT_W-1:0]   prng_r_dat
);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg		[`PRNG_TYP_W-1:0]		 prng_typ_reg;
reg		[`PRNG_DAT_W-1:0]		 prng_t_reg;

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		prng_typ_reg <= 0;
	else
		prng_typ_reg <= prng_typ_sel;
end

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		prng_t_reg <= 0;
	else if (prng_t_sel)
		prng_t_reg <= prng_t_dat;
	else
		prng_t_reg <= prng_t_reg;
end

//
//----------------------------------------------------------
// logic computation part
//----------------------------------------------------------

always @ (posedge clk or negedge rst_b)
begin
	if (!rst_b)
		prng_r_dat <= 0;
	else 
		case (prng_typ_reg)
			// pause
			`PRNG_TYP_W'd0:
				prng_r_dat <= prng_r_dat;
			// rotate	
			`PRNG_TYP_W'd1:
				prng_r_dat <= {prng_r_dat[`PRNG_DAT_W-2:0],prng_r_dat[`PRNG_DAT_W-1]^prng_r_dat[2]};
			// update seed
			`PRNG_TYP_W'd2:
				prng_r_dat <= prng_t_reg;
			default:  
				prng_r_dat <= prng_r_dat;
		endcase
		
end
							

endmodule

