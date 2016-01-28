module JPBR_CONTROL (
	output reg 	[1:0] 	SEL,
	output reg 	[7:0]	BRANCH_ADDR,
	output reg 	[7:0] 	JUMP_ADDR,
	input 		[4:0]	IFID_OPCODE,
	input 		[4:0] 	EXMEM_OPCODE,	
	input 		[7:0]	REG_ADDR,

	input		[3:0]	BRANCH_FORWARD_R2,
	input 		[7:0]	ALU_OUT,
	input 		[7:0]	EXMEM_ALU_OUT,
	input 		[7:0]	MEMWB_ALU_OUT,

	output reg					JUMP_FORWARD,
	input 		[7:0]	R_DATA,
	input 		[7:0]	MEMWB_R_DATA,

	input 		[1:0]	MEMBR_FORWARD,
	input 		[3:0] 	BRANCH_FORWARD_RD,
	input 		[3:0]	MEMWB_R1_ADDR,
	input 		[3:0]	MEMWB_R2_ADDR,
	input 		[7:0]	EXMEM_RD_DATA,
	input 		[3:0]	EXMEM_R1_ADDR,
	input 		[3:0]	EXMEM_R2_ADDR,
	input 		[3:0]	IDEX_R1_ADDR,
	input 		[3:0]	IDEX_R2_ADDR,
	input 		[7:0]	RD_DATA

	); 	//REGISTER_FILE R2_DATA

	parameter 		bne 	= 5'b10011,
					be 		= 5'b10100,
					bner	= 5'b10101,
					ber    	= 5'b10110,
					j 		= 5'b10111,
					jr 		= 5'b11000,
					li		= 5'b11001,
					load	= 5'b11010,
					store	= 5'b11011;	

	parameter		ideximm 	= 4'b0010, 
					idex 		= 4'b0001, 
					exmemload 	= 4'b0110, 
					exmemimm 	= 4'b0111, 
					exmem 		= 4'b0101,
					memwbload 	= 4'b1010,
					memwbimm 	= 4'b1011,
					memwb 		= 4'b1001,
					no_forward	= 4'b0000;
reg [7:0] RD;
reg [7:0] MEM_RD;

always @(*)
	case (MEMBR_FORWARD)
	2'b01:
		MEM_RD = MEMWB_ALU_OUT;
	2'b10:
		MEM_RD = MEMWB_R_DATA;
	2'b11:
		MEM_RD = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
	default:
		MEM_RD = EXMEM_RD_DATA;
	endcase

always @(*)
	case (BRANCH_FORWARD_RD)
	4'b0001:
		RD = ALU_OUT;
	4'b0010:
		RD = {IDEX_R1_ADDR,IDEX_R2_ADDR};
	4'b0101:
		RD = EXMEM_ALU_OUT;
	4'b0110:
		RD = R_DATA;
	4'b0111:
		RD = {EXMEM_R1_ADDR,EXMEM_R2_ADDR};
	4'b1001:
		RD = MEMWB_ALU_OUT;
	4'b1010:
		RD = MEMWB_R_DATA;
	4'b1011:
		RD = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
	default:
		RD = RD_DATA;
	endcase

always @(*)
    if (EXMEM_OPCODE == j)
        SEL = 2;
    else if (EXMEM_OPCODE == be)
        if (MEM_RD == 0)
            SEL = 1;
        else 
            SEL = 0;
    else if (EXMEM_OPCODE == bne)
        if (MEM_RD != 0)
            SEL = 1;
        else 
            SEL = 0;
    else if (IFID_OPCODE == jr)
        SEL = 2;
    else if (IFID_OPCODE == ber)
        if (RD == 0)
            SEL = 1;
        else 
            SEL = 0;
    else if (IFID_OPCODE == bner)
        if (RD != 0)
            SEL = 1;
        else
            SEL = 0;
    else 
        SEL = 0;

always @(*)
    if (EXMEM_OPCODE == j)
        JUMP_ADDR = R_DATA;
    else if (IFID_OPCODE == jr)
        case (BRANCH_FORWARD_R2)
        ideximm:
                JUMP_ADDR = {IDEX_R1_ADDR,IDEX_R2_ADDR};
        idex:
                JUMP_ADDR = ALU_OUT;
        exmemload:
                JUMP_ADDR = R_DATA;
        exmemimm:
                JUMP_ADDR = {EXMEM_R1_ADDR,EXMEM_R2_ADDR};
        exmem:
                JUMP_ADDR = EXMEM_ALU_OUT;
        memwbload:
                JUMP_ADDR = MEMWB_R_DATA;
        memwbimm:
                JUMP_ADDR = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
        memwb:
                JUMP_ADDR = MEMWB_ALU_OUT;
        default:
                JUMP_ADDR = REG_ADDR;
        endcase
    else
        JUMP_ADDR = 0;

always @(*)
    if(EXMEM_OPCODE == bne || EXMEM_OPCODE == be)
        BRANCH_ADDR = R_DATA;
    else if (IFID_OPCODE == ber || IFID_OPCODE == bner)
        case (BRANCH_FORWARD_R2)
        ideximm:
            BRANCH_ADDR = {IDEX_R1_ADDR,IDEX_R2_ADDR};
        idex:
            BRANCH_ADDR = ALU_OUT;
        exmemload:
            BRANCH_ADDR = R_DATA;
        exmemimm:
            BRANCH_ADDR = {EXMEM_R1_ADDR,EXMEM_R2_ADDR};
        exmem:
            BRANCH_ADDR = EXMEM_ALU_OUT;
        memwbload:
            BRANCH_ADDR = MEMWB_R_DATA;
        memwbimm:
            BRANCH_ADDR = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
        memwb:
            BRANCH_ADDR = MEMWB_ALU_OUT;
        default:
            BRANCH_ADDR = REG_ADDR;
        endcase
    else 
        BRANCH_ADDR = 0;

endmodule
