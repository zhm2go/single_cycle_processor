module PC(data, clock, reset, enable, out);
	input [31:0] data;
	input enable;
	input clock, reset;
	output [31:0] out;
	
	generate
		genvar i;
		for ( i = 0; i < 32; i = i + 1) begin:generate_out
			dffe_ref dffe0(out[i], data[i], clock, enable, reset);
		end
	endgenerate

endmodule