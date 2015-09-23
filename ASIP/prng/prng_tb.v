`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define    PRNG_DAT_W      25

module prng_tb();
	reg clk;
    reg rst_b;
	reg prng_t_sel;
    reg [`PRNG_DAT_W-1:0] prng_t_dat;
    reg [1:0]        	  prng_typ_sel;        
	wire[`PRNG_DAT_W-1:0] prng_r_dat;

    
prng_lcg uut(
	.clk			(clk),
	.rst_b			(rst_b),
	.prng_typ_sel	(prng_typ_sel), //'0' halting prng, '1' for triggering the prng, '2' for updating initial seed
	.prng_t_sel		(prng_t_sel),
	.prng_t_dat		(prng_t_dat), //initial value of LSFR
	.prng_r_dat		(prng_r_dat)
);
	
	initial begin
		// Initialize Inputs
		$display("PRNG test begins:");  
		$monitor($time, "prng_typ_sel = %d, prng_t_dat = %d ,prng_r_dat = %d",prng_typ_sel, prng_t_dat, prng_r_dat);
		clk = 1;
		rst_b = 0;
		prng_t_sel = 0;
		prng_t_dat = 0;
		prng_typ_sel = 0;
				
		#(5*`CLK_PERIOD)	rst_b = 1'b1;
							
		
		/* 1st round */
		 
		// update seed	
		#(3*`CLK_PERIOD)	prng_typ_sel = 2'b10;
							prng_t_sel = 1'b1;							
							prng_t_dat = `PRNG_DAT_W'd100;

		#(`CLK_PERIOD)		prng_typ_sel = 2'b0;
							prng_t_sel = 1'b0;					
		//Generate RNG series							
		#(3*`CLK_PERIOD)	prng_t_sel = 1'b0;
							prng_typ_sel = 2'b1;

		//Halt prng	
		#(`CLK_PERIOD)		prng_t_sel = 1'b0;
							prng_typ_sel = 2'b0;
							
		
		/* 2nd round */
		//Generate RNG series							
		#(10*`CLK_PERIOD)	prng_t_sel = 1'b0;
							prng_typ_sel = 2'b1;
                     
		//Halt prng	
		#(`CLK_PERIOD)		prng_t_sel = 1'b0;
							prng_typ_sel = 2'b0;

		
end
	
	initial begin
	
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
	end
      
endmodule						  
