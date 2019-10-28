module Mux_32bit(A, B, S, Sout);
	input [31:0] A, B;
	input S;
	output [31:0] Sout;
	generate
		genvar i;
		for (i = 0; i < 32; i = i + 1) begin : generate_mux
			Mux muxgate(A[i], B[i],S, Sout[i]);
		end
	endgenerate
endmodule