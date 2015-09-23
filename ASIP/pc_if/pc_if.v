//===============================================================================
//                  Tcore's instruction fetch unit
//  ----------------------------------------------------------------------------
//  File Name            : pc_if.v
//  File Revision        : 2.0
//  Author               : tanxingliang
//  Email                 :tanxingliang@tju.edu.cn
//  History:            
//                              2008      Rev1.0  yaoyongbin
//                              2009.07   Rev2.0 tanxingliang  
//  ----------------------------------------------------------------------------
//  Description      : This module is a part of ifetch unit, which include
//                          PC FSM and instruction fetch from ins_sram. If
//                          there is a jump, flush the followed two instructions
//                          behind the jump instruction.
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================
// synthesis translate_on
`include    "../include/define.v"

module   pc_if (
                clk,            
                reset_b,
				t_cs,
                
				lock_rq,        
                pc_init_en,     
                pc_init_addr,   
                
                rpt_again,      
                rpt_start_addr,         
                jmp_pc_sel,     
                jmp_imm_data,   
				ins_mem_i,  
				
				//output
                mv_PC,          
                pc_en_b,        
                halt,  
				mv_ins_reg
               );

 input                      clk;
 input                      reset_b;
 input						t_cs;
 input                      lock_rq;
 input                      pc_init_en;
 input  [`IMEMADDRW-1:0]    pc_init_addr;
 input                      rpt_again;
 input  [`IMEMADDRW-1:0]    rpt_start_addr;
 input                      jmp_pc_sel;
 input  [`DST_W-1:0]        jmp_imm_data;
 input  [`INS_W-1:0]     	ins_mem_i;
 
 output [`IMEMADDRW-1:0]    mv_PC;
 output                     pc_en_b;
 output                     halt;
 output [`INS_W-1:0]     	mv_ins_reg;
 

 wire                       clk;
 wire                       reset_b;
 wire 						t_cs;
 wire                       lock_rq;
 wire                       pc_init_en;
 wire   [`IMEMADDRW-1:0]    pc_init_addr;
 wire                       rpt_again;
 wire   [`IMEMADDRW-1:0]    rpt_start_addr;
 wire                       jmp_pc_sel;
 wire   [`DST_W-1:0]        jmp_imm_data;
 reg    [`IMEMADDRW-1:0]    mv_PC;
 wire                       pc_en_b;
 wire                       halt;

 wire  [`INS_W-1:0]     ins_mem_i;
 reg   [`INS_W-1:0]     mv_ins_reg;
 
 wire  [`INS_W-1:0]     mv_ins_dat;

//----------------------------------------------------------
// get jump address
//----------------------------------------------------------
wire  [`DST_W-1:0]    jmp_addr;
assign  jmp_addr    = jmp_pc_sel ? jmp_imm_data : `DST_W'b0;

//----------------------------------------------------------
// Output global halt signal, lock the whole pipeline
//----------------------------------------------------------
assign  halt = (ins_mem_i==`ALLNOP)? 1:0;

//----------------------------------------------------------
// To tcore's ins_sram wrapper
//----------------------------------------------------------
assign  pc_en_b = 1'b0;

//----------------------------------------------------------
//   PC FSM
//----------------------------------------------------------
always@(posedge clk or negedge reset_b)
begin
    if(!reset_b)
        mv_PC <= `IMEMADDRW'b0;
	else if(!t_cs)
		mv_PC <= mv_PC;
    else if(pc_init_en == 1'b1) //Start counting
        mv_PC <= pc_init_addr;
    else if(jmp_pc_sel)         //jmp to addr
        mv_PC <= jmp_addr;
    else if(rpt_again)          //???
        mv_PC <= rpt_start_addr;
	else if(lock_rq == 1'b1)    //preserve addr
        mv_PC <= mv_PC;
	else
        mv_PC <= mv_PC + 1;   //Execute sequentially
end 

//----------------------------------------------------------
// If locked, we have to tune the delay from ins_ram
// In this case, the delay should be 4 clocks
//----------------------------------------------------------
reg    lock_rq_tmp1;
wire   lock_rq_sel;

always@(posedge clk or negedge reset_b)
begin
    if(!reset_b)
            lock_rq_tmp1 <= 1'b0;
    else
            lock_rq_tmp1 <= lock_rq;
end

assign lock_rq_sel =  lock_rq_tmp1;  

//----------------------------------------------------------
// Data from instruction memory
//----------------------------------------------------------
assign  mv_ins_dat  = (lock_rq_sel) ? `ALLNOP : ins_mem_i;

//----------------------------------------------------------
// Register the instruction
//----------------------------------------------------------
 //always @(mv_ins_dat)
    // mv_ins_reg = mv_ins_dat;
always @(posedge clk or negedge reset_b) 
begin  
	if(!reset_b)
		mv_ins_reg <= 0;
	else
		mv_ins_reg <= mv_ins_dat;
end
//----------------------------------------------------
endmodule

//=============================END==============================================
