library verilog;
use verilog.vl_types.all;
entity RA1SH is
    generic(
        AddressWidth    : integer := 12;
        DataWidth       : integer := 144;
        Deapth          : integer := 4096
    );
    port(
        CLK             : in     vl_logic;
        A               : in     vl_logic_vector;
        D               : in     vl_logic_vector;
        Q               : out    vl_logic_vector;
        CEN             : in     vl_logic;
        WEN             : in     vl_logic;
        OEN             : in     vl_logic
    );
end RA1SH;
