library verilog;
use verilog.vl_types.all;
entity opr_decoder is
    port(
        opr_code        : in     vl_logic_vector(4 downto 0);
        dst_code        : in     vl_logic_vector(18 downto 0);
        src_typ         : in     vl_logic_vector(2 downto 0);
        dst_typ         : in     vl_logic_vector(2 downto 0);
        opr_typ_sel     : out    vl_logic_vector(4 downto 0);
        opr_div_mod_sel : out    vl_logic;
        alu_o_sel       : out    vl_logic;
        alu_t_sel       : out    vl_logic;
        alu_typ_sel     : out    vl_logic_vector(3 downto 0);
        prng_t_sel      : out    vl_logic;
        prng_typ_sel    : out    vl_logic_vector(1 downto 0);
        sprf_typ_r0_sel : out    vl_logic_vector(1 downto 0);
        sprf_typ_r1_sel : out    vl_logic_vector(1 downto 0);
        src_dst_delay_sel: out    vl_logic;
        src_dst_delay   : out    vl_logic_vector(7 downto 0)
    );
end opr_decoder;
