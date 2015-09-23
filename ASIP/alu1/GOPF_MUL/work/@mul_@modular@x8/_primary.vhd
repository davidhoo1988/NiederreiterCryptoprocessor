library verilog;
use verilog.vl_types.all;
entity Mul_ModularX8 is
    generic(
        m               : integer := 16
    );
    port(
        D_in            : in     vl_logic_vector;
        Q_out           : out    vl_logic_vector
    );
end Mul_ModularX8;
