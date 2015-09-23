//===============================================================================
//              Parameters Define
//  ----------------------------------------------------------------------------
//  File Name            : ./define.v
//  File Revision        : 2.0
//  Author               : TTA Group
//  Data                 : 2009/09
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================

 `define    INS_W           136
 `define    SRC_W           9
 `define    DST_W           7
 `define    D_ADDR_W        6
       
 `define    DAT_W           32              // Data Width       
 `define    EXTADDRW        16              // External access address width
 `define    IMEMDATW        136              // Instruction memory Width = INS_W * BUS_NUM
 `define    PC_W            11              // PC width == Instruction memory address width
 `define    DMEMADDRW       10              // Data memory address width
 `define    EXT_INS_ADDR    14              // External download Tcore ins address to ins mem. Used in ins_sram_wrapper.v and addr_decode.v
 `define    CNTR_REG_W      8              // Control_reg Width, = 3 (reserved) +5(Interrupt Flat + EXT_PC_VALUE + PC_INI_EN + PC_TIMER + LOCK)
 `define    PC_INIT_W       8
 
//----------------------------------------------------------
// Instruction Codes
//---------------------------------------------------------- 
 `define    ALLNOP          `IMEMDATW'b0
 
 
 
 
 
 
 
// =============================================================================
