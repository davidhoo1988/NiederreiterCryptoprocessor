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

//----------------------------------------------------------
// SetUp ins_decoder
//---------------------------------------------------------- 
 `ifndef DEFINE
 `define DEFINE
 
 `define 	OPR_W			5
 `define    SRC_W           19
 `define    DST_W           19
 `define 	INS_W           43              //`OPR_W + `SRC_W + `DST_W
      
 `define  	IMM_DAT_W       16              // Immediate Date Width == SRC_W - 3
 
 `define	SRC_GPRF_W		16				//SRC_W - 3
 `define	DST_GPRF_W		16				//DST_W - 3
 
 `define 	DLY_W			8				//Cycle Delay Between SRC and DST
//----------------------------------------------------------
// SetUp memory
//----------------------------------------------------------  
`define    DAT_W           	144              // Data Width
`define    MEM_W			144				// Ram Data Width
`define    IMEMADDRW		10				// Instruction Memory Address Width
`define    DMEMADDRW        17 				// Data Memory Address Width (smaller than DAT_W)

//----------------------------------------------------------
// SetUp Function Unit
//----------------------------------------------------------  
`define		ALU_TYP_W		4			//ALU Operation Type Width
`define 	LDAT_W			145         //mod data width
//----------------------------------------------------------
// SetUp SPRF
//----------------------------------------------------------  
`define		SPRF_TYP_W		2			//SPRF Operation Type Width
`define 	SPRF_DAT_W		144 		//SPRF Data Width
//----------------------------------------------------------
// SetUp Pseudo Random Number Generator
//----------------------------------------------------------  
`define		PRNG_DAT_W				25				//PRNG Data Width
`define		PRNG_TYP_W				2				//PRNG Operation Type Width

//----------------------------------------------------------
// Instruction Codes
//---------------------------------------------------------- 
 `define    ALLNOP          `INS_W'b0
 
 `endif
 
 
 
 
 
 
// =============================================================================
