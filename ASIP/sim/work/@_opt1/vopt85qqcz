library verilog;
use verilog.vl_types.all;
entity src_decoder is
    port(
        src_code        : in     vl_logic_vector(18 downto 0);
        opr_code        : in     vl_logic_vector(4 downto 0);
        dat_ram_addr_en_b: out    vl_logic;
        dat_ram_addr    : out    vl_logic_vector(16 downto 0);
        imm_dat_sel     : out    vl_logic;
        imm_dat         : out    vl_logic_vector(15 downto 0);
        indir_addr_sel  : out    vl_logic;
        r0_r_sel        : out    vl_logic;
        r1_r_sel        : out    vl_logic;
        r2_r_sel        : out    vl_logic;
        r3_r_sel        : out    vl_logic;
        r4_r_sel        : out    vl_logic;
        r5_r_sel        : out    vl_logic;
        r6_r_sel        : out    vl_logic;
        r7_r_sel        : out    vl_logic;
        r0_t_sel        : out    vl_logic;
        r1_t_sel        : out    vl_logic;
        r2_t_sel        : out    vl_logic;
        r3_t_sel        : out    vl_logic;
        r4_t_sel        : out    vl_logic;
        r5_t_sel        : out    vl_logic;
        r6_t_sel        : out    vl_logic;
        r7_t_sel        : out    vl_logic;
        rmod_t_sel      : out    vl_logic;
        sprf0_r_sel     : out    vl_logic;
        sprf1_r_sel     : out    vl_logic
    );
end src_decoder;
