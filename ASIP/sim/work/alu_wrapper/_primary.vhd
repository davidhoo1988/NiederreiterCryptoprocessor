library verilog;
use verilog.vl_types.all;
entity alu_wrapper is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        ipt_decopr_to_wrp_delay: in     vl_logic_vector(7 downto 0);
        ipt_decopr_to_wrp_div_mod_sel: in     vl_logic;
        ipt_decopr_to_alu_o_sel: in     vl_logic;
        ipt_decopr_to_alu_t_sel: in     vl_logic;
        ipt_decopr_to_alu_typ_sel: in     vl_logic_vector(3 downto 0);
        ipt_gprf_to_wrp_dat1: in     vl_logic_vector(143 downto 0);
        ipt_gprf_to_wrp_dat2: in     vl_logic_vector(143 downto 0);
        ipt_gprf_to_wrp_mod: in     vl_logic_vector(144 downto 0);
        ipt_sprf_to_wrp_dat: in     vl_logic_vector(143 downto 0);
        opt_wrp_to_alu_o_sel: out    vl_logic;
        opt_wrp_to_alu_t_sel: out    vl_logic;
        opt_wrp_to_alu_typ_sel: out    vl_logic_vector(3 downto 0);
        opt_wrp_to_alu_o_dat: out    vl_logic_vector(144 downto 0);
        opt_wrp_to_alu_t_dat: out    vl_logic_vector(143 downto 0);
        ipt_alu_to_wrp_dat: in     vl_logic_vector(143 downto 0);
        ipt_alu_to_wrp_dat2: in     vl_logic_vector(143 downto 0);
        ipt_alu_to_wrp_done: in     vl_logic;
        opt_wrp_to_gprf_t_dat: out    vl_logic_vector(143 downto 0);
        opt_wrp_to_pcif_jmp_sel: out    vl_logic;
        opt_wrp_to_imem_done: out    vl_logic
    );
end alu_wrapper;
