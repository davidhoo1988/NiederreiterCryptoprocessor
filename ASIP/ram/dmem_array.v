//===============================================================================
//              dmemory array 
//  ----------------------------------------------------------------------------
//  File Name            : ./dmem_array.v
//  Author               : David J.W. HU	
//  Email                : davidhoo471494221@gmail.com
//  ----------------------------------------------------------------------------
//  Description      : This module include all block memory modules.
//`define SYNTHESIS
`ifndef SYNTHESIS
	`include    "../include/define.v"
`else
	`include 	"../include/define.v"
`endif
module dmem_array(
	input wire 						clk, 
	input wire 						dmem_rw,
	input wire [`DMEMCSW-1:0]		dmem_cs,
	input wire [`SUBDMEMADDRW-1:0]	dmem_addr,
	input wire [`MEM_W-1:0]			data_in,

	output reg [`MEM_W-1:0]			data_out

	);

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg dmem_rw_tmp1;
reg [`DMEMCSW-1:0] 		dmem_cs_tmp1;
reg [`SUBDMEMADDRW-1:0] dmem_addr_tmp1;

(* max_fanout = "18" *)
reg [`MEM_W-1:0] 		data_in_tmp1;

reg dmem0_rw, dmem1_rw, dmem2_rw, dmem3_rw, dmem4_rw, dmem5_rw, dmem6_rw, dmem7_rw,
	dmem8_rw, dmem9_rw, dmem10_rw, dmem11_rw, dmem12_rw, dmem13_rw, dmem14_rw, dmem15_rw,
	dmem16_rw, dmem17_rw,
	dmem18_rw, dmem19_rw, dmem20_rw, dmem21_rw, dmem22_rw, dmem23_rw, dmem24_rw, dmem25_rw,
	dmem26_rw, dmem27_rw, dmem28_rw, dmem29_rw, dmem30_rw, dmem31_rw, dmem32_rw, dmem33_rw,
	dmem34_rw, dmem35_rw;

reg dmem_rw_tmp2;
reg [`DMEMCSW-1:0] dmem_cs_tmp2;

wire [`MEM_W-1:0 ]	data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7,
					data_out8, data_out9, data_out10, data_out11, data_out12, data_out13, data_out14, data_out15,
					data_out16, data_out17,
					data_out18, data_out19, data_out20, data_out21, data_out22, data_out23, data_out24, data_out25,
					data_out26, data_out27, data_out28, data_out29, data_out30, data_out31, data_out32, data_out33,
					data_out34, data_out35; 


reg [`DMEMCSW-1:0] dmem_cs_tmp3;
reg [`MEM_W-1:0]  data_out1_reg, data_out2_reg, data_out3_reg, data_out4_reg, data_out5_reg;

