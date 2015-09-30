library verilog;
use verilog.vl_types.all;
entity GOPF_EVAL is
    generic(
        m               : integer := 144;
        DATA_PRE        : integer := 0;
        DATA_SHIFT      : integer := 1;
        DATA_MUL        : integer := 2;
        DATA_ADD        : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        gopf            : in     vl_logic_vector;
        gf2e_element    : in     vl_logic_vector;
        eval_r_dat      : out    vl_logic_vector;
        eval_done       : out    vl_logic;
        mul1_o_out      : out    vl_logic_vector(0 to 15);
        mul2_o_out      : out    vl_logic_vector(0 to 15);
        mul3_o_out      : out    vl_logic_vector(0 to 15);
        mul4_o_out      : out    vl_logic_vector(0 to 15);
        mul5_o_out      : out    vl_logic_vector(0 to 15);
        mul6_o_out      : out    vl_logic_vector(0 to 15);
        mul7_o_out      : out    vl_logic_vector(0 to 15);
        mul8_o_out      : out    vl_logic_vector(0 to 15);
        mul9_o_out      : out    vl_logic_vector(0 to 15);
        mul1_t_out      : out    vl_logic_vector(0 to 15);
        mul2_t_out      : out    vl_logic_vector(0 to 15);
        mul3_t_out      : out    vl_logic_vector(0 to 15);
        mul4_t_out      : out    vl_logic_vector(0 to 15);
        mul5_t_out      : out    vl_logic_vector(0 to 15);
        mul6_t_out      : out    vl_logic_vector(0 to 15);
        mul7_t_out      : out    vl_logic_vector(0 to 15);
        mul8_t_out      : out    vl_logic_vector(0 to 15);
        mul9_t_out      : out    vl_logic_vector(0 to 15);
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
end GOPF_EVAL;
