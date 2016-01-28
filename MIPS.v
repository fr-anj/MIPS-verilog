module MIPS (
	//output	[7:0] 	O_inst_addr,
	//input 	[15:0] 	I_inst,
	input 	rst,
	input 	clk);

	//wire	[7:0] 	O_inst_addr; 	//PC <-> ROM

	wire 	[7:0] 	JUMP_ADDR;		//JPBR_CONTROL <-> PC

	wire	[7:0] 	BRANCH_ADDR;	//JPBR_CONTROL <-> PC

	wire	[1:0] 	PC_SEL;			//JPBR_CONTROL <-> PC

	wire 			STALL;			//STALLING <-> PC 
									//STALLING <-> IFID

	//wire 	[4:0] 	EXMEM_OPCODE;	//EXMEM <-> JPBR_CONTROL

	//wire 	[4:0]	MEM_ADDR;		//RAM <-> JPBR_CONTROL

	//wire 	[7:0]	REG_ADDR;		//REGISTER_FILE <-> JPBR_CONTROL

	wire 	[7:0] 	R1_DATA; 		//REGISTER_FILE <-> IDEX

	wire 	[7:0] 	R2_DATA;		//REGISTER_FILE <-> IDEX
									//REGISTER_FILE <-> JPBR_CONTROL

	wire 	[7:0] 	RD_DATA;		//REGISTER_FILE <-> IDEX

	wire	[2:0] 	REG_W_ADDR;		//MEMWB <-> REGISTER_FILE

	wire	[7:0] 	REG_W_DATA;		//MEMWB <-> REGISTER_FILE

	wire			W_ENABLE;		//MEMWB <-> REGISTER_FILE

	wire	[7:0] 	R_DATA;			//RAM <-> MEMWB

	wire 	[7:0] 	RAM_W_ADDR;		//IDEX <-> RAM

	wire 	[7:0] 	RAM_W_DATA;		//IDEX <-> RAM

	wire 	[7:0] 	DATA_ADDR;		//IDEX <-> RAM

	wire			RW_ENABLE;		//IDEX <-> RAM

	wire	[7:0]	INST_ADDR;

	wire 	[15:0]	INSTRUCTION;

	wire	[4:0]	INST_OPCODE;

	wire	[2:0]	INST_RD_ADDR;

	wire	[3:0]	INST_R1_ADDR;

	wire	[3:0]	INST_R2_ADDR;
	
	wire 	[4:0]	IFID_OPCODE;	//IFID <-> JPBR_CONTROL

	wire	[2:0] 	IFID_RD_ADDR;	//IFID <-> REGISTER_FILE
	
	wire	[3:0] 	IFID_R1_ADDR;	//IFID <-> REGISTER_FILE

	wire	[3:0] 	IFID_R2_ADDR;	//IFID <-> REGISTER_FILE

	wire 	[4:0]	IDEX_OPCODE;

	wire 	[2:0]	IDEX_RD_ADDR;

	wire 	[3:0]	IDEX_R1_ADDR;

	wire 	[3:0]	IDEX_R2_ADDR;

	wire 	[7:0]	IDEX_RD_DATA;

	wire 	[7:0]	IDEX_R1_DATA;

	wire 	[7:0]	IDEX_R2_DATA;

	wire 	[4:0]	EXMEM_OPCODE;

	wire 	[2:0]	EXMEM_RD_ADDR;

	wire 	[3:0]	EXMEM_R1_ADDR;

	wire 	[3:0]	EXMEM_R2_ADDR;

	wire 	[7:0]	EXMEM_RD_DATA;

	//wire 	[7:0]	EXMEM_R1_DATA;

	//wire 	[7:0]	EXMEM_R2_DATA;

	wire 	[7:0]	EXMEM_ALU_OUT;

	wire	[4:0]	MEMWB_OPCODE;

	wire	[2:0]	MEMWB_RD_ADDR;

	wire	[3:0]	MEMWB_R1_ADDR;

	wire	[3:0]	MEMWB_R2_ADDR;

	//wire	[7:0]	MEMWB_RD_DATA;

	//wire	[7:0]	MEMWB_R1_DATA;

	//wire	[7:0]	MEMWB_R2_DATA;

	wire	[7:0]	MEMWB_ALU_OUT;

	wire	[7:0]	MEMWB_R_DATA;

	wire 			FLUSH_IFID;

	wire 			FLUSH_IDEX;

	wire 			FLUSH_EXMEM;

	wire 	[2:0]	ALU_FORWARD_R1;

	wire 	[2:0]	ALU_FORWARD_R2;

	wire 	[3:0]	BRANCH_FORWARD_RD;

	wire 	[3:0]	BRANCH_FORWARD_R2;

	wire 			CARRY_FLAG;

	wire 	[7:0]	ALU_OUT;

	wire 	[2:0]	RAM_FORWARD;

	wire 	[4:0] 	STALL_OPCODE;

	wire 	[2:0] 	STALL_RD_ADDR;

	wire 	[3:0] 	STALL_R1_ADDR;

	wire 	[3:0] 	STALL_R2_ADDR;

