module PC(
	output	 	[7:0] 	O_inst_addr,
	input 				STALL,
	input 		[7:0] 	JUMP_ADDR,
	input		[7:0] 	BRANCH_ADDR,
	input 		[1:0] 	SEL,
	input 				rst,
	input 				clk);

	reg 		[7:0] 	pc_out;
 
always @(posedge clk)
	if(rst)
		pc_out <= 0;
	else if (STALL)
		pc_out <= pc_out;
	else
		case (SEL)
			2'b00: 	pc_out <= pc_out + 1;
			2'b01: 	pc_out <= BRANCH_ADDR;
			2'b10:	pc_out <= JUMP_ADDR;
		endcase

assign O_inst_addr = pc_out;
endmodule