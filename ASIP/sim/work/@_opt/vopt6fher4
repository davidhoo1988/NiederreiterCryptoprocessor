library verilog;
use verilog.vl_types.all;
entity pc_if is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        lock_rq         : in     vl_logic;
        pc_init_en      : in     vl_logic;
        pc_init_addr    : in     vl_logic_vector(9 downto 0);
        rpt_again       : in     vl_logic;
        rpt_start_addr  : in     vl_logic_vector(9 downto 0);
        jmp_pc_sel      : in     vl_logic;
        jmp_imm_data    : in     vl_logic_vector(18 downto 0);
        ins_mem_i       : in     vl_logic_vector(42 downto 0);
        mv_PC           : out    vl_logic_vector(9 downto 0);
        pc_en_b         : out    vl_logic;
        halt            : out    vl_logic;
        mv_ins_reg      : out    vl_logic_vector(42 downto 0)
    );
end pc_if;