//	wire 		JUMP_FORWARD;

	wire 	[1:0]	MEMBR_FORWARD; 

	PC CLK0 (
		.O_inst_addr(INST_ADDR),
		.STALL(STALL),
		.JUMP_ADDR(JUMP_ADDR),
		.BRANCH_ADDR(BRANCH_ADDR),
		.SEL(PC_SEL),
		.rst(rst),
		.clk(clk)
	);

	RAM E0 (
	.R_DATA(R_DATA),
	.W_ADDR(RAM_W_ADDR),
	.W_DATA(RAM_W_DATA),	//idex rd data
	.DATA_ADDR(DATA_ADDR),
	.RW_ENABLE(RW_ENABLE),
	.rst(rst),
	.clk(clk)
	);

	ROM E1 (//Jurgen's ROM huehue
	.I_CLK(clk),
	//.I_EN,
	.I_ADDR(INST_ADDR),
	.O_INSTR(INSTRUCTION)
	);

	REGISTER_FILE CLK1 (
	.R1_DATA(R1_DATA),
	.R2_DATA(R2_DATA),
	.RD_DATA(RD_DATA),
	.RD_ADDR(INST_RD_ADDR[2:0]),	
	.R1_ADDR(INST_R1_ADDR[2:0]),
	.R2_ADDR(INST_R2_ADDR[2:0]),
	.W_ADDR(REG_W_ADDR),
	.W_DATA(REG_W_DATA),
	.W_ENABLE(W_ENABLE),
	.rst(rst),	
	.clk(clk)	
	);

