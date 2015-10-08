//===============================================================================
//                   Processor TopModule
//  ----------------------------------------------------------------------------
//  File Name            : asip_top.v
//  File Revision        : 1.0
//  Date                 : 2014/11/07
//  Author               : David J.W. HU
//  Email                : davidhoo471494221@gmail.com
//  ----------------------------------------------------------------------------
//  Description      : This module include the ASIP top logic part, and
//                          the instruction memory and the data memory.
//  ----------------------------------------------------------------------------
//`define SYNTHESIS
`ifndef SYNTHESIS
`include    "../include/timescale.v"
`include    "../include/define.v"

`else
`include    "./include/timescale.v"
`include    "./include/define.v"
`endif

module asip_top(
	    clk,            // system clock
        reset_b,        // asynchronous reset
        t_cs,           // External access Tcore tcore select signal
		  
		out
		  
);

// -----------------------------------------------------------------------------
// Ports Declaration
// -----------------------------------------------------------------------------
input   					clk;
input   					reset_b;
input   					t_cs;

output [`MEM_W-1:0]	out;

// -----------------------------------------------------------------------------
// Signals Declaration
// -----------------------------------------------------------------------------
wire [`IMEMADDRW-1:0]	imem_addr;
wire 					imem_en_b;
wire [`INS_W-1:0]		imem_dat;

wire 					dmem1_rw;
wire 					dmem1_en_b;
wire [`DMEMCSW-1:0]     dmem1_cs;
wire [`SUBDMEMADDRW-1:0]dmem1_addr;
wire [`MEM_W-1:0]		dmem1_to_asip_dat;
wire [`MEM_W-1:0]		asip_to_dmem1_dat;

wire [`MEM_W-1:0]		imem_Q, dmem_Q;				
//----------------------------------------------------------
// Instance asip_syn  
// Tcore's top logic part, which is used for synthesis
//----------------------------------------------------------   
asip_syn   	asip_syn(
            	.clk				( clk			),                // system clock
                .reset_b           	( reset_b		),				  // asynchronous reset       
                .t_cs				( t_cs			),                // Tcore chip select
                
				//Interface with ins memory
				.ins_mem_dat		( imem_dat		),
				.ins_mem_en_b		( imem_en_b		),		
				.ins_mem_addr		( imem_addr     ),
				
				// Interface with data memory1 					
                .dat_mem1_rw		( dmem1_rw		),        // dat memory1 read or write 1--read, 0 -- write
                .dat_mem1_en_b     	( dmem1_en_b	),		// dat memory1 chip enable
                .dat_mem1_cs        ( dmem1_cs      ), 
                .dat_mem1_addr		( dmem1_addr	),      // to dat memory1 address 
				.mem1_to_wrp_dat	( dmem1_to_asip_dat),    // To processor 
                .wrp_to_mem1_dat    ( asip_to_dmem1_dat)	// To dat_ram1 
);  

//----------------------------------------------------------
// Instance ins_sram: Instruction memory
//---------------------------------------------------------- 
`ifndef SYNTHESIS
RA1SH   ins_sram(
                .CLK 				( clk				),
                .A   				( {1'b0,imem_addr}	),
                .D   				( `MEM_W'b0			),  
                .WEN 				( 1'b1				),
                .CEN 				( imem_en_b			),
                .Q   				( imem_Q			),
                .OEN 				( 1'b0				)
);

`else
ins_sram 	ins_sram(
					.clka					(clk),
					.wea					(1'b0),//read
					.addra				(imem_addr[6:0]),
					.dina					(`MEM_W'b0),
					.douta				(imem_Q)
);
`endif
assign imem_dat = imem_Q[`INS_W-1:0];

//----------------------------------------------------------
// Instance dat_sram: Data memory
//---------------------------------------------------------- 
dmem_array dat_sram(
                    .clk        ( clk                   ), 
                    .dmem_rw    ( dmem1_rw              ),
                    .dmem_cs    ( dmem1_cs              ),
                    .dmem_addr  ( dmem1_addr            ),
                    .data_in    ( asip_to_dmem1_dat     ),

                    .data_out   ( dmem_Q                )
);

assign dmem1_to_asip_dat = dmem_Q[`MEM_W-1:0];



assign out = asip_to_dmem1_dat;
endmodule