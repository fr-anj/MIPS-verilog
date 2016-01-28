module STALLING (
	output 	reg			STALL,
	input 		[2:0] 	IFID_R1_ADDR,
	input 		[2:0] 	IFID_R2_ADDR,
	input 		[2:0] 	IDEX_RD_ADDR,
	input 		[4:0] 	IDEX_OPCODE,

	output	reg	[4:0]	STALL_OPCODE,
	output	reg	[2:0]	STALL_RD_ADDR,
	output 	reg	[3:0]	STALL_R1_ADDR,
	output 	reg	[3:0] 	STALL_R2_ADDR,

	input 		[4:0]	IFID_OPCODE
	);

	parameter 			jr 		= 5'b11000,
						load 	= 5'b11010;

	always @(*)
/*		if 	(IDEX_OPCODE == load)			
			 begin
			STALL = 1;
			STALL_OPCODE  = 5'h1f;
			STALL_RD_ADDR = 3'b111;
			STALL_R1_ADDR = 4'b1111;
			STALL_R2_ADDR = 4'b1111;
			end 
		else */if (/*(IFID_R1_ADDR == IDEX_RD_ADDR || IFID_R2_ADDR == IDEX_RD_ADDR ) && */IDEX_OPCODE == load)
				begin
				 STALL = 1;
				 STALL_OPCODE  = 5'h1f;
				 STALL_RD_ADDR = 3'b111;
				 STALL_R1_ADDR = 4'b1111;
				 STALL_R2_ADDR = 4'b1111;
				end 
			 // else 
			 // 	begin
			 // 	STALL = 0;
			 // 	STALL_OPCODE  = 5'h00;
			 // 	STALL_RD_ADDR = 3'b000;
			 // 	STALL_R1_ADDR = 4'b0000;
			 // 	STALL_R2_ADDR = 4'b0000;
			 // 	end
		else
			begin
			STALL = 0;
			STALL_OPCODE  = 5'h00;	
			STALL_RD_ADDR = 3'b000;
			STALL_R1_ADDR = 4'b0000;
			STALL_R2_ADDR = 4'b0000;
			end

endmodule