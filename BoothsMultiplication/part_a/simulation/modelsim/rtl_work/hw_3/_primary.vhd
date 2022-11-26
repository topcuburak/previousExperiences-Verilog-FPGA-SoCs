library verilog;
use verilog.vl_types.all;
entity hw_3 is
    port(
        product         : out    vl_logic_vector(31 downto 0);
        Multiplicand    : in     vl_logic_vector(15 downto 0);
        Multiplier      : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        bit_range       : in     vl_logic_vector(3 downto 0)
    );
end hw_3;
