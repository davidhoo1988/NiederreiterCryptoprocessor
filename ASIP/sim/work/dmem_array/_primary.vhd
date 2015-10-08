library verilog;
use verilog.vl_types.all;
entity dmem_array is
    port(
        clk             : in     vl_logic;
        dmem_rw         : in     vl_logic;
        dmem_cs         : in     vl_logic_vector(5 downto 0);
        dmem_addr       : in     vl_logic_vector(10 downto 0);
        data_in         : in     vl_logic_vector(143 downto 0);
        data_out        : out    vl_logic_vector(143 downto 0)
    );
end dmem_array;