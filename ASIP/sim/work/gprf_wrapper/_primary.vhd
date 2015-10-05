library verilog;
use verilog.vl_types.all;
entity gprf_wrapper is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        t_rw            : in     vl_logic;
        ipt_pcif_to_wrp_halt: in     vl_logic;
        ipt_alu_to_wrp_done: in     vl_logic;
        ipt_decopr_to_wrp_delay: in     vl_logic_vector(7 downto 0);
        ipt_decopr_to_wrp_delay_sel: in     vl_logic;
        ipt_decsrc_to_wrp_imm_en: in     vl_logic;
        ipt_decsrc_to_wrp_imm: in     vl_logic_vector(15 downto 0);
        ipt_decsrc_to_wrp_en_b: in     vl_logic;
        ipt_decsrc_to_wrp_r0_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r1_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r2_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r3_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r4_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r5_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r6_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r7_r_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r0_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r1_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r2_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r3_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r4_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r5_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r6_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_r7_t_sel: in     vl_logic;
        ipt_decsrc_to_wrp_rmod_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_indir_addr_sel: in     vl_logic;
        ipt_decdst_to_wrp_r0_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r1_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r2_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r3_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r4_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r5_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r6_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r7_r_sel: in     vl_logic;
        ipt_decdst_to_wrp_r0_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r1_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r2_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r3_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r4_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r5_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r6_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_r7_t_sel: in     vl_logic;
        ipt_decdst_to_wrp_rmod_t_sel: in     vl_logic;
        ipt_dram_to_wrp_dat: in     vl_logic_vector(143 downto 0);
        opt_wrp_to_gprf_dat: out    vl_logic_vector(143 downto 0);
        opt_wrp_to_gprf_r0_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r1_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r2_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r3_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r4_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r5_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r6_t_sel: out    vl_logic;
        opt_wrp_to_gprf_r7_t_sel: out    vl_logic;
        opt_wrp_to_gprf_rmod_t_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r0_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r1_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r2_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r3_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r4_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r5_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r6_r_sel: out    vl_logic;
        opt_wrp_to_bus1_gprf_r7_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r0_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r1_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r2_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r3_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r4_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r5_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r6_r_sel: out    vl_logic;
        opt_wrp_to_bus2_gprf_r7_r_sel: out    vl_logic;
        ipt_gprf_to_wrp_dat1: in     vl_logic_vector(143 downto 0);
        ipt_gprf_to_wrp_dat2: in     vl_logic_vector(143 downto 0);
        opt_wrp_to_dram_dat: out    vl_logic_vector(143 downto 0);
        opt_wrp_to_dram_addr: out    vl_logic_vector(16 downto 0)
    );
end gprf_wrapper;