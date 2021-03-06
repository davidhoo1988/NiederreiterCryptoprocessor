library verilog;
use verilog.vl_types.all;
entity prng_lsfr is
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        prng_typ_sel    : in     vl_logic_vector(1 downto 0);
        prng_t_dat      : in     vl_logic_vector(24 downto 0);
        prng_t_sel      : in     vl_logic;
        prng_r_dat      : out    vl_logic_vector(24 downto 0)
    );
end prng_lsfr;
