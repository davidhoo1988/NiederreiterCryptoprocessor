library verilog;
use verilog.vl_types.all;
entity multiplier_tb is
    generic(
        m               : integer := 16;
        k3              : integer := 5;
        k2              : integer := 3;
        k1              : integer := 2;
        n               : integer := 8;
        period          : integer := 20
    );
end multiplier_tb;
