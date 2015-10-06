library verilog;
use verilog.vl_types.all;
entity asip_syn is
    port(
        clk             : in     vl_logic;
        reset_b         : in     vl_logic;
        t_cs            : in     vl_logic;
        ins_mem_dat     : in     vl_logic_vector(42 downto 0);
        ins_mem_en_b    : out    vl_logic;
        ins_mem_addr    : out    vl_logic_vector(9 downto 0);
        dat_mem1_rw     : out    vl_logic;
        dat_mem1_en_b   : out    vl_logic;
        dat_mem1_cs     : out    vl_logic_vector(4 downto 0);
        dat_mem1_addr   : out    vl_logic_vector(11 downto 0);
        mem1_to_wrp_dat : in     vl_logic_vector(143 downto 0);
        wrp_to_mem1_dat : out    vl_logic_vector(143 downto 0)
    );
end asip_syn;
