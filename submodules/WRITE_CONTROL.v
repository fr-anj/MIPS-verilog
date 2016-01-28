module WRITE_CONTROL (
	output reg 			RW_ENABLE, 		//RAM
	output reg 	[7:0]	DATA_ADDR,		//RAM READ 	ADDRESS
	output reg 	[7:0]	RAM_W_ADDR,		//RAM WRITE ADDRESS
	output reg 	[7:0]	RAM_W_DATA, 	//RAM WRITE DATA
	output reg 			W_ENABLE,		//REGISTER_FILE
	output reg 	[2:0]	REG_W_ADDR,		//REG WRITE ADDRESS
	output reg 	[7:0]	REG_W_DATA,		//REG WRITE DATA
	input 		[7:0]	IDEX_RD_DATA,	//RAM W_DATA
	input 		[3:0]	IDEX_R1_ADDR,	//MEMORY ADDRESS
	input		[3:0]	IDEX_R2_ADDR,	//MEMORY ADDRESS
	input 		[4:0]	IDEX_OPCODE,	//RAM
	input		[2:0]	MEMWB_RD_ADDR,	
	input		[7:0]	MEMWB_R_DATA,
	input		[3:0]	MEMWB_R1_ADDR,
	input		[3:0]	MEMWB_R2_ADDR,
	input		[7:0]	MEMWB_ALU_OUT,
	input 		[4:0]	MEMWB_OPCODE,	//REGISTER_FILE

	input 		[7:0]	EXMEM_ALU_OUT,
	input 		[7:0]	R_DATA,
	input 		[3:0]	EXMEM_R1_ADDR,
	input 		[3:0]	EXMEM_R2_ADDR,
	input 		[2:0]	RAM_FORWARD		///*TODO: needs EXMEM/MEMWB RD_DATA*/	

	//input 				JUMP_FORWARD
	);

	parameter 	bne 	= 5'b10011, 
				be 		= 5'b10100, 
				j 		= 5'b10111, 
				bner	= 5'b10101,
		 		ber 	= 5'b10110, 
		 		jr		= 5'b11000,
		 		load 	= 5'b11010,
		 		li		= 5'B11001,
		 		store 	= 5'b11011,
		 		nop		= 5'h1f;					 

always @(*)
	case (IDEX_OPCODE)
		j:	
			begin
			RW_ENABLE 	= 0;
			DATA_ADDR = {IDEX_R1_ADDR,IDEX_R2_ADDR};
			// endcase
			RAM_W_ADDR 	= 0;
			RAM_W_DATA 	= 0;	
			end
		be:
			begin
			RW_ENABLE 	= 0;
			DATA_ADDR 	= {IDEX_R1_ADDR,IDEX_R2_ADDR};
			RAM_W_ADDR 	= 0;
			RAM_W_DATA 	= 0;	
			end
		bne:
			begin
			RW_ENABLE 	= 0;
			DATA_ADDR	= {IDEX_R1_ADDR,IDEX_R2_ADDR};
			RAM_W_ADDR 	= 0;
			RAM_W_DATA 	= 0;	
			end
		load: 		
			begin
			RW_ENABLE 	= 0;
			DATA_ADDR 	= {IDEX_R1_ADDR,IDEX_R2_ADDR};
			RAM_W_ADDR 	= 0;
			RAM_W_DATA 	= 0;
			end
		store: 		
			begin
			RW_ENABLE 	= 1;
			DATA_ADDR 	= 0;
			RAM_W_ADDR 	= {IDEX_R1_ADDR,IDEX_R2_ADDR};
			//RAM_W_DATA	= IDEX_RD_DATA;	/*TODO: insert forwarded data here*/
			if (RAM_FORWARD == 3'b001)
				RAM_W_DATA = EXMEM_ALU_OUT;
			else if (RAM_FORWARD == 3'b010)
				RAM_W_DATA = R_DATA;
			else if (RAM_FORWARD == 3'b011)
				RAM_W_DATA = {EXMEM_R1_ADDR,EXMEM_R2_ADDR};
			else if (RAM_FORWARD == 3'b101)
				RAM_W_DATA = MEMWB_ALU_OUT;
			else if (RAM_FORWARD == 3'b110)
				RAM_W_DATA = MEMWB_R_DATA;
			else if (RAM_FORWARD == 3'b111)
				RAM_W_DATA = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
			else 
				RAM_W_DATA = IDEX_RD_DATA;
			end
		default: 	
			begin
			RW_ENABLE 	= 0;
			DATA_ADDR	= 0;
			RAM_W_ADDR 	= 0;
			RAM_W_DATA	= 0;
			end
	endcase

always @(*)
	case (MEMWB_OPCODE)
		bne:		
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		be:			
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		j:			
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		bner:		
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		ber:		
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		jr:			
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		load:		
			begin
			W_ENABLE	= 1;
			REG_W_ADDR	= MEMWB_RD_ADDR;
			REG_W_DATA	= MEMWB_R_DATA;
			end
		li:			
			begin
			W_ENABLE	= 1;
			REG_W_ADDR	= MEMWB_RD_ADDR;
			REG_W_DATA	= {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
			end
		store:		
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		nop:		
			begin
			W_ENABLE	= 0;
			REG_W_ADDR  = 0;
			REG_W_DATA	= 0;
			end
		default:	
			begin
			W_ENABLE	= 1;
			REG_W_ADDR	= MEMWB_RD_ADDR;
			REG_W_DATA	= MEMWB_ALU_OUT;
			end
	endcase
endmodule