library verilog;
use verilog.vl_types.all;
entity tpsba is
    port(
        inp_exp_x       : in     vl_logic_vector(15 downto 0);
        inp_sin_x       : in     vl_logic_vector(15 downto 0);
        inp_cos_x       : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        out_exp_x       : out    vl_logic_vector(31 downto 0);
        out_sin_x       : out    vl_logic_vector(31 downto 0);
        out_cos_x       : out    vl_logic_vector(31 downto 0)
    );
end tpsba;
