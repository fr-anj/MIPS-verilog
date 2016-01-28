module tb_MIPS;

	//wire	[7:0] 	O_inst_addr;
	//reg 	[15:0] 	I_inst;
	reg 	rst;
	reg 	clk;

	MIPS U0 (
	//.O_inst_addr(O_inst_addr),
	//.I_inst(I_inst),
	.rst(rst),
	.clk(clk)
	);

	integer i;

	initial begin
		$vcdpluson;
		clk = 0;
		rst = 0;
		@(posedge clk); 			
			rst		<= 1;
		@(posedge clk)
			rst 	<= 0;
		for (i = 0; i < 400; i = i + 1)
			@(posedge clk);
		#2 $finish;
	end

	always 
		#1 	clk = !clk;

endmodule