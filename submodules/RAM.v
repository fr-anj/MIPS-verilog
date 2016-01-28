module RAM (
	output reg	[7:0] 	R_DATA,
	input 		[7:0] 	W_ADDR,
	input 		[7:0] 	W_DATA,
	input 		[7:0] 	DATA_ADDR,
	input 				RW_ENABLE,
	input 				rst,
	input 				clk);

	integer i,j;

	reg [7:0] ram_block [255:0];

/*(always @(posedge clk)
	if (rst) begin
		for (i = 0; i < 256; i = i + 1)
			ram_block[i] <= 8'h00;
		R_DATA <= 8'h00;
	end
	else if (RW_ENABLE)
		ram_block[W_ADDR] <= W_DATA;
	else
		R_DATA <= ram_block[DATA_ADDR];*/

always @(posedge clk)
	if (rst)
		for (i = 0; i < 256; i = i + 1)
			ram_block[i] <= 8'h00;
	else if (RW_ENABLE)
		ram_block[W_ADDR] <= W_DATA;
	else
		for (j = 0; j < 256; j = j + 1)
			ram_block[j] <= ram_block[j];

		
always @(posedge clk)
	if (rst)
		R_DATA <= 8'h00;
	else  
		R_DATA <= ram_block[DATA_ADDR];

endmodule 
