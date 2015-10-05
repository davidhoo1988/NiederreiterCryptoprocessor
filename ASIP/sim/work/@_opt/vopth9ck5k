library verilog;
use verilog.vl_types.all;
entity SPLIT is
    generic(
        m               : integer := 144;
        DATA_PRE        : integer := 0;
        DATA_SHIFT      : integer := 1;
        DATA_SQRT       : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        poly_in         : in     vl_logic_vector;
        first_fragment_out: out    vl_logic_vector;
        second_fragment_out: out    vl_logic_vector;
        split_done      : out    vl_logic
    );
end SPLIT;