/*	JPBR_CONTROL CONT0 (
	.SEL(PC_SEL),
	.BRANCH_ADDR(BRANCH_ADDR),
	.JUMP_ADDR(JUMP_ADDR),
	.IFID_OPCODE(IFID_OPCODE),
	.EXMEM_OPCODE(EXMEM_OPCODE),
	//.MEM_ADDR(R_DATA),	//RAM R_DATA
	.REG_ADDR(R2_DATA),	//REGISTER_FILE R2_DATA

	.BRANCH_FORWARD_R2(BRANCH_FORWARD_R2), 
	.ALU_OUT(ALU_OUT),
	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.MEMWB_ALU_OUT(MEMWB_ALU_OUT),

	.JUMP_FORWARD(JUMP_FORWARD),
	.R_DATA(R_DATA),
	.MEMWB_R_DATA(MEMWB_R_DATA)
	); 	*/

	JPBR_CONTROL CONT0(
	.SEL(PC_SEL),
	.BRANCH_ADDR(BRANCH_ADDR),
	.JUMP_ADDR(JUMP_ADDR),
	.IFID_OPCODE(IFID_OPCODE),
	.EXMEM_OPCODE(EXMEM_OPCODE),	
	.REG_ADDR(R2_DATA),

	.BRANCH_FORWARD_R2(BRANCH_FORWARD_R2),
	.ALU_OUT(ALU_OUT),
	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.MEMWB_ALU_OUT(MEMWB_ALU_OUT),

	.JUMP_FORWARD(JUMP_FORWARD),
	.R_DATA(R_DATA),
	.MEMWB_R_DATA(MEMWB_R_DATA),

	.MEMBR_FORWARD(MEMBR_FORWARD),
	.BRANCH_FORWARD_RD(BRANCH_FORWARD_RD),
	.MEMWB_R1_ADDR(MEMWB_R1_ADDR),
	.MEMWB_R2_ADDR(MEMWB_R2_ADDR),
	.EXMEM_RD_DATA(EXMEM_RD_DATA),
	.EXMEM_R1_ADDR(EXMEM_R1_ADDR),
	.EXMEM_R2_ADDR(EXMEM_R2_ADDR),
	.IDEX_R1_ADDR(IDEX_R1_ADDR),
	.IDEX_R2_ADDR(IDEX_R2_ADDR),
	.RD_DATA(RD_DATA)

	);

	STALLING CONT1 (	//stalls decode during load instruction
	.STALL(STALL),
	.IFID_R1_ADDR(IFID_R1_ADDR[2:0]),
	.IFID_R2_ADDR(IFID_R2_ADDR[2:0]),
	.IDEX_RD_ADDR(IDEX_RD_ADDR[2:0]),
	.IDEX_OPCODE(IDEX_OPCODE),

	.STALL_OPCODE(STALL_OPCODE),
	.STALL_RD_ADDR(STALL_RD_ADDR),
	.STALL_R1_ADDR(STALL_R1_ADDR),
	.STALL_R2_ADDR(STALL_R2_ADDR),

	.IFID_OPCODE(IFID_OPCODE)
	);

	FORWARDING CONT2 (
	.ALU_FORWARD_R1(ALU_FORWARD_R1),
	.ALU_FORWARD_R2(ALU_FORWARD_R2),
	.BRANCH_FORWARD_RD(BRANCH_FORWARD_RD),
	.BRANCH_FORWARD_R2(BRANCH_FORWARD_R2),
	.EXMEM_RD_ADDR(EXMEM_RD_ADDR[2:0]),
	.MEMWB_RD_ADDR(MEMWB_RD_ADDR[2:0]),
	.IDEX_OPCODE(IDEX_OPCODE),
	.IFID_OPCODE(IFID_OPCODE),
	.IDEX_RD_ADDR(IDEX_RD_ADDR[2:0]),
	.IDEX_R1_ADDR(IDEX_R1_ADDR[2:0]),
	.IDEX_R2_ADDR(IDEX_R2_ADDR[2:0]),
	.IFID_RD_ADDR(IFID_RD_ADDR[2:0]),
	.IFID_R2_ADDR(IFID_R2_ADDR[2:0]),

	.EXMEM_OPCODE(EXMEM_OPCODE),
	.MEMWB_OPCODE(MEMWB_OPCODE),
	.RAM_FORWARD(RAM_FORWARD),

	//.JUMP_FORWARD(JUMP_FORWARD),
	.EXMEM_R1_ADDR(EXMEM_R1_ADDR),
	.EXMEM_R2_ADDR(EXMEM_R2_ADDR),
	.MEMWB_R1_ADDR(MEMWB_R1_ADDR),
	.MEMWB_R2_ADDR(MEMWB_R2_ADDR),

	.MEMBR_FORWARD(MEMBR_FORWARD)
	);

