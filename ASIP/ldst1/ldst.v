//===============================================================================
//              Tcore's load/sore FU
//  ----------------------------------------------------------------------------
//  Author               : sujiao
//  Date                 : 2010.11.01
//  Email                : sujiao@tju.edu.cn
//  Function             : Load_Store with directly or base or burst accessing memory.
// --------------
//  Trigger type :
//                   [0]-----------load directly
//                   [1]-----------store directly
//		 [2]-----------load with burst 33
//		 [3]-----------load with bias and burst 33
//		 [4]-----------store with bias               
//  ----------------------------------------------------------------------------
// Copyright (c) 2009,Tianjin University.
//               No.92 Weijin Road , Nankai District, Tianjin, 300072, China
// Tianjin University Confidential Proprietary
//===============================================================================

`include "define.v"

module  ldst(
        clk,                // System clock
        rst_b,              // System reset, asynchronous reset, 0 -- reset
        ldst_o_sel,         // Store operand selection
        ldst_t_sel,         // Load/Store trigger selection
        ldst_o_bas_sel,     // Base address operand selection
        ldst_typ_sel,       // trigger type
        ldst_o_dat,         // Store operand data
        ldst_o_bas_dat,     // Base address operand data
        ldst_t_dat,         // Load/Store trigger data 
        ldst_r_dat,         // Load result data
        
        i_mem_dat,          // Input data from SRAM directly
        dat_mem_rw,         // Write or read SRAM, 1 - -read, 0 -- write
        dat_mem_en_b,       // Access SRAM enable, 1--enable
        dat_mem_addr,       // Address to SRAM
        o_mem_dat           // Output data to SRAM
      );
 
parameter LDST_TYP_W = 5; 
//----------------------------------------------------------
// Ports Declaration
//----------------------------------------------------------         
input                   clk;
input                   rst_b;
input                   ldst_o_sel;
input                   ldst_t_sel;
input                   ldst_o_bas_sel;
input   [LDST_TYP_W-1:0]           ldst_typ_sel;
input   [`DAT_W-1:0]    ldst_o_dat;
input   [`DAT_W-1:0]    ldst_o_bas_dat;
input   [`DAT_W-1:0]    ldst_t_dat;
output  [`DAT_W-1:0]    ldst_r_dat;
input   [`DAT_W-1:0]    i_mem_dat;
output                  dat_mem_rw;
output                  dat_mem_en_b;
output  [`D_ADDR_W-1:0] dat_mem_addr;   
output  [`DAT_W-1:0]    o_mem_dat;
        
        
reg     [`DAT_W-1:0]    ldst_r_dat;  
reg                     dat_mem_rw;
reg                     dat_mem_en_b;
reg     [`D_ADDR_W-1:0] dat_mem_addr;   
reg     [`DAT_W-1:0]    o_mem_dat;
  
//----------------------------------------------------------
// Store the operand and trigger data
//----------------------------------------------------------         
reg     [`D_ADDR_W-1:0]     trg_reg;
reg     [`DAT_W-1:0]        st_o_reg;
reg     [`D_ADDR_W-1:0]     ldst_o_bias_reg;

always@(posedge clk or negedge rst_b)
if(!rst_b)trg_reg <= 0;
else if(ldst_t_sel)trg_reg <= ldst_t_dat[`D_ADDR_W-1:0];

always@(posedge clk or negedge rst_b)
if(!rst_b)st_o_reg <= 0;
else if(ldst_o_sel)st_o_reg <= ldst_o_dat;


always@(posedge clk or negedge rst_b)
if(!rst_b)ldst_o_bias_reg <= 0;
else if(ldst_o_bas_sel)ldst_o_bias_reg <= ldst_o_bas_dat[`D_ADDR_W-1:0];

//----------------------------------------------------------  
// Add base address and bias address 
//----------------------------------------------------------  
wire   [`D_ADDR_W-1:0]   ldst_addr_bias;
assign  ldst_addr_bias = ldst_o_bias_reg + trg_reg;

//----------------------------------------------------------  
// put the trigger type signal to MV STAGE
//----------------------------------------------------------  
reg   [4:0]   trg_typ_reg;

always@(posedge clk or negedge rst_b)
if(!rst_b)trg_typ_reg <= 'd0;
else      trg_typ_reg <= ldst_typ_sel;
   
//----------------------------------------------------------  
// Generate load data select signal
// ldst_typ_sel[0] and [2]-[3]- Load
// ldst_typ_sel[1] and [4] -- Store
//----------------------------------------------------------  
reg ld_dat_sel;
reg ld_dat_sel1;
reg [5:0] counter;


   
//----------------------------------------------------------  
// Select load address :
// from directly address or bias address
//----------------------------------------------------------  
reg [`D_ADDR_W-1:0]   ldst_addr;

