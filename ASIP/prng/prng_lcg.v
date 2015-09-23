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
//						using "Linear Congruent Generator" approach.
						//this->seed = this->seed * 1103515245 + 12345; 	 
						//return (unsigned int)(this->seed/65536) % 32768;
//  ----------------------------------------------------------------------------
//===============================================================================


// synthesis translate_on
`include "../include/define.v"
`timescale 1ns/1ns


 module prng_lcg
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

wire 	[31:0]					lcg_arith, result_low, result_high;
reg 	[2:0]					cnt;
reg 	[31:0] 					prng_seed_reg;


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

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 	ST_PRE  	= 0, //do nothing, then get prepared
			SEED_UPDATE = 1, //update seed
			RNG_GEN  = 2; //generate random numbers


//----------------------------------------------------------
//1st always block, sequential state transition
//----------------------------------------------------------
		reg    [1:0]   NextState, CurrentState;
		always @ (posedge clk or negedge rst_b)
			  if (!rst_b)            
					CurrentState <= ST_PRE;        
			  else                  
					CurrentState <= NextState; 
//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------		
		always @ (CurrentState or prng_typ_reg or cnt)
			begin
               case (CurrentState)
					ST_PRE:	begin
									if (prng_typ_reg == `PRNG_TYP_W'd2)//update seed
										NextState = SEED_UPDATE;
									else if (prng_typ_reg == `PRNG_TYP_W'd1)//generate RNG
										NextState = RNG_GEN;
									else
										NextState = ST_PRE;	
								end
					SEED_UPDATE: begin
									NextState = ST_PRE;
					end
					RNG_GEN: begin
									if(cnt == 3'd3)
										NextState = ST_PRE;
									else
										NextState = RNG_GEN;	
					end
					default: NextState = ST_PRE;
				endcase
		end	


//----------------------------------------------------------
//3rd always block, the sequential FSM output
//----------------------------------------------------------		
always @ (posedge clk or negedge rst_b) begin
	if (!rst_b) begin
		cnt 			<= 0;
		prng_seed_reg 	<= 0;
		prng_r_dat 		<= 0;
	end
	else begin
		case (CurrentState)
			ST_PRE: begin
				prng_r_dat <= prng_r_dat;
				prng_seed_reg <= prng_seed_reg;
				cnt <= 0;
			end	
			SEED_UPDATE: begin
				prng_r_dat <= prng_r_dat;
				prng_seed_reg <= prng_t_reg;
				cnt <= 0;
			end
			RNG_GEN: begin
				prng_r_dat <= lcg_arith[30:16];
				prng_seed_reg <= lcg_arith;
				cnt <= cnt + 1;
			end
		endcase
	end
end	
//----------------------------------------------------------
// logic computation part
//----------------------------------------------------------							
assign lcg_arith = result_low + 14'd12345;


MUL_32bit multiplier(
	//input
	.clk			(clk				), 
	.multiplicand	(prng_seed_reg		),
	.multiplier		(32'd1103515245		), 
	//output
	.result			({result_high,result_low})
);
endmodule

