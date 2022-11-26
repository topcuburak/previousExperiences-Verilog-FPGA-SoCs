library verilog;
use verilog.vl_types.all;
entity sine_module is
    port(
        inp_sin_x       : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        out_sin_x       : out    vl_logic_vector(31 downto 0)
    );
end sine_module;
