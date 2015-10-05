library verilog;
use verilog.vl_types.all;
entity prng_wrapper is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        ipt_decopr_to_wrp_delay: in     vl_logic_vector(7 downto 0);
        ipt_decopr_to_prng_t_sel: in     vl_logic;
        ipt_decopr_to_prng_typ_sel: in     vl_logic_vector(1 downto 0);
        ipt_decsrc_to_prng_imm: in     vl_logic_vector(15 downto 0);
        opt_wrp_to_prng_t_sel: out    vl_logic;
        opt_wrp_to_prng_typ_sel: out    vl_logic_vector(1 downto 0);
        opt_wrp_to_prng_t_dat: out    vl_logic_vector(24 downto 0);
        ipt_prng_to_wrp_dat: in     vl_logic_vector(24 downto 0);
        opt_wrp_to_gprf_t_dat: out    vl_logic_vector(24 downto 0)
    );
end prng_wrapper;
