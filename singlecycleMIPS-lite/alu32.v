module alu32(alu_out, a, b, zout, alu_control);
output reg [31:0] alu_out;
input [31:0] a,b;
input [2:0] alu_control;

reg [31:0] less;
output zout;
reg zout;

always @(a or b or alu_control)
begin
	/*
	there are 5 type of instructions which are 
	2) sum = a + b
	6) sum = a - b
	7) 
	*/
	case(alu_control)
	3'b010: alu_out = a+b; 
	3'b110: alu_out = a+1+(~b);
	3'b111: begin less = a+1+(~b);
			if (less[31]) alu_out=1;
			else alu_out=0;
		end

	/*
	0) a AND b
	1) a OR b
	*/
	3'b000: alu_out = a & b;
	3'b001: alu_out = a|b;
	3'b011: alu_out = a * b;
	default: alu_out=31'bx;
	endcase
zout=~(|alu_out);
end
endmodule
