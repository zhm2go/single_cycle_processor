/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                  // I: Data from port B of regfile
	 /* for test */	
	
	 );
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 wire isNotEqual, isLessThan, overflow;
	 wire isNotEqual_4, isLessThan_4, overflow_4,isNotEqual_N, isLessThan_N, overflow_N;
	 wire [31:0] pc;
	 wire [31:0] pc_next, pc_1, pc_N, pc_T;
	 wire [31:0] extended, src, readData, data_result;
	 wire [4:0] rd;
	 wire ALU, BLT, BNE, JP, JR, JAL, BEX, SETX, SW, LW, ADDI, ADD, SUB;
	 /* control bit */
	 
	  
	 /* pc */
	 PC pc_0(pc_next, clock, reset, 1'b1, pc);
	 alu_4 plus1(pc, 32'h00000001, 5'b00000,
			5'b00000, pc_1, isNotEqual_4, isLessThan_4, overflow_4);
	 /* imem*/
	 assign address_imem = pc[11:0];
	 /* s1 */
	 wire[4:0] s1_1;
	 control_bit all_cb(q_imem, ALU, ADDI, SW, LW, JP, JR, JAL, BLT, BNE, BEX, SETX, ADD, SUB);
	 Mux_5bit s1_mux1(q_imem[21:17], q_imem[26:22], JR || BNE || BLT, s1_1);
	 Mux_5bit s1_mux2(s1_1, 5'b11110, BEX, ctrl_readRegA);
	 /* s2 */
	 wire[4:0] s2_1, s2_2;
	 Mux_5bit s2_mux1(q_imem[16:12], q_imem[21:17], BNE || BLT || SW || LW, s2_1);
	 Mux_5bit s2_mux2(s2_1, 5'b00000, BEX, s2_2);
	 Mux_5bit s2_mux3(s2_2, q_imem[26:22], SW || LW, ctrl_readRegB);
	 /* rd */
	 wire[4:0] rd_1;
	 Mux_5bit rd_mux1(q_imem[26:22], 5'b11111, JAL, rd_1);
	 Mux_5bit rd_mux2(rd_1, 5'b11110, SETX || (overflow && (ADD || ADDI || SUB)), ctrl_writeReg);
	 /* regfile */
	 assign ctrl_writeEnable = (ALU || ADDI || LW || JAL || SETX || overflow) && ~clock;
	 /* ALU */
	 wire [31:0] ALUsrc;
	 sign_extension sx(q_imem[16:0], extended);
	 assign ALUsrc = ADDI || SW || LW;
	 Mux_32bit alusrc(data_readRegB, extended, ALUsrc, src);
	 alu ALU_0(data_readRegA, src, (ALU?q_imem[6:2]:5'b00000),
			q_imem[11:7], data_result, isNotEqual, isLessThan, overflow);
	 /* dmem */
	 assign address_dmem = data_result[11:0];
	 assign data = data_readRegB;
	 assign wren = SW;
	 /* data_writeReg */
	 wire[31:0] T;
	 ex27_32 t32(q_imem[26:0], T);
	 wire[31:0] data1, data2, data3, data4, data5;
	 Mux_32bit mux_rwd(data_result, q_dmem, LW, data1);
	 Mux_32bit mux_jal(data1, pc_1, JAL, data2);
	 Mux_32bit mux_setx(data2, T, SETX, data3);
	 Mux_32bit mux_add_overflow(data3, 32'h00000001, ADD && overflow, data4);
	 Mux_32bit mux_addi_overflow(data4, 32'h00000002, ADDI && overflow, data5);
	 Mux_32bit mux_sub_overflow(data5, 32'h00000003, SUB && overflow, data_writeReg);
	 /* PC_next*/
	 wire[31:0] pc_1N, pc_2, pc_t;
	 alu_N plusn(pc_1, extended, 5'b00000,
			5'b00000, pc_1N, isNotEqual_N, isLessThan_N, overflow_N);
	 Mux_32bit BLT_BNE(pc_1, pc_1N, (BLT && isLessThan) || (BNE && isNotEqual), pc_2);
	 Mux_32bit mux_JP(pc_2, T, JP || JAL || BEX, pc_t);
	 Mux_32bit mux_JR(pc_t, data_readRegA, JR, pc_next);
	 /* for test*/
endmodule