module BRANCH (
	output reg			FLUSH_IFID,
	output reg			FLUSH_IDEX,
	output reg			FLUSH_EXMEM,
	input 		[1:0]	SEL,
	input 		[4:0]	IFID_OPCODE,
	input 		[4:0]	EXMEM_OPCODE
	);
	
	parameter 	j		= 5'b10111,
				be 		= 5'b10100,
				bne 	= 5'b10011,
				jr 		= 5'b11000,
				ber    	= 5'b10110,
				bner	= 5'b10101;

/*TODO: revise code, dapat mag-agad sa SEL sa PC gikan sa JPBR_CONTROL*/

always @(*)
	if (SEL != 0)
		if (EXMEM_OPCODE == j || EXMEM_OPCODE == be || EXMEM_OPCODE == bne)
			begin
			FLUSH_IFID 	= 1;
			FLUSH_IDEX 	= 1;
			FLUSH_EXMEM = 1;
			end
		else if (IFID_OPCODE == jr || IFID_OPCODE == ber || IFID_OPCODE == bner)
			begin
			FLUSH_IFID 	= 1;
			FLUSH_IDEX 	= 0;
			FLUSH_EXMEM = 0;
			end
		else 
			begin
			FLUSH_IFID 	= 0;
			FLUSH_IDEX 	= 0;
			FLUSH_EXMEM = 0;
			end
	else 
		begin
		FLUSH_IFID 	= 0;
		FLUSH_IDEX 	= 0;
		FLUSH_EXMEM = 0;
		end

endmodule