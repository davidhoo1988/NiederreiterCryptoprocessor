library verilog;
use verilog.vl_types.all;
entity ALU_InvGenerator is
    generic(
        m               : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        inv_in          : in     vl_logic_vector;
        inv_out         : out    vl_logic_vector;
        product_in      : in     vl_logic_vector;
        operandA_out    : out    vl_logic_vector;
        operandB_out    : out    vl_logic_vector;
        alu_o_sel       : in     vl_logic
    );
end ALU_InvGenerator;
