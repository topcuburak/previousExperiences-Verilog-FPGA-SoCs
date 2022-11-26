library verilog;
use verilog.vl_types.all;
entity cosine_module is
    port(
        inp_cos_x       : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        out_cos_x       : out    vl_logic_vector(31 downto 0)
    );
end cosine_module;
