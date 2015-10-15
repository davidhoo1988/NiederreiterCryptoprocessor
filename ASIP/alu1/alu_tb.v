`timescale 1ns / 1ns
`define    CLK_PERIOD      10
`define    DAT_W           144
`define 	LDAT_W 			145

module alu_tb();

reg clk;
reg rst_b;
reg alu_o_sel;
reg alu_t_sel;
reg alu_mod_sel;
reg [0:`DAT_W] 	alu_o_dat;
reg [0:`DAT_W-1] alu_t_dat;
reg [0:`DAT_W] 	alu_mod_dat;
reg [3:0] alu_typ_sel;
wire [0:`DAT_W-1] alu_r_dat1;
wire [0:`DAT_W-1] alu_r_dat2;
wire 				compute_done;   

ALU uut(
	.clk			(clk), 
	.rst_b			(rst_b),
	.alu_typ_sel	(alu_typ_sel),
	.alu_o_sel		(alu_o_sel),
	.alu_t_sel		(alu_t_sel),
	.alu_mod_sel	(alu_mod_sel),
	.alu_o_dat		(alu_o_dat),
	.alu_t_dat		(alu_t_dat),
	.alu_mod_dat	(alu_mod_dat[0:`LDAT_W-1]),
	.alu_r_dat1		(alu_r_dat1),
	.alu_r_dat2		(alu_r_dat2),
	.compute_done	(compute_done)
);
	
initial begin
	//Initialize Inputs
	clk = 0;

	#(`CLK_PERIOD/2) 
	clk = 1;
	rst_b = 0;
	alu_o_sel = 0;
	alu_t_sel = 0;
	alu_mod_sel = 0;
	alu_o_dat = 0;
	alu_t_dat = 0;
	alu_typ_sel = 0;


	
	#(5*`CLK_PERIOD)		rst_b 		= 1'b1;
	
	#(`CLK_PERIOD)			alu_typ_sel = 4'bxxxx;
	 
	//test addition	
	#(3*`CLK_PERIOD)		alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_o_dat 	= 16'hfff1;
							alu_t_dat 	= 16'h0f0f;
							alu_typ_sel = 4'b0001;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;

	//test inv
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_o_dat 	= 145'b1111000011110000011010100001000001101010000100000110101000010000011010100001000001101010000100000110101000010000011010100001000001101010000100000;
							alu_t_dat 	= 16'b0;
							alu_typ_sel = 4'b0110;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;						

	#(25*`CLK_PERIOD)						
	//test split
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_o_dat 	= 145'b0010111101111000000010010011101011001110100110000111100100010100001000000110101000000011010111001001110011111110101000011100010001000111010001100;
							alu_t_dat 	= 16'b0;
							alu_typ_sel = 4'b0010;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;

	//test deg
	#(20*`CLK_PERIOD)		alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_o_dat 	= 145'b0;
							alu_t_dat 	= 16'b0;
							alu_typ_sel = 4'b0111;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;						
 
 	//test shift
 	#(20*`CLK_PERIOD) 		alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_mod_sel = 1'b1;
							alu_o_dat 	= 145'b1001111110110110100111010001100010111100110000111000001110001110001001100000000000101010100010010100000110101001011011001110111001000110100101010;
							alu_t_dat 	= 144'b011010100001000000111010011001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
							alu_mod_dat = 145'b0110101011011011011100111100101011001110101111010001111111111110111110100101001111001010111011001011000010111101010111011010101101001100001110111;							
							alu_typ_sel = 4'b1000;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;

	//test eval
	#(20*`CLK_PERIOD)		alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_mod_sel = 1'b1;
							alu_o_dat 	= 145'b1010111001101110000101011000100010000111110101011101000110010000010011000011010100100011111000101000110111010010110011110011110001000000100110101; //sigma polynomial
							alu_t_dat 	= 144'b0; //gf element, not used
							alu_mod_dat = 145'b0110101011011011011100111100101011001110101111010001111111111110111110100101001111001010111011001011000010111101010111011010101101001100001110111;							
							alu_typ_sel = 4'b1001;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;
						
	//test multiplication
	#(100*`CLK_PERIOD)		alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_mod_sel = 1'b1;
							alu_o_dat 	= 145'b1001111110110110100111010001100010111100110000111000001110001110001001100000000000101010100010010100000110101001000000000000000000000000000000000;
							alu_t_dat 	= 144'b011010100001000001101010000100000110101000010000011010100001000001101010000100000110101000010000011010100001000001101010000100000110101000010000;
							//alu_t_dat = 144'b0;
							alu_mod_dat = 145'b0110101011011011011100111100101011001110101111010001111111111110111110100101001111001010111011001011000010111101010111011010101101001100001110111;							
							alu_typ_sel = 4'b0011;
	#(`CLK_PERIOD)			alu_o_sel 	= 1'b0;
							alu_t_sel 	= 1'b0;										
	//test division
	#(120*`CLK_PERIOD)		alu_o_sel = 1'b1;
							alu_t_sel = 1'b1;
							alu_o_dat = 145'b1001111110110110100111010001100010111100110000111000001110001110001001100000000000101010100010010100000110101001000000000000000000000000000000001;
							alu_t_dat = 144'b011010100001000001101010000100000110101000010000011010100001000001101010000100000110101000010000011010100001000001101010000100000110101000010000;
							alu_typ_sel = 4'b0101;
	#(2*`CLK_PERIOD)		alu_o_sel = 1'b0;
							alu_t_sel = 1'b0;

					
	//test multiplication						
	#(250*`CLK_PERIOD)		alu_o_sel 	= 1'b1;
							alu_t_sel 	= 1'b1;
							alu_mod_sel = 1'b1;
							alu_o_dat 	= 145'b1001111110110110100111010001100010111100110000111000001110001110001001100000000000101010100010010100000110101001000000000000000000000000000000000;
							alu_t_dat 	= 144'b011010100001000001101010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
							alu_mod_dat = 145'b0110101011011011011100111100101011001110101111010001111111111110111110100101001111001010111011001011000010111101010111011010101101001100001110111;							
							alu_typ_sel = 4'b0011;
	#(2*`CLK_PERIOD)		alu_o_sel = 1'b0;
							alu_t_sel = 1'b0;
					
	//test division
	#(120*`CLK_PERIOD)		alu_o_sel = 1'b1;
							alu_t_sel = 1'b1;
							alu_o_dat = 145'b1001111110110110100111010001100010111100110000111000001110001110001001100000000000101010100010010100000110101001000000000000000000000000000000000;
							alu_t_dat = 144'b011010100001000001101010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
							alu_typ_sel = 4'b0101;
	#(2*`CLK_PERIOD)		alu_o_sel = 1'b0;
							alu_t_sel = 1'b0;
	
end

initial begin
	forever
		#(`CLK_PERIOD/2) clk = ~clk;
end

endmodule
