module IDEX (
	output	[4:0]	IDEX_OPCODE,
	output 	[2:0]	IDEX_RD_ADDR,
	output 	[3:0]	IDEX_R1_ADDR,
	output	[3:0]	IDEX_R2_ADDR,
	output	[7:0]	IDEX_RD_DATA,
	output	[7:0]	IDEX_R1_DATA,
	output	[7:0]	IDEX_R2_DATA,
	input 	[4:0]	IFID_OPCODE,
	input 	[2:0]	IFID_RD_ADDR,
	input 	[3:0]	IFID_R1_ADDR,
	input 	[3:0]	IFID_R2_ADDR,
	input  	[7:0]	RD_DATA,
	input  	[7:0]	R1_DATA,
	input  	[7:0]	R2_DATA,
	input 			STALL,
	input 			FLUSH,
	input			rst,
	input			clk,

	input 	[4:0]	STALL_OPCODE,
	input 	[2:0]	STALL_RD_ADDR,
	input 	[3:0]	STALL_R1_ADDR,
	input 	[3:0]	STALL_R2_ADDR
	);

	reg		[4:0]	opcode;
	reg 	[2:0]	rdaddr;
	reg 	[3:0] 	r1addr;
	reg 	[3:0]	r2addr;
	reg 	[7:0]	rddata;
	reg 	[7:0] 	r1data;
	reg 	[7:0]	r2data;

always @(posedge clk)
	if (rst) begin
		opcode 	<= 5'h1f;
		rdaddr <= 0;
		r1addr <= 0;
		r2addr <= 0;
		rddata <= 0;
		r1data <= 0;
		r2data <= 0;
	end
	else begin
		if (FLUSH) begin
			opcode 	<= 5'h1f;
			rdaddr <= 0;
			r1addr <= 0;
			r2addr <= 0;
			rddata <= 0;
			r1data <= 0;
			r2data <= 0;
		end 
		else if (STALL) begin
			opcode 	<= STALL_OPCODE;
			rdaddr <= STALL_RD_ADDR;
			r1addr <= STALL_R1_ADDR;
			r2addr <= STALL_R2_ADDR;
		end
		else begin
			opcode 	<= IFID_OPCODE;
			rdaddr <= IFID_RD_ADDR;
			r1addr <= IFID_R1_ADDR;
			r2addr <= IFID_R2_ADDR;
			rddata <= RD_DATA;
			r1data <= R1_DATA;
			r2data <= R2_DATA;
		end
	end 

assign IDEX_OPCODE 	= opcode;
assign IDEX_RD_ADDR = rdaddr;
assign IDEX_R1_ADDR = r1addr;
assign IDEX_R2_ADDR = r2addr;
assign IDEX_RD_DATA = rddata;
assign IDEX_R1_DATA = r1data;
assign IDEX_R2_DATA = r2data;
endmodule
