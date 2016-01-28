module EXMEM (
	output	[4:0]	EXMEM_OPCODE,
	output 	[2:0]	EXMEM_RD_ADDR,
	output 	[3:0]	EXMEM_R1_ADDR,
	output	[3:0]	EXMEM_R2_ADDR,
	output	[7:0]	EXMEM_RD_DATA,
	// output	[7:0]	EXMEM_R1_DATA,
	// output	[7:0]	EXMEM_R2_DATA,
	output 	[7:0]	EXMEM_ALU_OUT,
	input 	[4:0]	IDEX_OPCODE,
	input 	[2:0]	IDEX_RD_ADDR,
	input 	[3:0]	IDEX_R1_ADDR,
	input 	[3:0]	IDEX_R2_ADDR,
	input  	[7:0]	IDEX_RD_DATA,
	//input  	[7:0]	IDEX_R1_DATA,
	//input  	[7:0]	IDEX_R2_DATA,
	input 	[7:0]	ALU_OUT,
	input 			FLUSH,
	input			rst,
	input			clk);

	reg		[4:0]	opcode;
	reg 	[2:0]	rd_addr;
	reg 	[3:0] 	r1_addr;
	reg 	[3:0]	r2_addr;
	reg 	[7:0]	rd_data;
	// reg 	[7:0] 	r1_data;
	// reg 	[7:0]	r2_data;
	reg 	[7:0]	aluout;

always @(posedge clk)
	if (rst) begin
		opcode 	<= 5'h1f;
		rd_addr <= 0;
		r1_addr <= 0;
		r2_addr <= 0;
		rd_data <= 0;
		// r1_data <= 0;
		// r2_data <= 0;
		aluout <= 0;
	end
	else begin
		if (FLUSH) begin
			opcode 	<= 5'h1f;
			rd_addr <= 0;
			r1_addr <= 0;
			r2_addr <= 0;
			rd_data <= 0;
			// r1_data <= 0;
			// r2_data <= 0;
			aluout <= 0;
		end
		else begin
			opcode 	<= IDEX_OPCODE;
			rd_addr <= IDEX_RD_ADDR;
			r1_addr <= IDEX_R1_ADDR;
			r2_addr <= IDEX_R2_ADDR;
			rd_data <= IDEX_RD_DATA;
			// r1_data <= IDEX_R1_DATA;
			// r2_data <= IDEX_R2_DATA;
			aluout <= ALU_OUT;
		end
	end 

assign EXMEM_OPCODE  =opcode;
assign EXMEM_RD_ADDR =rd_addr;
assign EXMEM_R1_ADDR =r1_addr;
assign EXMEM_R2_ADDR =r2_addr;
assign EXMEM_RD_DATA =rd_data;
// assign EXMEM_R1_DATA =r1_data;
// assign EXMEM_R2_DATA =r2_data;
assign EXMEM_ALU_OUT =aluout;
endmodule