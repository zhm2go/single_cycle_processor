module shift_2_bit(sx, target_address);
	input [31:0] sx;
	output [31:0] target_address;
	
	assign target_address[31:2] = sx[29:0];
	assign target_address[1:0] = 2'b00;
endmodule