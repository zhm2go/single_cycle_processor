module Mux_5bit(A, B, S, Sout);
	input [4:0] A, B;
	input S;
	output [4:0] Sout;
	generate
		genvar i;
		for (i = 0; i < 5; i = i + 1) begin : generate_mux
			Mux muxgate(A[i], B[i],S, Sout[i]);
		end
	endgenerate
endmodule