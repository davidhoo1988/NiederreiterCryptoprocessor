library verilog;
use verilog.vl_types.all;
entity prng_lcg is
    generic(
        ST_PRE          : integer := 0;
        SEED_UPDATE     : integer := 1;
        RNG_GEN         : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        prng_typ_sel    : in     vl_logic_vector(1 downto 0);
        prng_t_dat      : in     vl_logic_vector(24 downto 0);
        prng_t_sel      : in     vl_logic;
        prng_r_dat      : out    vl_logic_vector(24 downto 0)
    );
end prng_lcg;
