module ex27_32(T, extended);
	input [26:0] T;
	output [31:0] extended;
	assign extended[26:0] = T;
	assign extended[31:27] = 5'b00000;
endmodule