library verilog;
use verilog.vl_types.all;
entity ALU_Multiplier is
    generic(
        m               : integer := 16;
        k2              : integer := 5;
        k1              : integer := 3;
        k0              : integer := 2
    );
    port(
        clk             : in     vl_logic;
        A_in            : in     vl_logic_vector;
        B_in            : in     vl_logic_vector;
        C_out           : out    vl_logic_vector
    );
end ALU_Multiplier;
