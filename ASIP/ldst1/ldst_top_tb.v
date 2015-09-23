`include "define.v"
`include "timescale.v"
`define    CLK_PERIOD      10

module ldst_top_tb();
	reg clk;
    reg rst_b;
	reg ldst_o_sel;         // Store operand selection
    reg ldst_t_sel;         // Load/Store trigger selection
    //ldst_o_bas_sel,     // Base address operand selection
    
    reg [4:0] ldst_typ_sel;       // trigger type, [0][1]--load, [2][3]--store
    
    reg[`DAT_W-1:0] ldst_o_dat;         // Store operand data
      
    reg[`DAT_W-1:0] ldst_t_dat;         // Load/Store trigger data 
    wire[`DAT_W-1:0] ldst_r_dat;         // Load result data
	
ldst_top uut(
	.clk(clk),
    .rst_b(rst_b), 
    .ldst_o_sel(ldst_o_sel), 
    .ldst_t_sel(ldst_t_sel), 
    .ldst_typ_sel(ldst_typ_sel),
    .ldst_o_dat(ldst_o_dat), 
    .ldst_t_dat(ldst_t_dat), 

    .ldst_r_dat(ldst_r_dat) 
);	               


	initial begin
		// Initialize Inputs
		clk = 0;
		rst_b = 0;
		ldst_o_sel= 0;
		ldst_t_sel= 0;
		 
		ldst_typ_sel= 0;
		 
		ldst_o_dat=0;
		ldst_t_dat=0;
		//ldst_r_dat=0;
		 
		$readmemh("./mem.txt",uut.Usingle_ram.mem);
    

		// Wait 100 ns for global reset to finish
		#(10*`CLK_PERIOD) rst_b = 1'b1;
		
		//load directly
		#(`CLK_PERIOD)	  ldst_t_sel = 1'b1;
						  ldst_typ_sel = 5'b00001;
						  ldst_t_dat = 7'b0;
		//reset				  
		#(`CLK_PERIOD)	  ldst_t_sel = 1'b0;
						  ldst_typ_sel = 5'b00000;
						  ldst_t_dat = 7'b0;
		//Store directly
		#(2*`CLK_PERIOD)  ldst_t_sel = 1'b1;
		                  ldst_o_sel = 1'b1;
						  ldst_typ_sel = 5'b00010;
						  ldst_t_dat = 7'b0000011;
						  ldst_o_dat = 32'h0f0f0f0f;
		//Store directly
		#(`CLK_PERIOD)    ldst_t_sel = 1'b1;
		                  ldst_o_sel = 1'b1;
						  ldst_typ_sel = 5'b00010;
						  ldst_t_dat = 7'b0000100;
						  ldst_o_dat = 32'h0f0f0f0e;
		//reset
		#(`CLK_PERIOD)	  ldst_o_sel = 1'b0;
		                  ldst_t_sel = 1'b0;
						  ldst_typ_sel = 5'b00000;
						  ldst_t_dat = 7'b0;
		//Load with burst
		#(`CLK_PERIOD)	  ldst_t_sel = 1'b1;
						  ldst_typ_sel = 5'b00100;
						  ldst_t_dat = 7'b0000001;
		// keep bursting
		#(`CLK_PERIOD)	ldst_t_sel = 1'b1;  
						ldst_typ_sel = 1'b0;				  

	end
	
	initial begin
	
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
	end
      
endmodule


    