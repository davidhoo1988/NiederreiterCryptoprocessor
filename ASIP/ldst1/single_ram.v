//===============================================================================
//                   Single RAM
//  ----------------------------------------------------------------------------
//  File Name            : single_ram.v
//  File Revision        : 1.0
//  Date                 : 2010/04/26
//  Author               : tanxingliang
//  Email                : tanxingliang@tju.edu.cn
//  ----------------------------------------------------------------------------
//  Description      : Behavior moudle of Xilinx single port Sram
//   Function         :            en -- 0 effective, we-- 1 read and 0 write
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================

module single_ram(
        	addr,
        	clk,
        	din,
        	dout,
        	en,
        	we
            );

// -----------------------------------------------------------------------------
// Parameter Declarations
// -----------------------------------------------------------------------------    
    parameter 
              AddressWidth  = 6,
              DataWidth     = 32,
              Deapth        = 128;

// -----------------------------------------------------------------------------
// Ports Declaration
// -----------------------------------------------------------------------------
input   [AddressWidth-1: 0] addr;
input                       clk;
input   [DataWidth-1: 0]    din;
output  [DataWidth-1: 0]    dout;
input                       en;
input                       we;

reg     [DataWidth-1:0]     mem     [0:Deapth-1];

reg     [DataWidth-1: 0]    dout;

// -----------------------------------------------------------------------------
// Logic control
// -----------------------------------------------------------------------------
always @(posedge clk)
 if(en==0)
  begin
    if(we==0)
        mem[addr] <= din;
    else
        dout   <= mem[addr];
  end
  

// -----------------------------------------------------------------------------
endmodule
//===============================================================================