/*	BRANCH CONT3 (
	.FLUSH_IFID(FLUSH_IFID),
	.FLUSH_IDEX(FLUSH_IDEX),
	.FLUSH_EXMEM(FLUSH_EXMEM),
	.IFID_OPCODE(IFID_OPCODE),
	.EXMEM_OPCODE(EXMEM_OPCODE),
	.RD_DATA(RD_DATA),
	.EXMEM_RD_DATA(EXMEM_RD_DATA),

	.BRANCH_FORWARD_RD(BRANCH_FORWARD_RD),
	.ALU_OUT(ALU_OUT),
	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.MEMWB_ALU_OUT(MEMWB_ALU_OUT)
	);*/
	BRANCH CONT3(
	.FLUSH_IFID(FLUSH_IFID),
	.FLUSH_IDEX(FLUSH_IDEX),
	.FLUSH_EXMEM(FLUSH_EXMEM),
	.SEL(PC_SEL),
	.IFID_OPCODE(IFID_OPCODE),
	.EXMEM_OPCODE(EXMEM_OPCODE)
	);

	WRITE_CONTROL CONT4 (
	.RW_ENABLE(RW_ENABLE), 		//RAM
	.DATA_ADDR(DATA_ADDR),		//RAM READ 	ADDRESS
	.RAM_W_ADDR(RAM_W_ADDR),		//RAM WRITE ADDRESS
	.RAM_W_DATA(RAM_W_DATA), 	//RAM WRITE DATA
	.W_ENABLE(W_ENABLE),		//REGISTER_FILE
	.REG_W_ADDR(REG_W_ADDR),		//REG WRITE ADDRESS
	.REG_W_DATA(REG_W_DATA),		//REG WRITE DATA
	.IDEX_RD_DATA(IDEX_RD_DATA),	//RAM W_DATA
	.IDEX_R1_ADDR(IDEX_R1_ADDR),	//MEMORY ADDRESS
	.IDEX_R2_ADDR(IDEX_R2_ADDR),	//MEMORY ADDRESS
	.IDEX_OPCODE(IDEX_OPCODE),	//RAM
	.MEMWB_RD_ADDR(MEMWB_RD_ADDR),	
	.MEMWB_R_DATA(MEMWB_R_DATA),
	.MEMWB_R1_ADDR(MEMWB_R1_ADDR),
	.MEMWB_R2_ADDR(MEMWB_R2_ADDR),
	.MEMWB_ALU_OUT(MEMWB_ALU_OUT),
	.MEMWB_OPCODE(MEMWB_OPCODE),	//REGISTER_FILE

	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.R_DATA(R_DATA),
	.EXMEM_R1_ADDR(EXMEM_R1_ADDR),
	.EXMEM_R2_ADDR(EXMEM_R2_ADDR),
	.RAM_FORWARD(RAM_FORWARD)


	//.JUMP_FORWARD(JUMP_FORWARD)
	);

	ALU ALU0 (
	.ALU_OUT(ALU_OUT),
	.CARRY_FLAG(CARRY_FLAG),
	.IDEX_OPCODE(IDEX_OPCODE),
	.IDEX_R1_DATA(IDEX_R1_DATA),
	.IDEX_R2_DATA(IDEX_R2_DATA),
	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.MEMWB_ALU_OUT(MEMWB_ALU_OUT),
	.FORWARD_A(ALU_FORWARD_R1), //FORWARDING ALU_FORWARD_R1
	.FORWARD_B(ALU_FORWARD_R2),	//FORWARDING ALU_FORWARD_R2

	.R_DATA(R_DATA),
	.EXMEM_R1_ADDR(EXMEM_R1_ADDR),
	.EXMEM_R2_ADDR(EXMEM_R2_ADDR),
	.MEMWB_R_DATA(MEMWB_R_DATA),
	.MEMWB_R1_ADDR(MEMWB_R1_ADDR),
	.MEMWB_R2_ADDR(MEMWB_R2_ADDR)
	);

	IFID P0 (
	.IFID_OPCODE(IFID_OPCODE),
	.IFID_RD_ADDR(IFID_RD_ADDR),
	.IFID_R1_ADDR(IFID_R1_ADDR),
	.IFID_R2_ADDR(IFID_R2_ADDR),
	.INST_OPCODE(INST_OPCODE),
	.INST_RD_ADDR(INST_RD_ADDR),
	.INST_R1_ADDR(INST_R1_ADDR),
	.INST_R2_ADDR(INST_R2_ADDR),
	.FLUSH(FLUSH_IFID),
//	.STALL(STALL),
	.rst(rst),
	.clk(clk)//,
  //      .STALL_OPCODE(STALL_OPCODE),
//	.STALL_RD_ADDR(STALL_RD_ADDR),
//	.STALL_R1_ADDR(STALL_R1_ADDR),
//	.STALL_R2_ADDR(STALL_R2_ADDR)

	);

	IDEX P1 (
	.IDEX_OPCODE(IDEX_OPCODE),
	.IDEX_RD_ADDR(IDEX_RD_ADDR),
	.IDEX_R1_ADDR(IDEX_R1_ADDR),
	.IDEX_R2_ADDR(IDEX_R2_ADDR),
	.IDEX_RD_DATA(IDEX_RD_DATA),
	.IDEX_R1_DATA(IDEX_R1_DATA),
	.IDEX_R2_DATA(IDEX_R2_DATA),
	.IFID_OPCODE(IFID_OPCODE),
	.IFID_RD_ADDR(IFID_RD_ADDR),
	.IFID_R1_ADDR(IFID_R1_ADDR),
	.IFID_R2_ADDR(IFID_R2_ADDR),
	.RD_DATA(RD_DATA),
	.R1_DATA(R1_DATA),
	.R2_DATA(R2_DATA),
	.FLUSH(FLUSH_IDEX),
	.STALL(STALL),
	.rst(rst),
	.clk(clk),

	.STALL_OPCODE(STALL_OPCODE),
	.STALL_RD_ADDR(STALL_RD_ADDR),
	.STALL_R1_ADDR(STALL_R1_ADDR),
	.STALL_R2_ADDR(STALL_R2_ADDR)
	);

	EXMEM P2 (
	.EXMEM_OPCODE(EXMEM_OPCODE),
	.EXMEM_RD_ADDR(EXMEM_RD_ADDR),
	.EXMEM_R1_ADDR(EXMEM_R1_ADDR),
	.EXMEM_R2_ADDR(EXMEM_R2_ADDR),
	.EXMEM_RD_DATA(EXMEM_RD_DATA),
	//.EXMEM_R1_DATA(EXMEM_R1_DATA),
	//.EXMEM_R2_DATA(EXMEM_R2_DATA),
	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.IDEX_OPCODE(IDEX_OPCODE),
	.IDEX_RD_ADDR(IDEX_RD_ADDR),
	.IDEX_R1_ADDR(IDEX_R1_ADDR),
	.IDEX_R2_ADDR(IDEX_R2_ADDR),
	.IDEX_RD_DATA(IDEX_RD_DATA),
	//.IDEX_R1_DATA(IDEX_R1_DATA),
	//.IDEX_R2_DATA(IDEX_R2_DATA),
	.ALU_OUT(ALU_OUT),
	.FLUSH(FLUSH_EXMEM),
	.rst(rst),
	.clk(clk)
	);

	MEMWB P3(
	.MEMWB_OPCODE(MEMWB_OPCODE),
	.MEMWB_RD_ADDR(MEMWB_RD_ADDR),
	.MEMWB_R1_ADDR(MEMWB_R1_ADDR),
	.MEMWB_R2_ADDR(MEMWB_R2_ADDR),
	//.MEMWB_RD_DATA(MEMWB_RD_DATA),
	//.MEMWB_R1_DATA(MEMWB_R1_DATA),
	//.MEMWB_R2_DATA(MEMWB_R2_DATA),
	.MEMWB_ALU_OUT(MEMWB_ALU_OUT),
	.MEMWB_R_DATA(MEMWB_R_DATA),
	.EXMEM_OPCODE(EXMEM_OPCODE),
	.EXMEM_RD_ADDR(EXMEM_RD_ADDR),
	.EXMEM_R1_ADDR(EXMEM_R1_ADDR),
	.EXMEM_R2_ADDR(EXMEM_R2_ADDR),
	// .EXMEM_RD_DATA(EXMEM_RD_DATA),
	// .EXMEM_R1_DATA(EXMEM_R1_DATA),
	// .EXMEM_R2_DATA(EXMEM_R2_DATA),
	.R_DATA(R_DATA), //data read from RAM
	.EXMEM_ALU_OUT(EXMEM_ALU_OUT),
	.rst(rst),
	.clk(clk)
	);

assign INST_OPCODE = INSTRUCTION[15:11];
assign INST_RD_ADDR = INSTRUCTION[10:8];
assign INST_R1_ADDR = INSTRUCTION[7:4];
assign INST_R2_ADDR = INSTRUCTION[3:0];

endmodule 
