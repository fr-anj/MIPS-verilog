module FORWARDING (
	output reg	[2:0] 	ALU_FORWARD_R1,
	output reg	[2:0] 	ALU_FORWARD_R2,
	output reg	[3:0] 	BRANCH_FORWARD_RD,
	output reg	[3:0] 	BRANCH_FORWARD_R2,
	input 		[2:0] 	EXMEM_RD_ADDR,
	input 		[2:0] 	MEMWB_RD_ADDR,
	input		[4:0] 	IDEX_OPCODE,
	input 		[4:0] 	IFID_OPCODE,
	input 		[2:0] 	IDEX_RD_ADDR,
	input 		[2:0] 	IDEX_R1_ADDR,
	input 		[2:0] 	IDEX_R2_ADDR,
	input 		[2:0] 	IFID_RD_ADDR,
	input 		[2:0] 	IFID_R2_ADDR,

	input 		[4:0]	EXMEM_OPCODE,
	input 		[3:0]	EXMEM_R1_ADDR,
	input 		[3:0]	EXMEM_R2_ADDR,
	input 		[4:0]	MEMWB_OPCODE,
	input 		[3:0]	MEMWB_R1_ADDR,
	input 		[3:0]	MEMWB_R2_ADDR,
	output reg 	[2:0]	RAM_FORWARD,
	output reg	[1:0]	MEMBR_FORWARD
	);
	//input 		[]);

	parameter 			
						bne		= 5'b10011,
						be		= 5'b10100,
						j		= 5'b10111,
						bner	= 5'b10101,
						ber		= 5'b10110,
						jr		= 5'b11000,
						li		= 5'b11001,
						load 	= 5'b11010, 
						store 	= 5'b11011;			

always @(*)
	if ((EXMEM_OPCODE == be) || (EXMEM_OPCODE == bne))
		if (EXMEM_RD_ADDR == MEMWB_RD_ADDR)
			case (MEMWB_OPCODE)
			j:
				MEMBR_FORWARD = 2'b00; 
			be:
				MEMBR_FORWARD = 2'b00;
			bne:
				MEMBR_FORWARD = 2'b00;
			jr:
				MEMBR_FORWARD = 2'b00;
			ber:
				MEMBR_FORWARD = 2'b00;
			bner:
				MEMBR_FORWARD = 2'b00;
			li:
				MEMBR_FORWARD = 2'b11;//{MEMWB_R1_ADDR,MEMWB_R2_ADDR}
			load:
				MEMBR_FORWARD = 2'b10;//MEMWB_R_DATA
			store:
				MEMBR_FORWARD = 2'b00;
			default:
				MEMBR_FORWARD = 2'b01;//MEM_ALU_OUT
			endcase
		else 
				MEMBR_FORWARD = 2'b00;
	else 
				MEMBR_FORWARD = 2'b00;


always @(*)
	if (IDEX_OPCODE == store)
		if (IDEX_RD_ADDR == EXMEM_RD_ADDR)
			case (EXMEM_OPCODE)
			load:
				RAM_FORWARD = 3'b010;	//R_DATA from RAM
			li: 
				RAM_FORWARD = 3'b011;	//{EXMEM_R1_ADDR,EXMEM_R2_ADDR}
			j: 
				RAM_FORWARD = 3'b000;
			be: 
				RAM_FORWARD = 3'b000;
			bne: 
				RAM_FORWARD = 3'b000;	
 			store: 
 				RAM_FORWARD = 3'b000;
			default:
				RAM_FORWARD = 3'b001;	//EXMEM_ALU_OUT
			endcase
		else if (IDEX_RD_ADDR == MEMWB_RD_ADDR)
			case (MEMWB_OPCODE)
			load:
				RAM_FORWARD = 3'b110;	//MEMWB_R_DATA
			li: 
				RAM_FORWARD = 3'b111;	//{MEMWB_R1_ADDR,MEMWB_R2_ADDR}
			j: 
				RAM_FORWARD = 3'b000;
			be: 
				RAM_FORWARD = 3'b000;
			bne: 
				RAM_FORWARD = 3'b000;	
 			store: 
 				RAM_FORWARD = 3'b000;
			default:
				RAM_FORWARD = 3'b101;	//MEMWB_ALU_OUT
			endcase
		else 
			RAM_FORWARD = 3'b000;
	else 
			RAM_FORWARD = 3'b000;

/*always @(*)
	if (IDEX_OPCODE != j && IDEX_OPCODE != bne && IDEX_OPCODE != be && IDEX_OPCODE != store)
		if (IDEX_R1_ADDR == EXMEM_RD_ADDR)
			ALU_FORWARD_R1 = 2'b01;
		else if (IDEX_R1_ADDR == MEMWB_RD_ADDR)
			ALU_FORWARD_R1 = 2'b10;
		else
			ALU_FORWARD_R1 = 2'b00;
	else 
			ALU_FORWARD_R1 = 2'b00;*/

