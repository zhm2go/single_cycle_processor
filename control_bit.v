module control_bit(q_imem, ALU, ADDI,SW, LW, JP, JR, JAL, BLT, BNE, BEX, SETX, ADD, SUB);
	 input [31:0] q_imem;
	 output ALU, ADDI, SW, LW, JP, JR, JAL, BLT, BNE, BEX, SETX, ADD, SUB;
	 assign ALU = ~q_imem[31] && ~q_imem[30] && ~q_imem[29] && ~q_imem[28] && ~q_imem[27];
	 assign ADDI = ~q_imem[31] && ~q_imem[30] && q_imem[29] && ~q_imem[28] && q_imem[27];
	 assign SW = ~q_imem[31] && ~q_imem[30] && q_imem[29] && q_imem[28] && q_imem[27];
	 assign LW = ~q_imem[31] && q_imem[30] && ~q_imem[29] && ~q_imem[28] && ~q_imem[27];
	 assign JP = ~q_imem[31] && ~q_imem[30] && ~q_imem[29] && ~q_imem[28] && q_imem[27];
	 assign JR = ~q_imem[31] && ~q_imem[30] && q_imem[29] && ~q_imem[28] && ~q_imem[27];
	 assign JAL = ~q_imem[31] && ~q_imem[30] && ~q_imem[29] && q_imem[28] && q_imem[27];
	 assign BLT = ~q_imem[31] && ~q_imem[30] && q_imem[29] && q_imem[28] && ~q_imem[27];
	 assign BNE = ~q_imem[31] && ~q_imem[30] && ~q_imem[29] && q_imem[28] && ~q_imem[27];
	 assign BEX = q_imem[31] && ~q_imem[30] && q_imem[29] && q_imem[28] && ~q_imem[27];
	 assign SETX = q_imem[31] && ~q_imem[30] && q_imem[29] && ~q_imem[28] && q_imem[27];
	 assign ADD = ALU && ~q_imem[6] && ~q_imem[5] && ~q_imem[4] && ~q_imem[3] && ~q_imem[2];
	 assign SUB = ALU && ~q_imem[6] && ~q_imem[5] && ~q_imem[4] && ~q_imem[3] && q_imem[2];
endmodule