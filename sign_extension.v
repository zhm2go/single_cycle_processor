module sign_extension(immediate, extended);
	input [16:0] immediate;
	output [31:0] extended; 
	
	assign extended[15:0] = immediate[15:0];
	assign extended[31:16] = immediate[16] ? 16'hFFFF:16'h0000;
endmodule