`ifndef SYNTHESIS
RA1SH   dat_sram0(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1       	),  
                .WEN 				( dmem0_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out0					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram1(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem1_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out1					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram2(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem2_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out2					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram3(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem3_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out3					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram4(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem4_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out4					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram5(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem5_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out5					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram6(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem6_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out6					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram7(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem7_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out7					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram8(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem8_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out8					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram9(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem9_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out9					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram10(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem10_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out10				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram11(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem11_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out11				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram12(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem12_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out12				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram13(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem13_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out13				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram14(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem14_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out14				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram15(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem15_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out15				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram16(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem16_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out16				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram17(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem17_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out17				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram18(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1       	),  
                .WEN 				( dmem18_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out18					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram19(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem19_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out19					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram20(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem20_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out20					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram21(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem21_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out21					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram22(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem22_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out22					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram23(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem23_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out23					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram24(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem24_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out24					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram25(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem25_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out25					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram26(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem26_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out26					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram27(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem27_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out27					),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram28(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem28_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out28				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram29(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem29_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out29				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram30(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem30_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out30				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram31(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem31_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out31				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram32(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem32_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out32				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram33(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem33_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out33				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram34(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem34_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out34				),
                .OEN 				( 1'b0						)
);

RA1SH   dat_sram35(
                .CLK 				( clk						),
                .A   				( dmem_addr_tmp1			    ),
                .D   				( data_in_tmp1        	),  
                .WEN 				( dmem35_rw					),
                .CEN 				( 1'b0  				),
                .Q   				( data_out35				),
                .OEN 				( 1'b0						)
);

`else
dat_sram dat_sram0(
					.clka					(clk),
					.wea					(dmem0_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out0)
);
dat_sram dat_sram1(
					.clka					(clk),
					.wea					(dmem1_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out1)
);
dat_sram dat_sram2(
					.clka					(clk),
					.wea					(dmem2_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out2)
);
dat_sram dat_sram3(
					.clka					(clk),
					.wea					(dmem3_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out3)
);
dat_sram dat_sram4(
					.clka					(clk),
					.wea					(dmem4_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out4)
);
dat_sram dat_sram5(
					.clka					(clk),
					.wea					(dmem5_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out5)
);
dat_sram dat_sram6(
					.clka					(clk),
					.wea					(dmem6_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out6)
);
dat_sram dat_sram7(
					.clka					(clk),
					.wea					(dmem7_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out7)
);
dat_sram dat_sram8(
					.clka					(clk),
					.wea					(dmem8_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out8)
);
dat_sram dat_sram9(
					.clka					(clk),
					.wea					(dmem9_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out9)
);
dat_sram dat_sram10(
					.clka					(clk),
					.wea					(dmem10_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out10)
);
dat_sram dat_sram11(
					.clka					(clk),
					.wea					(dmem11_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out11)
);
dat_sram dat_sram12(
					.clka					(clk),
					.wea					(dmem12_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out12)
);
dat_sram dat_sram13(
					.clka					(clk),
					.wea					(dmem13_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out13)
);
dat_sram dat_sram14(
					.clka					(clk),
					.wea					(dmem14_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out14)
);
dat_sram dat_sram15(
					.clka					(clk),
					.wea					(dmem15_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out15)
);
dat_sram dat_sram16(
					.clka					(clk),
					.wea					(dmem16_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out16)
);
dat_sram dat_sram17(
					.clka					(clk),
					.wea					(dmem17_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out17)
);
dat_sram dat_sram18(
					.clka					(clk),
					.wea					(dmem18_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out18)
);
dat_sram dat_sram19(
					.clka					(clk),
					.wea					(dmem19_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out19)
);
dat_sram dat_sram20(
					.clka					(clk),
					.wea					(dmem20_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out20)
);
dat_sram dat_sram21(
					.clka					(clk),
					.wea					(dmem21_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out21)
);
dat_sram dat_sram22(
					.clka					(clk),
					.wea					(dmem22_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out22)
);
dat_sram dat_sram23(
					.clka					(clk),
					.wea					(dmem23_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out23)
);
dat_sram dat_sram24(
					.clka					(clk),
					.wea					(dmem24_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out24)
);
dat_sram dat_sram25(
					.clka					(clk),
					.wea					(dmem25_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out25)
);
dat_sram dat_sram26(
					.clka					(clk),
					.wea					(dmem26_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out26)
);
dat_sram dat_sram27(
					.clka					(clk),
					.wea					(dmem27_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out27)
);
dat_sram dat_sram28(
					.clka					(clk),
					.wea					(dmem28_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out28)
);
dat_sram dat_sram29(
					.clka					(clk),
					.wea					(dmem29_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out29)
);
dat_sram dat_sram30(
					.clka					(clk),
					.wea					(dmem30_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out30)
);
dat_sram dat_sram31(
					.clka					(clk),
					.wea					(dmem31_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out31)
);
dat_sram dat_sram32(
					.clka					(clk),
					.wea					(dmem32_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out32)
);
dat_sram dat_sram33(
					.clka					(clk),
					.wea					(dmem33_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out33)
);
dat_sram dat_sram34(
					.clka					(clk),
					.wea					(dmem34_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out34)
);
dat_sram dat_sram35(
					.clka					(clk),
					.wea					(dmem35_rw),
					.addra					(dmem_addr_tmp1),
					.dina					(data_in_tmp1),
					.douta					(data_out35)
);
`endif

//first stage pipeline
always @(posedge clk) begin
	dmem_rw_tmp1 <= dmem_rw;
end

always @(posedge clk) begin
	dmem_addr_tmp1 <= dmem_addr;
end


always @(posedge clk) begin
	dmem_cs_tmp1 <= dmem_cs;
end

always @(posedge clk) begin
	data_in_tmp1 <= data_in;
end

always@ (posedge clk) begin
	if (dmem_rw == 1'd1) begin
		{dmem35_rw,dmem34_rw,
		 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
		 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
		 dmem17_rw,dmem16_rw,
		 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
		 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= 36'd68719476735;	
	end 
	else begin
		case(dmem_cs)
			`DMEMCSW'd0: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd1;
			end
			`DMEMCSW'd1: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd2;
			end
			`DMEMCSW'd2: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd4;
			end
			`DMEMCSW'd3: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd8;
			end
			`DMEMCSW'd4: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd16;
			end
			`DMEMCSW'd5: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd32;
			end
			`DMEMCSW'd6: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw}<= ~36'd64;
			end
			`DMEMCSW'd7: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd128;
			end
			`DMEMCSW'd8: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd256;
			end
			`DMEMCSW'd9: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd512;
			end
			`DMEMCSW'd10: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd1024;
			end
			`DMEMCSW'd11: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd2048;
			end
			`DMEMCSW'd12: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw}<= ~36'd4096;
			end
			`DMEMCSW'd13: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd8192;
			end
			`DMEMCSW'd14: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd16384;
			end
			`DMEMCSW'd15: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd32768;
			end
			`DMEMCSW'd16: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd65536;
			end
			`DMEMCSW'd17: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd131072;
			end
			`DMEMCSW'd18: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw}<= ~36'd262144;
			end
			`DMEMCSW'd19: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd524288;
			end
			`DMEMCSW'd20: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd1048576;
			end
			`DMEMCSW'd21: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd2097152;
			end
			`DMEMCSW'd22: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd4194304;
			end
			`DMEMCSW'd23: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd8388608;
			end
			`DMEMCSW'd24: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd16777216;
			end
			`DMEMCSW'd25: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd33554432;
			end
			`DMEMCSW'd26: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd67108864;
			end
			`DMEMCSW'd27: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd134217728;
			end
			`DMEMCSW'd28: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd268435456;
			end
			`DMEMCSW'd29: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd536870912;
			end
			`DMEMCSW'd30: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd1073741824;
			end
			`DMEMCSW'd31: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd2147483648;
			end
			`DMEMCSW'd32: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd4294967296;
			end
			`DMEMCSW'd33: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd8589934592;
			end
			`DMEMCSW'd34: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd17179869184;
			end
			`DMEMCSW'd35: begin
				{dmem35_rw,dmem34_rw,
				 dmem33_rw,dmem32_rw,dmem31_rw,dmem30_rw,dmem29_rw,dmem28_rw,dmem27_rw, dmem26_rw,
				 dmem25_rw,dmem24_rw,dmem23_rw,dmem22_rw,dmem21_rw,dmem20_rw,dmem19_rw, dmem18_rw,
				 dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~36'd34359738368;	 
			end
			
		endcase
	end
end		

//second stage pipeline, write data into dram
always @(posedge clk) begin
	dmem_rw_tmp2 <= dmem_rw_tmp1;
end

always @(posedge clk) begin
	dmem_cs_tmp2 <= dmem_cs_tmp1;
end

//third stage pipeline
always @(posedge clk) begin
	dmem_cs_tmp3 <= dmem_cs_tmp2;
end

always @(posedge clk) begin
	case(dmem_cs_tmp2[`DMEMCSW-4:0])
		`DMEMCSW'd0: begin
			data_out1_reg <= data_out0;
			data_out2_reg <= data_out8;
			data_out3_reg <= data_out16;
			data_out4_reg <= data_out24;
			data_out5_reg <= data_out32;
		end
		`DMEMCSW'd1: begin
			data_out1_reg <= data_out1;
			data_out2_reg <= data_out9;
			data_out3_reg <= data_out17;
			data_out4_reg <= data_out25;
			data_out5_reg <= data_out33;
		end
		`DMEMCSW'd2: begin
			data_out1_reg <= data_out2;
			data_out2_reg <= data_out10;
			data_out3_reg <= data_out18;
			data_out4_reg <= data_out26;
			data_out5_reg <= data_out34;
		end
		`DMEMCSW'd3: begin
			data_out1_reg <= data_out3;
			data_out2_reg <= data_out11;
			data_out3_reg <= data_out19;
			data_out4_reg <= data_out27;
			data_out5_reg <= data_out35;
		end
		`DMEMCSW'd4: begin
			data_out1_reg <= data_out4;
			data_out2_reg <= data_out12;
			data_out3_reg <= data_out20;
			data_out4_reg <= data_out28;
			data_out5_reg <= 0;
		end
		`DMEMCSW'd5: begin
			data_out1_reg <= data_out5;
			data_out2_reg <= data_out13;
			data_out3_reg <= data_out21;
			data_out4_reg <= data_out29;
			data_out5_reg <= 0;
		end
		`DMEMCSW'd6: begin
			data_out1_reg <= data_out6;
			data_out2_reg <= data_out14;
			data_out3_reg <= data_out22;
			data_out4_reg <= data_out30;
			data_out5_reg <= 0;
		end
		`DMEMCSW'd7: begin
			data_out1_reg <= data_out7;
			data_out2_reg <= data_out15;
			data_out3_reg <= data_out23;
			data_out4_reg <= data_out31;
			data_out5_reg <= 0;
		end
	endcase
	
end

//fourth stage pipeline, read data out of dram
always @(posedge clk) begin
		case(dmem_cs_tmp3[`DMEMCSW-1:`DMEMCSW-3])
		3'd0: data_out <= data_out1_reg;
		3'd1: data_out <= data_out2_reg;
		3'd2: data_out <= data_out3_reg;
		3'd3: data_out <= data_out4_reg;
		3'd4: data_out <= data_out5_reg;
		default: data_out <= 0;
		endcase
end	
endmodule	
