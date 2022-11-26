library verilog;
use verilog.vl_types.all;
entity hw_2 is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        inp_1           : in     vl_logic;
        out_1           : out    vl_logic
    );
end hw_2;
