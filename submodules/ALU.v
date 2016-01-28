module ALU (
	output 	[7:0] 	ALU_OUT,
	output 			CARRY_FLAG,
	input 	[4:0] 	IDEX_OPCODE,
	input 	[7:0] 	IDEX_R1_DATA,
	input 	[7:0] 	IDEX_R2_DATA,
	input 	[7:0] 	EXMEM_ALU_OUT,
	input 	[7:0] 	MEMWB_ALU_OUT,
	input	[2:0] 	FORWARD_A,
	input 	[2:0] 	FORWARD_B,

	input 	[7:0]	R_DATA,
	input 	[3:0]	EXMEM_R1_ADDR,
	input	[3:0]	EXMEM_R2_ADDR,
	input 	[7:0]	MEMWB_R_DATA,
	input 	[3:0] 	MEMWB_R1_ADDR,
	input 	[3:0]	MEMWB_R2_ADDR);

	/*parameter 		no_forward 		= 3'b000,
					forward_exmem 	= 3'b001,
					forward_memwd	= 3'b010,
					forward_exload	= 3'b
					forward_eximm	=
					forward_memload	=
					forward_memimm	=;	*/
	parameter		no_forward 		= 3'b000,
					forward_exmem	= 3'b011,
					forward_exload	= 3'b010,
					forward_eximm	= 3'b001,
					forward_memimm 	= 3'b101,
					forward_memload = 3'b110,
					forward_memwd	= 3'b111;

	parameter 		op_srl 			= 5'b00000,
					op_sra 			= 5'b00001,
					op_sl 			= 5'b00010,
					op_rol 			= 5'b00011,
					op_ror 			= 5'b00100,
					op_bit_and		= 5'b00101,
					op_bit_or 		= 5'b00110,
					op_bit_not 		= 5'b00111,
					op_bit_xor 		= 5'b01000,
					op_add 			= 5'b01001,
					op_sub 			= 5'b01010,
					op_mul 			= 5'b10001,
					op_lt 			= 5'b01011,
					op_gt 			= 5'b01100,
					op_eq 			= 5'b01101,
					op_gte 			= 5'b01110,
					op_lte 			= 5'b01111,
					op_ne 			= 5'b10000;

	reg 	[7:0]	var_a;
	reg 	[7:0]	var_b;
	reg				flag;
	reg		[7:0] 	out_alu;

	wire 			out_lt;
	wire 			out_gt;
	wire 			out_eq;
	wire 			out_gte;
	wire 			out_lte;
	wire 			out_ne;

	wire 	[7:0] 	out_srl;	 
	wire 	[7:0] 	out_sra;	 
	wire 	[7:0] 	out_sl;  
	wire 	[7:0] 	out_rol; 
	wire 	[7:0] 	out_ror;

	wire 	[7:0] 	out_bitand;
	wire 	[7:0] 	out_bitor;
	wire 	[7:0] 	out_bitnot;
	wire 	[7:0] 	out_bitxor;

	wire 	[7:0] 	out_add;
	wire 	[7:0] 	out_sub;
	wire 	[7:0] 	out_mul;

	wire 	[7:0]	test1;
	wire 	[7:0]	test2;
	wire 			carry;
	wire 			borrow;

always @(*)
	case (FORWARD_A)
		no_forward		:
			var_a = IDEX_R1_DATA;
		forward_exmem	:
			var_a = EXMEM_ALU_OUT;
		forward_exload	:
			var_a = R_DATA;
		forward_eximm	:
			var_a = {EXMEM_R1_ADDR,EXMEM_R2_ADDR};
		forward_memwd	:
			var_a = MEMWB_ALU_OUT;
		forward_memload	:
			var_a = MEMWB_R_DATA;
		forward_memimm	:
			var_a = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
		default:
			var_a = IDEX_R1_DATA;
	endcase

always @(*)
	case (FORWARD_B)
		no_forward		:
			var_b = IDEX_R2_DATA;
		forward_exmem	:
			var_b = EXMEM_ALU_OUT;
		forward_exload	:
			var_b = R_DATA;
		forward_eximm	:
			var_b = {EXMEM_R1_ADDR,EXMEM_R2_ADDR};
		forward_memload	:
			var_b = MEMWB_ALU_OUT;
		forward_memwd	:
			var_b = MEMWB_R_DATA;
		forward_memimm	:
			var_b = {MEMWB_R1_ADDR,MEMWB_R2_ADDR};
		default:
			var_b = IDEX_R2_DATA;
	endcase

always @(*)
	case (IDEX_OPCODE)
		op_lt 		: out_alu 	= out_lt;
		op_gt 		: out_alu 	= out_gt;
		op_eq 		: out_alu 	= out_eq;
		op_gte 		: out_alu 	= out_gte;
		op_lte 		: out_alu 	= out_lte;
		op_ne 		: out_alu 	= out_ne;
		op_srl 		: out_alu 	= out_srl;
		op_sra 		: out_alu 	= out_sra;
		op_sl 		: out_alu 	= out_sl;
		op_rol 		: out_alu 	= out_rol;
		op_ror 		: out_alu 	= out_ror;
		op_bit_and	: out_alu 	= out_bitand;
		op_bit_or	: out_alu 	= out_bitor;
		op_bit_not	: out_alu 	= out_bitnot;
		op_bit_xor	: out_alu 	= out_bitxor;
		op_add 		: out_alu 	= out_add;
		op_sub 		: out_alu 	= out_sub;
		op_mul 		: out_alu 	= out_mul;
		default		: out_alu	= 0;
	endcase

	always @(*)
		case (IDEX_OPCODE)
			op_add	: flag 	= carry; 
			op_sub 	: flag 	= borrow;
			default : flag 	= 0;
		endcase

assign out_lt 				= (var_a < var_b)? 8'h01: 8'h00;
assign out_gt 				= (var_a > var_b)? 8'h01: 8'h00;
assign out_eq 				= (var_a == var_b)? 8'h01: 8'h00;
assign out_gte 				= (var_a >= var_b)? 8'h01: 8'h00;
assign out_lte 				= (var_a <= var_b)? 8'h01: 8'h00;
assign out_ne 				= (var_a == var_b)? 8'h00: 8'h01;

assign out_srl 				= var_a >> var_b;
assign out_sra 				= var_a >>> var_b;
assign out_sl 				= var_a << var_b;
assign out_rol 				= (var_a << test2) | (var_a >> test1); //since registers are 8 bits wide only, mod 8 numbers to shift would result to the original value
assign out_ror 				= (var_a >> test2) | (var_a << test1); //but instead of using mod 8, masking var_b value by 07h is implemented
assign test1 				= 8'h07 & (8'h10 - var_b );
assign test2 				=  (var_b & 8'h07);

assign out_bitand 			= var_a & var_b;
assign out_bitor 			= var_a | var_b;
assign out_bitnot 			= ~var_a;
assign out_bitxor 			= var_a ^ var_b;

assign {carry,out_add} 		= var_a + var_b;	
assign {borrow,out_sub} 	= var_a - var_b;	
assign out_mul				= var_a[3:0] * var_b[3:0];	
assign CARRY_FLAG 			= (IDEX_OPCODE== op_add || IDEX_OPCODE == op_sub)? flag : 0;
assign ALU_OUT 				= out_alu;
endmodule