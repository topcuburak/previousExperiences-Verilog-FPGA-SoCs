library verilog;
use verilog.vl_types.all;
entity hw_2 is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        inp_1           : in     vl_logic_vector(7 downto 0);
        out_1           : out    vl_logic_vector(7 downto 0)
    );
end hw_2;
