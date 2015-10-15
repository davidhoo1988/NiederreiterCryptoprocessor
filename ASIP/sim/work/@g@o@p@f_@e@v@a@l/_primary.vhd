library verilog;
use verilog.vl_types.all;
entity GOPF_EVAL is
    generic(
        m               : integer := 16;
        poly_len        : integer := 144;
        block_size      : integer := 10
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        sigma_poly      : in     vl_logic_vector;
        eval_r_dat      : out    vl_logic_vector;
        eval_done       : out    vl_logic;
        mul1_o_out      : out    vl_logic_vector;
        mul2_o_out      : out    vl_logic_vector;
        mul3_o_out      : out    vl_logic_vector;
        mul4_o_out      : out    vl_logic_vector;
        mul5_o_out      : out    vl_logic_vector;
        mul6_o_out      : out    vl_logic_vector;
        mul7_o_out      : out    vl_logic_vector;
        mul8_o_out      : out    vl_logic_vector;
        mul9_o_out      : out    vl_logic_vector;
        mul1_t_out      : out    vl_logic_vector;
        mul2_t_out      : out    vl_logic_vector;
        mul3_t_out      : out    vl_logic_vector;
        mul4_t_out      : out    vl_logic_vector;
        mul5_t_out      : out    vl_logic_vector;
        mul6_t_out      : out    vl_logic_vector;
        mul7_t_out      : out    vl_logic_vector;
        mul8_t_out      : out    vl_logic_vector;
        mul9_t_out      : out    vl_logic_vector;
        mul1_add_out    : out    vl_logic_vector;
        mul2_add_out    : out    vl_logic_vector;
        mul3_add_out    : out    vl_logic_vector;
        mul4_add_out    : out    vl_logic_vector;
        mul5_add_out    : out    vl_logic_vector;
        mul6_add_out    : out    vl_logic_vector;
        mul7_add_out    : out    vl_logic_vector;
        mul8_add_out    : out    vl_logic_vector;
        mul9_add_out    : out    vl_logic_vector;
        mul1_r_dat      : in     vl_logic_vector;
        mul2_r_dat      : in     vl_logic_vector;
        mul3_r_dat      : in     vl_logic_vector;
        mul4_r_dat      : in     vl_logic_vector;
        mul5_r_dat      : in     vl_logic_vector;
        mul6_r_dat      : in     vl_logic_vector;
        mul7_r_dat      : in     vl_logic_vector;
        mul8_r_dat      : in     vl_logic_vector;
        mul9_r_dat      : in     vl_logic_vector
    );
end GOPF_EVAL;
