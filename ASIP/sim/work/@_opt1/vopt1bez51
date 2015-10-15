library verilog;
use verilog.vl_types.all;
entity ALU is
    generic(
        m               : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        alu_o_sel       : in     vl_logic;
        alu_t_sel       : in     vl_logic;
        alu_mod_sel     : in     vl_logic;
        alu_o_dat       : in     vl_logic_vector(0 to 144);
        alu_t_dat       : in     vl_logic_vector(0 to 143);
        alu_mod_dat     : in     vl_logic_vector(0 to 144);
        alu_typ_sel     : in     vl_logic_vector(3 downto 0);
        alu_r_dat1      : out    vl_logic_vector(0 to 143);
        alu_r_dat2      : out    vl_logic_vector(0 to 143);
        compute_done    : out    vl_logic
    );
end ALU;