/*TODO: ALU_FORWARD for Load and Load Immediate on EXMEM_OPCODE and MEMWB_OPCODE*/
/*TODO: Make sure to change bit-width of ALU_FORWARD_R1 and ALU_FORWARD_RD*/
/*TODO: UPDATE!!! ALU.v*/

always @(*)
	if (IDEX_R1_ADDR == EXMEM_RD_ADDR)
		case (EXMEM_OPCODE)
		j:
			ALU_FORWARD_R1 = 3'b000;			
		be:
			ALU_FORWARD_R1 = 3'b000;
		bne:
			ALU_FORWARD_R1 = 3'b000;
		li:
			ALU_FORWARD_R1 = 3'b001;	//{EXMEM_R1_ADDR,EXMEM_R1_ADDR}
		load:
			ALU_FORWARD_R1 = 3'b010;	//R_DATA from RAM
		store:
			ALU_FORWARD_R1 = 3'b000;
		default:
			ALU_FORWARD_R1 = 3'b011;	//EXMEM_ALU_OUT
		endcase
	else if (IDEX_R1_ADDR == MEMWB_RD_ADDR)
		case (MEMWB_OPCODE)
		li:			
			ALU_FORWARD_R1 = 3'b101;	//{MEMWB_R1_ADDR,MEMWB_R2_ADDR}
		load:		
			ALU_FORWARD_R1 = 3'b110;	//MEMWB_R_DATA 
		store:		
			ALU_FORWARD_R1 = 3'b000;
		default:	
			ALU_FORWARD_R1 = 3'b111;	//MEMWB_ALU_OUT
		endcase
	else 
			ALU_FORWARD_R1 = 3'b000;

always @(*)
	if (IDEX_R2_ADDR == EXMEM_RD_ADDR)
		case (EXMEM_OPCODE)
		j:
			ALU_FORWARD_R2 = 3'b000;			
		be:
			ALU_FORWARD_R2 = 3'b000;
		bne:
			ALU_FORWARD_R2 = 3'b000;
		li:
			ALU_FORWARD_R2 = 3'b001;	//{EXMEM_R1_ADDR,EXMEM_R1_ADDR}
		load:
			ALU_FORWARD_R2 = 3'b010;	//R_DATA from RAM
		store:
			ALU_FORWARD_R2 = 3'b000;
		default:
			ALU_FORWARD_R2 = 3'b011;	//EXMEM_ALU_OUT
		endcase
	else if (IDEX_R2_ADDR == MEMWB_RD_ADDR)
		case (MEMWB_OPCODE)
		li:			
			ALU_FORWARD_R2 = 3'b101;	//{MEMWB_R1_ADDR,MEMWB_R2_ADDR}
		load:		
			ALU_FORWARD_R2 = 3'b110;	//MEMWB_R_DATA 
		store:		
			ALU_FORWARD_R2 = 3'b000;
		default:	
			ALU_FORWARD_R2 = 3'b111;	//MEMWB_ALU_OUT
		endcase
	else 
			ALU_FORWARD_R2 = 3'b000;

always @(*) /*TODO: consider load immediate to forward */
	if ((IFID_OPCODE == bner) || (IFID_OPCODE == ber))
/*		if(IFID_RD_ADDR == IDEX_RD_ADDR)
			BRANCH_FORWARD_RD = 2'b01;	//ALU_OUT from ALU
		else if(IFID_RD_ADDR == EXMEM_RD_ADDR)
			BRANCH_FORWARD_RD = 2'b10;
		else if(IFID_RD_ADDR == MEMWB_RD_ADDR)
			BRANCH_FORWARD_RD = 2'b11;
		else
			BRANCH_FORWARD_RD = 2'b00;
	else 
			BRANCH_FORWARD_RD = 2'b00;*/
				if (IFID_RD_ADDR == IDEX_RD_ADDR)
			case (IDEX_OPCODE)
			j:
				BRANCH_FORWARD_RD = 4'b0000;
			be:
				BRANCH_FORWARD_RD = 4'b0000;
			bne:
				BRANCH_FORWARD_RD = 4'b0000;
			jr:
				BRANCH_FORWARD_RD = 4'b0000;
			ber:
				BRANCH_FORWARD_RD = 4'b0000;
			bner:
				BRANCH_FORWARD_RD = 4'b0000;
			li:
				BRANCH_FORWARD_RD = 4'b0010;//{IDEX_R1_ADDR,IDEX_R2_ADDR}
			load:
				BRANCH_FORWARD_RD = 4'b0000;
			store:
				BRANCH_FORWARD_RD = 4'b0000;
			default:
				BRANCH_FORWARD_RD = 4'b0001;//ALU_OUT
			endcase
		else if (IFID_RD_ADDR == EXMEM_RD_ADDR)
			case (EXMEM_OPCODE)
			j:
				BRANCH_FORWARD_RD= 4'b0000; 
			be:
				BRANCH_FORWARD_RD= 4'b0000;
			bne:
				BRANCH_FORWARD_RD= 4'b0000;
			jr:
				BRANCH_FORWARD_RD= 4'b0000;
			ber:
				BRANCH_FORWARD_RD= 4'b0000;
			bner:
				BRANCH_FORWARD_RD= 4'b0000;
			li:
				BRANCH_FORWARD_RD= 4'b0111;//{EXMEM_R1_ADDR,EXMEM_R2_ADDR}
			load:
				BRANCH_FORWARD_RD= 4'b0110;//R_DATA
			store:
				BRANCH_FORWARD_RD= 4'b0000;
			default:
				BRANCH_FORWARD_RD= 4'b0101;//EXMEM_ALU_OUT
			endcase
		else if (IFID_RD_ADDR == MEMWB_RD_ADDR)
			case (EXMEM_OPCODE)
			j:
				BRANCH_FORWARD_RD = 4'b0000; 
			be:
				BRANCH_FORWARD_RD = 4'b0000;
			bne:
				BRANCH_FORWARD_RD = 4'b0000;
			jr:
				BRANCH_FORWARD_RD = 4'b0000;
			ber:
				BRANCH_FORWARD_RD = 4'b0000;
			bner:
				BRANCH_FORWARD_RD = 4'b0000;
			li:
				BRANCH_FORWARD_RD = 4'b1011;//{MEMWB_R1_ADDR,MEMWB_R2_ADDR}
			load:
				BRANCH_FORWARD_RD = 4'b1010;//MEMWB_R_DATA
			store:
				BRANCH_FORWARD_RD = 4'b0000;
			default:
				BRANCH_FORWARD_RD = 4'b1001;//MEMWB_ALU_OUT
			endcase
		else 
				BRANCH_FORWARD_RD = 4'b0000;
	else 
				BRANCH_FORWARD_RD = 4'b0000;

