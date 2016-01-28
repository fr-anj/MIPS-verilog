module MEMWB (
	output	[4:0]	MEMWB_OPCODE,
	output 	[2:0]	MEMWB_RD_ADDR,
	output 	[3:0]	MEMWB_R1_ADDR,
	output	[3:0]	MEMWB_R2_ADDR,
	//output	[7:0]	MEMWB_RD_DATA,
	//output	[7:0]	MEMWB_R1_DATA,
	//output	[7:0]	MEMWB_R2_DATA,
	output 	[7:0]	MEMWB_ALU_OUT,
	output 	[7:0]	MEMWB_R_DATA,
	input 	[4:0]	EXMEM_OPCODE,
	input 	[2:0]	EXMEM_RD_ADDR,
	input 	[3:0]	EXMEM_R1_ADDR,
	input 	[3:0]	EXMEM_R2_ADDR,
	//input  	[7:0]	EXMEM_RD_DATA,
	//input  	[7:0]	EXMEM_R1_DATA,
	//input  	[7:0]	EXMEM_R2_DATA,
	input 	[7:0] 	R_DATA, //data read from RAM
	input 	[7:0]	EXMEM_ALU_OUT,
	input			rst,
	input			clk);

	reg		[4:0]	opcode;
	reg 	[2:0]	rd_addr;
	reg 	[3:0] 	r1_addr;
	reg 	[3:0]	r2_addr;
	//reg 	[7:0]	rd_data;
	//reg 	[7:0] 	r1_data;
	//reg 	[7:0]	r2_data;
	reg 	[7:0]	alu_out;
	reg 	[7:0]	ram_data;

always @(posedge clk)
	if (rst) begin
		opcode 	<= 5'h1f;
		rd_addr <= 0;
		r1_addr <= 0;
		r2_addr <= 0;
		//rd_data <= 0;
		//r1_data <= 0;
		//r2_data <= 0;
		alu_out <= 0;
		ram_data <= 0;
	end
	else begin
		opcode 	<= EXMEM_OPCODE;
		rd_addr <= EXMEM_RD_ADDR;
		r1_addr <= EXMEM_R1_ADDR;
		r2_addr <= EXMEM_R2_ADDR;
		//rd_data <= EXMEM_RD_DATA;
		//r1_data <= EXMEM_R1_DATA;
		//r2_data <= EXMEM_R2_DATA;
		alu_out <= EXMEM_ALU_OUT;
		ram_data <= R_DATA;
	end

assign MEMWB_OPCODE  = opcode;
assign MEMWB_RD_ADDR = rd_addr;
assign MEMWB_R1_ADDR = r1_addr;
assign MEMWB_R2_ADDR = r2_addr;
//assign MEMWB_RD_DATA = rd_data;
//assign MEMWB_R1_DATA = r1_data;
//assign MEMWB_R2_DATA = r2_data;
assign MEMWB_ALU_OUT = alu_out;
assign MEMWB_R_DATA = ram_data;
endmodule