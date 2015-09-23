`include "define.v"
`include "timescale.v"
`define    CLK_PERIOD      10

module gprf_tb();
	reg clk;
    reg rst_b;
    reg bus1_r0_t_sel, bus1_r0_r_sel;
	reg bus1_r1_t_sel, bus1_r1_r_sel;
	reg bus1_r2_t_sel, bus1_r2_r_sel;
	reg bus1_r3_t_sel, bus1_r3_r_sel;
	reg bus1_r4_t_sel, bus1_r4_r_sel;
	reg bus1_r5_t_sel, bus1_r5_r_sel;
	reg bus1_r6_t_sel, bus1_r6_r_sel;
	reg bus1_r7_t_sel, bus1_r7_r_sel;
	reg bus1_r8_t_sel, bus1_r8_r_sel;
	reg bus1_r9_t_sel, bus1_r9_r_sel;
	reg bus1_r10_t_sel, bus1_r10_r_sel;
	reg bus1_r11_t_sel, bus1_r11_r_sel;
	reg bus1_r12_t_sel, bus1_r12_r_sel;
	reg bus1_r13_t_sel, bus1_r13_r_sel;
	reg bus1_r14_t_sel, bus1_r14_r_sel;
	reg bus1_r15_t_sel, bus1_r15_r_sel;
	reg bus1_r16_t_sel, bus1_r16_r_sel;
	reg bus1_r17_t_sel, bus1_r17_r_sel;
	reg bus1_r18_t_sel, bus1_r18_r_sel;
	reg bus1_r19_t_sel, bus1_r19_r_sel;
	reg [`DAT_W-1:0] bus1_dat;
	
	wire [`DAT_W-1:0] bus1_gprf_r_dat;
	
gprf uut(
	.clk(clk),
	.rst_b(rst_b),	
	.bus1_r0_t_sel(bus1_r0_t_sel),
	.bus1_r0_r_sel(bus1_r0_r_sel),
	.bus1_r1_t_sel(bus1_r1_t_sel),
	.bus1_r1_r_sel(bus1_r1_r_sel),
	.bus1_r2_t_sel(bus1_r2_t_sel),
	.bus1_r2_r_sel(bus1_r2_r_sel),
	.bus1_r3_t_sel(bus1_r3_t_sel),
	.bus1_r3_r_sel(bus1_r3_r_sel),
	.bus1_r4_t_sel(bus1_r4_t_sel),
	.bus1_r4_r_sel(bus1_r4_r_sel),
	.bus1_r5_t_sel(bus1_r5_t_sel),
	.bus1_r5_r_sel(bus1_r5_r_sel),
	.bus1_r6_t_sel(bus1_r6_t_sel),
	.bus1_r6_r_sel(bus1_r6_r_sel),
	.bus1_r7_t_sel(bus1_r7_t_sel),
	.bus1_r7_r_sel(bus1_r7_r_sel),
	.bus1_r8_t_sel(bus1_r8_t_sel),
	.bus1_r8_r_sel(bus1_r8_r_sel),
	.bus1_r9_t_sel(bus1_r9_t_sel),
	.bus1_r9_r_sel(bus1_r9_r_sel),
	.bus1_r10_t_sel(bus1_r10_t_sel),
	.bus1_r10_r_sel(bus1_r10_r_sel),
	.bus1_r11_t_sel(bus1_r11_t_sel),
	.bus1_r11_r_sel(bus1_r11_r_sel),
	.bus1_r12_t_sel(bus1_r12_t_sel),
	.bus1_r12_r_sel(bus1_r12_r_sel),
	.bus1_r13_t_sel(bus1_r13_t_sel),
	.bus1_r13_r_sel(bus1_r13_r_sel),
	.bus1_r14_t_sel(bus1_r14_t_sel),
	.bus1_r14_r_sel(bus1_r14_r_sel),
	.bus1_r15_t_sel(bus1_r15_t_sel),
	.bus1_r15_r_sel(bus1_r15_r_sel),
	.bus1_r16_t_sel(bus1_r16_t_sel),
	.bus1_r16_r_sel(bus1_r16_r_sel),
	.bus1_r17_t_sel(bus1_r17_t_sel),
	.bus1_r17_r_sel(bus1_r17_r_sel),
	.bus1_r18_t_sel(bus1_r18_t_sel),
	.bus1_r18_r_sel(bus1_r18_r_sel),
	.bus1_r19_t_sel(bus1_r19_t_sel),
	.bus1_r19_r_sel(bus1_r19_r_sel),
	.bus1_dat(bus1_dat),

	.bus1_gprf_r_dat(bus1_gprf_r_dat)
);	               


	initial begin
		// Initialize Inputs
		clk = 0;
		rst_b = 0;
		bus1_r0_t_sel=0; bus1_r0_r_sel=0;
		bus1_r1_t_sel=0; bus1_r1_r_sel=0;
		bus1_r2_t_sel=0; bus1_r2_r_sel=0;
		bus1_r3_t_sel=0; bus1_r3_r_sel=0;
		bus1_r4_t_sel=0; bus1_r4_r_sel=0;
		bus1_r5_t_sel=0; bus1_r5_r_sel=0;
		bus1_r6_t_sel=0; bus1_r6_r_sel=0;
		bus1_r7_t_sel=0; bus1_r7_r_sel=0;
		bus1_r8_t_sel=0; bus1_r8_r_sel=0;
		bus1_r9_t_sel=0; bus1_r9_r_sel=0;
		bus1_r10_t_sel=0; bus1_r10_r_sel=0;
		bus1_r11_t_sel=0; bus1_r11_r_sel=0;
		bus1_r12_t_sel=0; bus1_r12_r_sel=0;
		bus1_r13_t_sel=0; bus1_r13_r_sel=0;
		bus1_r14_t_sel=0; bus1_r14_r_sel=0;
		bus1_r15_t_sel=0; bus1_r15_r_sel=0;
		bus1_r16_t_sel=0; bus1_r16_r_sel=0;
		bus1_r17_t_sel=0; bus1_r17_r_sel=0;
		bus1_r18_t_sel=0; bus1_r18_r_sel=0;
		bus1_r19_t_sel=0; bus1_r19_r_sel=0;
		bus1_dat=`DAT_W'b0;
		
		
    

		// Wait 100 ns for global reset to finish
		#(10*`CLK_PERIOD) rst_b = 1'b1;
		
		//store input data to r1
		#(`CLK_PERIOD)	  bus1_r0_t_sel = 1'b1;
						  bus1_r0_r_sel = 1'b0;
						  bus1_dat = `DAT_W'd1;	
		//output r1		  
		#(`CLK_PERIOD)	  bus1_r0_t_sel = 1'b1;
						  bus1_r0_r_sel = 1'b0;
						  bus1_dat = `DAT_W'd2;
		//store input data to r19
		#(2*`CLK_PERIOD)  bus1_r0_t_sel = 1'b0;
						  bus1_r19_t_sel = 1'b1;
						  bus1_r19_r_sel = 1'b0;
						  bus1_dat = `DAT_W'd3;
		// disable all
		#(`CLK_PERIOD)	  bus1_r0_t_sel = 1'b0;
						  bus1_r0_r_sel = 1'b1;
						  bus1_r19_t_sel = 1'b0;
						  bus1_r19_r_sel = 1'b1;

	end
	
	initial begin
	
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
	end
      
endmodule


    