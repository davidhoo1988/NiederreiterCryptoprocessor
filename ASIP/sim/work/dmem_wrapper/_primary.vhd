library verilog;
use verilog.vl_types.all;
entity dmem_wrapper is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        t_rw            : in     vl_logic;
        ipt_decsrc_to_wrp_en_b: in     vl_logic;
        ipt_decsrc_to_wrp_addr: in     vl_logic_vector(16 downto 0);
        ipt_decdst_to_wrp_en_b: in     vl_logic;
        ipt_decdst_to_wrp_rw: in     vl_logic;
        ipt_decdst_to_wrp_addr: in     vl_logic_vector(16 downto 0);
        ipt_decopr_to_wrp_delay: in     vl_logic_vector(7 downto 0);
        ipt_sprfwrp_to_wrp_addr: in     vl_logic_vector(16 downto 0);
        opt_wrp_to_dram_en_b: out    vl_logic;
        opt_wrp_to_dram_rw: out    vl_logic;
        opt_wrp_to_dram_addr: out    vl_logic_vector(16 downto 0)
    );
end dmem_wrapper;
