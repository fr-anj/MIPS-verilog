module IFID (
	output 	[4:0]	IFID_OPCODE,
	output 	[2:0]	IFID_RD_ADDR,
	output 	[3:0]	IFID_R1_ADDR,
	output 	[3:0]	IFID_R2_ADDR,
	input 	[4:0]	INST_OPCODE,
	input 	[2:0]	INST_RD_ADDR,
	input 	[3:0]	INST_R1_ADDR,
	input 	[3:0]	INST_R2_ADDR,
	//input			STALL,
	input 			FLUSH,
	input			rst,
	input			clk);


	reg		[4:0]	opcode;
	reg 	[2:0]	rd_addr;
	reg 	[3:0] 	r1_addr;
	reg 	[3:0]	r2_addr;

always @(posedge clk)
	if (rst) begin
		opcode 	<= 5'h1f;
		rd_addr <= 0;
		r1_addr <= 0;
		r2_addr <= 0;
	end
	else begin
		if (FLUSH) begin
			opcode 	<= 5'h1f;
			rd_addr <= 0;
			r1_addr <= 0;
			r2_addr <= 0;
		end
		// else if (STALL) begin
		// 	opcode 	<= opcode;
		// 	rd_addr <= rd_addr;
		// 	r1_addr <= r1_addr;
		// 	r2_addr <= r2_addr;
		// end
		else begin
			opcode 	<= INST_OPCODE;
			rd_addr <= INST_RD_ADDR;
			r1_addr <= INST_R1_ADDR;
			r2_addr <= INST_R2_ADDR;
		end
	end 

assign IFID_OPCODE 	= opcode;/*(STALL)? 5'h1f : opcode;*/
assign IFID_RD_ADDR = rd_addr;/*(STALL)? 0 : rd_addr;*/
assign IFID_R1_ADDR = r1_addr;/*(STALL)? 0 : r1_addr;*/
assign IFID_R2_ADDR = r2_addr;/*(STALL)? 0 : r2_addr;*/
endmodule
