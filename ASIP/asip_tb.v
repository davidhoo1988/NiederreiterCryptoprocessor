// FILE NAME  : 
// TYPE       : testbench
// AUTHOR     : David J.W. HU
// EMAIL      : davidhoo471494221@gmail.com
// --------------------------------------------------------------------- 
// PURPOSE  :  Verify ASIP
// --------------------------------------------------------------------- 
// =============================================================================
// synthesis translate_off
`include    "../include/timescale.v"
// synthesis translate_on
`include    "../include/define.v"

module	asip_tb();

`define    CCore_ADDRW       18             // External address width
`define    DATW              32             // Data Width  

    parameter   PERIOD = 10;                // clock periods
    parameter   INPUT_DELAY = (PERIOD/5);   // input delay, rang: 0 < INPUT_DELAY < (4*PERIOD/5)
    parameter   WDATA_DELAY = (PERIOD/5);   // Writing Data after Address

    
    reg     clk;                            // system clock
    reg     reset_b;                        // Asynchronous reset signal
    reg     t_cs;                           // tcore's chip select
    wire    [`MEM_W-1:0]        out;

    reg     t_rw;                           // read-or-write signal, 1--read, 0-- write
    reg     [`CCore_ADDRW-1:0]  t_addr;     // address bus
    reg     [`DATW-1:0]         t_wdata;    // write data
    wire    [`DATW-1:0]         t_rdata;    // read data
    wire                        int_flag;   // Interrupt Flag singnal
 
    
// -----------------------------------------------------------------------------
//  instance top module
// -----------------------------------------------------------------------------
asip_top   asip_top(
            .clk      ( clk		),
            .reset_b  ( reset_b	),
            .t_cs     ( t_cs	),
            .out      ( out   )
            );
            
// -----------------------------------------------------------------------------
// read the memory file
// -----------------------------------------------------------------------------     
initial
begin
   $readmemb("./mem_data/program.asm",asip_top.ins_sram.mem);
   $readmemb("./mem_data/data1.txt",asip_top.dat_sram1.mem);
   //$readmemh("table1.txt",tcore_chip.tcore_top.tcore_syn.connector.Table_luta1.mem);
  // $readmemh("table2.txt",tcore_chip.tcore_top.tcore_syn.connector.Table_luta2.mem);
  // $readmemh("table3.txt",tcore_chip.tcore_top.tcore_syn.connector.Table_lutb1.mem);
end    


// -----------------------------------------------------------------------------
// assign port signal value
// -----------------------------------------------------------------------------   
initial
begin
      clk       = 1'b0;
      reset_b   = 1'b0;
      t_cs      = 1'b0;
      t_rw      = 1'b0;
      t_addr    = `CCore_ADDRW'b0;
      t_wdata   = 'b0;
end

//-----------assign clk----------------------------------
always #(PERIOD/2) clk=~clk;

initial
begin
    #(PERIOD*10)   
    reset_b = 1'b1;

    repeat(5)@(posedge clk);    
    t_addr  = 'h0004; 
    Tcore_write(t_addr,'h0);
    
end


// -----------------------------------------------------------------------------
//  tasks
// -----------------------------------------------------------------------------
task Tcore_write;
  input   [`CCore_ADDRW-1:0]    addr;
  input   [`DATW-1:0]       	data;
  begin
    @(posedge clk)#INPUT_DELAY;
        t_cs    = 1'b1;
        t_rw    = 1'b0;
        t_addr  = addr;
    #WDATA_DELAY    
        t_wdata = data;   
    @(posedge clk)#INPUT_DELAY;
        t_cs    = 1'b1;
  end
endtask//end Tcore_write

// -----------------------------------------------------------------------------
task Tcore_read;
  input   [`CCore_ADDRW-1:0]    addr;
  output  [`DATW-1:0]       data;
  begin
    @(posedge clk)#INPUT_DELAY;
        t_cs    = 1'b1;
        t_rw    = 1'b1;
        t_addr  = addr;
    @(posedge clk)#INPUT_DELAY;
        t_cs    = 1'b0;  
    repeat(3)@(posedge clk)#INPUT_DELAY;
        data    = t_rdata; 
  end
endtask//end Tcore_read



//-----------------------------------------------------------
endmodule

// =============================================================================