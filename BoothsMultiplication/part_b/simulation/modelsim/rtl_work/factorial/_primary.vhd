library verilog;
use verilog.vl_types.all;
entity factorial is
    port(
        product         : out    vl_logic_vector(31 downto 0);
        N               : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic
    );
end factorial;