always @(*)
	if ((IFID_OPCODE == bner) || (IFID_OPCODE == ber) || (IFID_OPCODE == jr))
		if ((IFID_R2_ADDR == IDEX_RD_ADDR) && (IDEX_OPCODE != store))
			case (IDEX_OPCODE)
			j:
				BRANCH_FORWARD_R2 = 4'b0000;
			be:
				BRANCH_FORWARD_R2 = 4'b0000;
			bne:
				BRANCH_FORWARD_R2 = 4'b0000;
			jr:
				BRANCH_FORWARD_R2 = 4'b0000;
			ber:
				BRANCH_FORWARD_R2 = 4'b0000;
			bner:
				BRANCH_FORWARD_R2 = 4'b0000;
			li:
				BRANCH_FORWARD_R2 = 4'b0010;//{IDEX_R1_ADDR,IDEX_R2_ADDR} 
			load:
				BRANCH_FORWARD_R2 = 4'b0000;
			/*store:
				BRANCH_FORWARD_R2 = 4'b0000;*/
			default:
				BRANCH_FORWARD_R2 = 4'b0001;//ALU_OUT
			endcase
		else if ((IFID_R2_ADDR == EXMEM_RD_ADDR) && (EXMEM_OPCODE != store))
			case (EXMEM_OPCODE)
			j:
				BRANCH_FORWARD_R2 = 4'b0000; 
			be:
				BRANCH_FORWARD_R2 = 4'b0000;
			bne:
				BRANCH_FORWARD_R2 = 4'b0000;
			jr:
				BRANCH_FORWARD_R2 = 4'b0000;
			ber:
				BRANCH_FORWARD_R2= 4'b0000;
			bner:
				BRANCH_FORWARD_R2= 4'b0000;
			li:
				BRANCH_FORWARD_R2= 4'b0111;//{EXMEM_R1_ADDR,EXMEM_R2_ADDR}
			load:
				BRANCH_FORWARD_R2= 4'b0110;//R_DATA
			/*store:
				BRANCH_FORWARD_R2= 4'b0000;*/
			5'h1f:
				BRANCH_FORWARD_R2 = 4'b0000;
			default:
				BRANCH_FORWARD_R2= 4'b0101;//EXMEM_ALU_OUT
			endcase
		else if ((IFID_R2_ADDR == MEMWB_RD_ADDR) && (MEMWB_OPCODE != store))
			case (MEMWB_OPCODE)
			j:
				BRANCH_FORWARD_R2 = 4'b0000; 
			be:
				BRANCH_FORWARD_R2 = 4'b0000;
			bne:
				BRANCH_FORWARD_R2 = 4'b0000;
			jr:
				BRANCH_FORWARD_R2 = 4'b0000;
			ber:
				BRANCH_FORWARD_R2 = 4'b0000;
			bner:
				BRANCH_FORWARD_R2 = 4'b0000;
			li:
				BRANCH_FORWARD_R2 = 4'b1011;//{MEMWB_R1_ADDR,MEMWB_R2_ADDR}
			load:
				BRANCH_FORWARD_R2 = 4'b1010;//MEMWB_R_DATA
			store:
				BRANCH_FORWARD_R2 = 4'b0000;
			default:
				BRANCH_FORWARD_R2 = 4'b1001;//MEMWB_ALU_OUT
			endcase
		else 
				BRANCH_FORWARD_R2 = 4'b0000;
	else 
				BRANCH_FORWARD_R2 = 4'b0000;
endmodule