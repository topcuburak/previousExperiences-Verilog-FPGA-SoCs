library verilog;
use verilog.vl_types.all;
entity hw_2_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        inp_1           : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end hw_2_vlg_sample_tst;
