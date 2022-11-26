module tb_hw_2 ();
    
	 reg clk;
    reg start;
	 reg [7:0] inp_1;
    wire [7:0] out_1;
		
	initial begin
		clk=1'b0;
		start=1'b1;
	end
	
	always	
		#5 clk=!clk;

    hw_2 UUT (
        .clk(clk),
        .start(start),
        .inp_1(inp_1),
        .out_1(out_1));
		  
endmodule 