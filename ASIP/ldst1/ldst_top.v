`include "define.v"

module ldst_top(
		clk,
		rst_b,
		ldst_o_sel,         // Store operand selection
        ldst_t_sel,         // Load/Store trigger selection
        //ldst_o_bas_sel,   // Base address operand selection
        ldst_typ_sel,       // trigger type, [0][1]--load, [2][3]--store
        ldst_o_dat,         // Store operand data
        //ldst_o_bas_dat,   // Base address operand data
        ldst_t_dat,         // Load/Store trigger data 
        
		ldst_r_dat         	// Load result data
);

input                   clk;
input                   rst_b;
input                   ldst_o_sel;
input                   ldst_t_sel;
//input                   ldst_o_bas_sel;
input   [4:0]           ldst_typ_sel;
input   [`DAT_W-1:0]    ldst_o_dat;
//input   [`DAT_W-1:0]    ldst_o_bas_dat;
input   [`DAT_W-1:0]   ldst_t_dat;

output  [`DAT_W-1:0]    ldst_r_dat;

wire   [`DAT_W-1:0]    i_mem_dat;
wire                  dat_mem_rw;
wire                  dat_mem_en_b;
wire  [`D_ADDR_W-1:0] dat_mem_addr;   
wire  [`DAT_W-1:0]    o_mem_dat;



ldst Uldst(
	.clk(clk),
	.rst_b(rst_b),
	.ldst_o_sel(ldst_o_sel),
	.ldst_t_sel(ldst_t_sel),
	.ldst_o_bas_sel(1'b0),
	.ldst_typ_sel(ldst_typ_sel),
	.i_mem_dat(i_mem_dat),
	.ldst_o_dat(ldst_o_dat),
    .ldst_t_dat(ldst_t_dat),
	.ldst_o_bas_dat('b0),
    
	
    .ldst_r_dat(ldst_r_dat),
	.dat_mem_rw(dat_mem_rw),
	.dat_mem_en_b(dat_mem_en_b),
	.dat_mem_addr(dat_mem_addr),
	.o_mem_dat(o_mem_dat)
	);
	
single_ram Usingle_ram(
	.addr(dat_mem_addr),
    .clk(clk),
    .din(o_mem_dat),
    .dout(i_mem_dat), 
    .en(dat_mem_en_b),
    .we(dat_mem_rw)	
	);
//--------
endmodule