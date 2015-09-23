library verilog;
use verilog.vl_types.all;
entity GOPF_MUL is
    generic(
        m               : integer := 144;
        DATA_PRE        : integer := 0;
        DATA_SHIFT      : integer := 1;
        DATA_MUL        : integer := 2;
        DATA_MAC        : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        multiplicand    : in     vl_logic_vector;
        multiplier      : in     vl_logic_vector;
        \mod\           : in     vl_logic_vector;
        mul_out         : out    vl_logic_vector
    );
end GOPF_MUL;
