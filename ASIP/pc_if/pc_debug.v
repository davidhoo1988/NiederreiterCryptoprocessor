//===============================================================================
//                  Tcore's PC Debug module
//  ----------------------------------------------------------------------------
//  File Name           : pc_debug.v
//  File Revision       : 2.0
//  Author              : tanxingliang
//  Email               :tanxingliang@tju.edu.cn
//  History:            
//                      2008        Rev1.0  yaoyongbin
//                      2009.07   Rev2.0 tanxingliang  
//  ----------------------------------------------------------------------------
//  Description      : This module is a part of ifetch unit, which include
//                     PC Initial and PC Timer. 
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================
// synthesis translate_off
`include    "timescale.v"
// synthesis translate_on
`include    "define.v"

module   pc_debug (
                clk,             // system clock
                reset_b,         // asynchronous reset
                mv_PC,           // Programme Counter
                pc_init_addr,    // PC init address
                pc_timer,        // PC control
                ext_pc_reg_sel,  // From Tcore's external world
                lock_rq,         // Globe lock signal
                timer_done,      // To control register
                pc_reg_dat       // To Tcore's external
               );  
                

 input                      clk;
 input                      reset_b;
 input  [`PC_W-1:0]         mv_PC;
 input  [`PC_W-1:0]         pc_init_addr;
 input  [1:0]               pc_timer;
 input                      ext_pc_reg_sel;
 input                      lock_rq;
 output                     timer_done;
 output [`PC_W-1:0]         pc_reg_dat;
    
 //----------------------------------------------------------
// For External read Tcore's PC
//----------------------------------------------------------
wire  [`PC_W-1:0]           pc_reg_dat;
assign  pc_reg_dat = ext_pc_reg_sel? mv_PC : 11'b0;  

//----------------------------------------------------------
// If pc_timer is enable, put the pc_init_addr to
// Timer register
//----------------------------------------------------------
reg [`PC_W-1:0]        timer_reg;
always@(posedge clk or negedge reset_b)
if(!reset_b)
    timer_reg <= `PC_W'b0;
else if(pc_timer == 2'b11)          // Initial the pc_timer
    timer_reg <= pc_init_addr;
else if(pc_timer == 2'b00)          // Clear the pc timer mode
    timer_reg <= {`PC_W{1'b1}};   // PC can't reach this value, because it's pc's max value
else
    timer_reg <= timer_reg;         // Hold the timer's value
   
//----------------------------------------------------------   
// When PC reach the wanted value, 
// assert timer_done signal
//----------------------------------------------------------
reg    timer_done;
always@(pc_timer or lock_rq or mv_PC or timer_reg)
begin
    if((pc_timer==2'b10) && (lock_rq==1'b0))   // trigger the pc_timer
        begin
            if(mv_PC == timer_reg)
                timer_done = 1'b1;
            else
                timer_done = 1'b0;
        end
    else
        timer_done = 1'b0;
end
    

//----------------------------------------------------
endmodule

//=============================END==============================================
