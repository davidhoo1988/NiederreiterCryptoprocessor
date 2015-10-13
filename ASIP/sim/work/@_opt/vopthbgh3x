library verilog;
use verilog.vl_types.all;
entity sprf_wrapper is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        ipt_decopr_to_wrp_delay: in     vl_logic_vector(7 downto 0);
        ipt_decopr_to_sprf_r0_typ_sel: in     vl_logic_vector(1 downto 0);
        ipt_decopr_to_sprf_r1_typ_sel: in     vl_logic_vector(1 downto 0);
        ipt_decsrc_to_sprf0_r_sel: in     vl_logic;
        ipt_decsrc_to_sprf1_r_sel: in     vl_logic;
        ipt_decdst_to_sprf0_r_sel: in     vl_logic;
        ipt_decdst_to_sprf1_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_indir_addr_sel: in     vl_logic;
        ipt_decdst_to_wrp_indir_addr_sel: in     vl_logic;
        ipt_sprf_to_wrp_dat: in     vl_logic_vector(143 downto 0);
        opt_wrp_to_sprf_r0_typ_sel: out    vl_logic_vector(1 downto 0);
        opt_wrp_to_sprf_r1_typ_sel: out    vl_logic_vector(1 downto 0);
        opt_wrp_to_sprf0_r_sel: out    vl_logic;
        opt_wrp_to_sprf1_r_sel: out    vl_logic;
        ipt_gprf_to_wrp_dat: in     vl_logic_vector(143 downto 0);
        opt_wrp_to_sprf_t_dat: out    vl_logic_vector(143 downto 0);
        opt_wrp_to_dram_addr: out    vl_logic_vector(16 downto 0)
    );
end sprf_wrapper;