always@(trg_typ_reg or ldst_addr_bias or trg_reg)
begin
    case({(trg_typ_reg[3]|trg_typ_reg[4]),(trg_typ_reg[2]|trg_typ_reg[1]|trg_typ_reg[0])})
    2'b10:begin
        ldst_addr = ldst_addr_bias;  //Load or store with bias address
    end
    2'b01:begin
        ldst_addr = trg_reg;        // Load or store with directly address
    end
    default:begin
        ldst_addr = 0;
    end
    endcase
end

//----------------------------------------------------------  
// MV STAGE,combinational logic
// output to external data memory
//----------------------------------------------------------  


always@(posedge clk or negedge rst_b)
if(!rst_b)
  begin
		counter <= 0;
		dat_mem_en_b <= 1'b1;
		dat_mem_rw    <= 1'b1;
		dat_mem_addr <= 0;
		o_mem_dat     <= 0;
		ld_dat_sel <= 1'b0;
	end		
else begin
    case({trg_typ_reg[4],trg_typ_reg[3],trg_typ_reg[2],trg_typ_reg[1],trg_typ_reg[0]})
        5'b00010:begin      // Store directly
            dat_mem_rw    <= 1'b0;
            dat_mem_en_b  <= 1'b0;
            dat_mem_addr  <= ldst_addr;
            o_mem_dat     <= st_o_reg;
			ld_dat_sel	  <= 1'b0;
			counter 	  <= 0;
        end
        5'b00001:begin      // Load directly
            dat_mem_rw    <= 1'b1;
            dat_mem_en_b  <= 1'b0;
            dat_mem_addr  <= ldst_addr;
            o_mem_dat     <= 0;
			ld_dat_sel	  <= 1'b1;
			counter       <= 0;
        end
		5'b00100:begin      // Load with burst
            dat_mem_rw    <= 1'b1;
            dat_mem_en_b  <= 1'b0;
            dat_mem_addr  <= ldst_addr;
            o_mem_dat     <= 0;
			ld_dat_sel	  <= 1'b1;
			counter 	  <= 6'b111111;
        end
		5'b01000:begin      // Load with burst and bias
            dat_mem_rw    <= 1'b1;
            dat_mem_en_b  <= 1'b0;
            dat_mem_addr  <= ldst_addr;
            o_mem_dat     <= 0;
			ld_dat_sel	  <= 1'b1;
			counter 	  <= 6'b111111;
        end
        5'b10000:begin      // Store with bias
            dat_mem_rw    <= 1'b0;
            dat_mem_en_b  <= 1'b0;
            dat_mem_addr  <= ldst_addr;
            o_mem_dat     <= st_o_reg;
			ld_dat_sel	  <= 1'b0;
			counter 	  <= 0;
        end
        default:begin
			if(counter!=0)
				begin
				counter <= counter-1;
				dat_mem_en_b  <= 1'b0;
				dat_mem_rw    <= 1'b1;
				dat_mem_addr  <= dat_mem_addr+1;
				o_mem_dat     <= 0;
				ld_dat_sel 	  <= 1'b1;
				end
			else
				begin
				dat_mem_rw    <= 1'b1;
				dat_mem_en_b  <= 1'b1;
				dat_mem_addr  <= 0;
				o_mem_dat     <= 0;
				ld_dat_sel	  <= 1'b0;
				counter       <= 0;
				end
        end
   endcase
end 

always@(posedge clk or negedge rst_b)
if(!rst_b)ld_dat_sel1 <= 'd0;
else      ld_dat_sel1 <= ld_dat_sel;
	
//----------------------------------------------------------  
// Load data to Reuslt register
//----------------------------------------------------------  
always@(posedge clk or negedge rst_b)
if(!rst_b)
    ldst_r_dat <= 0;
else if(ld_dat_sel1 == 1'b1)
    ldst_r_dat <= i_mem_dat;
else
    ldst_r_dat <= ldst_r_dat;
   
   
//----------------------------------------------------------
endmodule   //end load_store module 
//===============================================================================