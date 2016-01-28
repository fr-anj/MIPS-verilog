module REGISTER_FILE (
	output 	reg 	[7:0] 	R1_DATA,
	output 	reg 	[7:0] 	R2_DATA,
	output 	reg 	[7:0] 	RD_DATA,
	input 			[2:0] 	R1_ADDR,
	input 			[2:0] 	R2_ADDR,
	input 			[2:0] 	RD_ADDR,	
	input 			[2:0] 	W_ADDR,
	input 			[7:0] 	W_DATA,
	input					W_ENABLE,
	input					rst,	
	input 					clk);

	parameter	r0 = 3'b000,
				r1 = 3'b001,
				r2 = 3'b010,
				r3 = 3'b011,
				r4 = 3'b100,
				r5 = 3'b101,
				r6 = 3'b110,
				r7 = 3'b111;

	reg [7:0] 	IR0;
	reg	[7:0] 	IR1;
	reg	[7:0] 	IR2;
	reg	[7:0] 	IR3;
	reg	[7:0] 	IR4;
	reg	[7:0] 	IR5;
	reg	[7:0] 	IR6; 
	reg	[7:0] 	IR7;

always @(posedge clk)
	if (rst) begin
			IR0 <= 0;
			IR1 <= 0;
			IR2 <= 0;
			IR3 <= 0;
			IR4 <= 0;
			IR5 <= 0;
			IR6 <= 0;
			IR7 <= 0;
	end else if (W_ENABLE)
		case (W_ADDR)
			r0: IR0 <= W_DATA;
			r1: IR1 <= W_DATA;
			r2: IR2 <= W_DATA;
			r3: IR3 <= W_DATA;
			r4: IR4 <= W_DATA;
			r5: IR5 <= W_DATA;
			r6: IR6 <= W_DATA;
			r7: IR7 <= W_DATA;
		endcase
	else
		case (W_ADDR)
			r0: IR0 <= IR0;
			r1: IR1 <= IR1;
			r2: IR2 <= IR2;
			r3: IR3 <= IR3;
			r4: IR4 <= IR4;
			r5: IR5 <= IR5;
			r6: IR6 <= IR6;
			r7: IR7 <= IR7;
		endcase

always @(posedge clk)
	if (rst)
		R1_DATA <= 0;
	else
		case (R1_ADDR)
			r0: R1_DATA	<= IR0;
			r1: R1_DATA	<= IR1; 
			r2: R1_DATA	<= IR2; 
			r3: R1_DATA	<= IR3;
			r4: R1_DATA	<= IR4;
			r5: R1_DATA	<= IR5;
			r6: R1_DATA	<= IR6;
			r7: R1_DATA	<= IR7;
		endcase

always @(posedge clk)
	if (rst)
		R2_DATA <= 0;
	else
		case (R2_ADDR)
			r0: R2_DATA	<= IR0;
			r1: R2_DATA	<= IR1; 
			r2: R2_DATA	<= IR2; 
			r3: R2_DATA	<= IR3;
			r4: R2_DATA	<= IR4;
			r5: R2_DATA	<= IR5;
			r6: R2_DATA	<= IR6;
			r7: R2_DATA	<= IR7;
		endcase

always @(posedge clk)
	if (rst)
		RD_DATA <= 0;
	else
		case (RD_ADDR)
			r0: RD_DATA	<= IR0;
			r1: RD_DATA	<= IR1; 
			r2: RD_DATA	<= IR2; 
			r3: RD_DATA	<= IR3;
			r4: RD_DATA	<= IR4;
			r5: RD_DATA	<= IR5;
			r6: RD_DATA	<= IR6;
			r7: RD_DATA	<= IR7;
		endcase
endmodule