library verilog;
use verilog.vl_types.all;
entity GOPF_MUL is
    generic(
        m               : integer := 144;
        DATA_PRE        : integer := 0;
        DATA_DEGREE     : integer := 1;
        DATA_SHIFT      : integer := 2;
        DATA_MUL        : integer := 3;
        DATA_MAC        : integer := 4
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        multiplicand    : in     vl_logic_vector;
        multiplier      : in     vl_logic_vector;
        \mod\           : in     vl_logic_vector;
        mul_out         : out    vl_logic_vector;
        mul_done        : out    vl_logic;
        mul1_o_out      : out    vl_logic_vector(0 to 15);
        mul2_o_out      : out    vl_logic_vector(0 to 15);
        mul3_o_out      : out    vl_logic_vector(0 to 15);
        mul4_o_out      : out    vl_logic_vector(0 to 15);
        mul5_o_out      : out    vl_logic_vector(0 to 15);
        mul6_o_out      : out    vl_logic_vector(0 to 15);
        mul7_o_out      : out    vl_logic_vector(0 to 15);
        mul8_o_out      : out    vl_logic_vector(0 to 15);
        mul9_o_out      : out    vl_logic_vector(0 to 15);
        mul_t_out       : out    vl_logic_vector(0 to 15);
        mul1_r_dat      : in     vl_logic_vector(0 to 15);
        mul2_r_dat      : in     vl_logic_vector(0 to 15);
        mul3_r_dat      : in     vl_logic_vector(0 to 15);
        mul4_r_dat      : in     vl_logic_vector(0 to 15);
        mul5_r_dat      : in     vl_logic_vector(0 to 15);
        mul6_r_dat      : in     vl_logic_vector(0 to 15);
        mul7_r_dat      : in     vl_logic_vector(0 to 15);
        mul8_r_dat      : in     vl_logic_vector(0 to 15);
        mul9_r_dat      : in     vl_logic_vector(0 to 15)
    );
end GOPF_MUL;
