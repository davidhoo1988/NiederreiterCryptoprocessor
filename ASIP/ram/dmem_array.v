//===============================================================================
//              dmemory array 
//  ----------------------------------------------------------------------------
//  File Name            : ./dmem_array.v
//  Author               : David J.W. HU	
//  Email                : davidhoo471494221@gmail.com
//  ----------------------------------------------------------------------------
//  Description      : This module include all block memory modules.
`define SYNTHESIS
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
reg [`MEM_W-1:0] 		data_in_tmp1;
reg dmem0_rw, dmem1_rw, dmem2_rw, dmem3_rw, dmem4_rw, dmem5_rw, dmem6_rw, dmem7_rw,
	dmem8_rw, dmem9_rw, dmem10_rw, dmem11_rw, dmem12_rw, dmem13_rw, dmem14_rw, dmem15_rw,
	dmem16_rw, dmem17_rw;

reg dmem_rw_tmp2;
reg [`DMEMCSW-1:0] dmem_cs_tmp2;

wire [`MEM_W-1:0 ]	data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7,
					data_out8, data_out9, data_out10, data_out11, data_out12, data_out13, data_out14, data_out15,
					data_out16, data_out17; 



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
		{dmem17_rw,dmem16_rw,
		 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
		 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= 18'd262143;	
	end 
	else begin
		case(dmem_cs)
			`DMEMCSW'd0: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd1;
			end
			`DMEMCSW'd1: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd2;
			end
			`DMEMCSW'd2: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd4;
			end
			`DMEMCSW'd3: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd8;
			end
			`DMEMCSW'd4: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd16;
			end
			`DMEMCSW'd5: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd32;
			end
			`DMEMCSW'd6: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd64;
			end
			`DMEMCSW'd7: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd128;
			end
			`DMEMCSW'd8: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd256;
			end
			`DMEMCSW'd9: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd512;
			end
			`DMEMCSW'd10: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd1024;
			end
			`DMEMCSW'd11: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd2048;
			end
			`DMEMCSW'd12: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd4096;
			end
			`DMEMCSW'd13: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd8192;
			end
			`DMEMCSW'd14: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd16384;
			end
			`DMEMCSW'd15: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd32768;
			end
			`DMEMCSW'd16: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd65536;
			end
			`DMEMCSW'd17: begin
				{dmem17_rw,dmem16_rw,
				 dmem15_rw,dmem14_rw,dmem13_rw,dmem12_rw,dmem11_rw,dmem10_rw,dmem9_rw, dmem8_rw,
				 dmem7_rw, dmem6_rw, dmem5_rw, dmem4_rw, dmem3_rw, dmem2_rw, dmem1_rw, dmem0_rw} <= ~18'd131072;
			end
			
		endcase
	end
end		

//second stage pipeline
always @(posedge clk) begin
	dmem_rw_tmp2 <= dmem_rw_tmp1;
end

always @(posedge clk) begin
	dmem_cs_tmp2 <= dmem_cs_tmp1;
end

//third stage pipeline
always @(posedge clk) begin
	if (dmem_rw_tmp2 == 1'd1) begin
		case(dmem_cs_tmp2)
			`DMEMCSW'd0: begin
				data_out <= data_out0;
			end
			`DMEMCSW'd1: begin
				data_out <= data_out1;
			end
			`DMEMCSW'd2: begin
				data_out <= data_out2;
			end
			`DMEMCSW'd3: begin
				data_out <= data_out3;
			end
			`DMEMCSW'd4: begin
				data_out <= data_out4;
			end
			`DMEMCSW'd5: begin
				data_out <= data_out5;
			end
			`DMEMCSW'd6: begin
				data_out <= data_out6;
			end
			`DMEMCSW'd7: begin
				data_out <= data_out7;
			end
			`DMEMCSW'd8: begin
				data_out <= data_out8;
			end
			`DMEMCSW'd9: begin
				data_out <= data_out9;
			end
			`DMEMCSW'd10: begin
				data_out <= data_out10;
			end
			`DMEMCSW'd11: begin
				data_out <= data_out11;
			end
			`DMEMCSW'd12: begin
				data_out <= data_out12;
			end
			`DMEMCSW'd13: begin
				data_out <= data_out13;
			end
			`DMEMCSW'd14: begin
				data_out <= data_out14;
			end
			`DMEMCSW'd15: begin
				data_out <= data_out15;
			end
			`DMEMCSW'd16: begin
				data_out <= data_out16;
			end
			`DMEMCSW'd17: begin
				data_out <= data_out17;
			end
		endcase
	end

	else begin

	end
end



endmodule	
