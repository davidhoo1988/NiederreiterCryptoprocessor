library verilog;
use verilog.vl_types.all;
entity imem_wrapper is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        t_rw            : in     vl_logic;
        ipt_pcif_to_wrp_en_b: in     vl_logic;
        ipt_pcif_to_wrp_addr: in     vl_logic_vector(9 downto 0);
        opt_wrp_to_iram_en_b: out    vl_logic;
        opt_wrp_to_iram_addr: out    vl_logic_vector(9 downto 0);
        ipt_iram_to_wrp_dat: in     vl_logic_vector(42 downto 0);
        opt_wrp_to_pcif_dat: out    vl_logic_vector(42 downto 0);
        opt_wrp_to_pcif_lockrq: out    vl_logic;
        opt_wrp_to_pcif_jmp_addr_sel: out    vl_logic;
        opt_wrp_to_pcif_jmp_addr: out    vl_logic_vector(18 downto 0);
        ipt_decopr_to_wrp_opr_typ_sel: in     vl_logic_vector(4 downto 0);
        ipt_decopr_to_wrp_delay: in     vl_logic_vector(17 downto 0);
        ipt_decopr_to_wrp_delay_sel: in     vl_logic;
        ipt_decdst_to_wrp_jmp_addr_sel: in     vl_logic;
        ipt_decdst_to_wrp_jmp_addr: in     vl_logic_vector(18 downto 0);
        ipt_alu_to_wrp_jmp_addr_sel: in     vl_logic;
        ipt_alu_to_wrp_alu_done: in     vl_logic
    );
end imem_wrapper;
