module Mux(A, B, S, Sout);
	input A, B, S;
	output Sout;
	wire notS, and0, and1;
	not first_not(notS, S);
	and first_and(and0, A, notS);
	and second_and(and1, B, S);
	or first_or(Sout, and0, and1);
endmodule