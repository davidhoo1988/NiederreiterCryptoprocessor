library verilog;
use verilog.vl_types.all;
entity Inv_Ctrl is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        inv_cSignal     : out    vl_logic_vector(4 downto 0);
        alu_o_sel       : in     vl_logic
    );
end Inv_Ctrl;
