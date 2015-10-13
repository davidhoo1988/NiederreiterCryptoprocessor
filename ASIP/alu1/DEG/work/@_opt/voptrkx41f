library verilog;
use verilog.vl_types.all;
entity DEG is
    generic(
        m               : integer := 144;
        DATA_PRE        : integer := 0;
        DATA_SHIFT      : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        poly_in         : in     vl_logic_vector;
        poly_deg_out    : out    vl_logic_vector(3 downto 0);
        deg_done        : out    vl_logic
    );
end DEG;
