//===============================================================================
//                   Single RAM
//  ----------------------------------------------------------------------------
//  File Name            : RA1SH.v
//  File Revision        : 1.0
//  Date                 : 2010/04/26
//  Author               : tanxingliang
//  Email                : tanxingliang@tju.edu.cn
//  ----------------------------------------------------------------------------
//  Description      : Behavior module of Xilinx single port Sram
//  Function         : CEN -- 0 effective, WEN-- 1 read and 0 write, OEN -- 0 output enabled
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University ConfidCENtial Proprietary
//===============================================================================

module RA1SH(
        	CLK,
          A,
        	D,
        	Q,
        	CEN,
        	WEN,
          OEN
            );

// -----------------------------------------------------------------------------
// Parameter Declarations
// -----------------------------------------------------------------------------    
    parameter 
              AddressWidth  = 17,
              DataWidth     = 144,
              Deapth        = 131072; //2^AddressWidth

// -----------------------------------------------------------------------------
// Ports Declaration
// -----------------------------------------------------------------------------
input   [AddressWidth-1: 0] A;
input                       CLK;
input   [DataWidth-1: 0]    D;
output  [DataWidth-1: 0]    Q;
input                       CEN;
input                       WEN;
input                       OEN;

reg     [DataWidth-1:0]     mem     [0:Deapth-1];

reg     [DataWidth-1: 0]    Q_tmp;

// -----------------------------------------------------------------------------
// Logic control
// -----------------------------------------------------------------------------
always @(posedge CLK)
 if(CEN==0)
  begin
    if(WEN==0)
        mem[A] <= D;
    else
        Q_tmp   <= mem[A];
  end
  
assign Q = (OEN==0)? Q_tmp : {DataWidth{1'b?}};

// -----------------------------------------------------------------------------
endmodule
//===============================================================================