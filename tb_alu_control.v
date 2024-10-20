module tb_alu_control;


	//input [WIDTH_OP_CODE - 1 : 0] op_code,
	//input [WIDTH_INSTR_TYPE - 1 : 0] instr_type,	// This is determined before sending op code to this controller
	//output reg [WIDTH_CONTROL - 1 : 0] control_word,
	//output reg carry_bit
	parameter WIDTH_INSTR_TYPE = 1;
	parameter WIDTH_OP_CODE = 4;
	parameter WIDTH_CONTROL = 4;
	
	reg  [WIDTH_OP_CODE - 1 : 0] 		op_code;
	reg  [WIDTH_INSTR_TYPE - 1 : 0] 	instr_type;
	wire [WIDTH_CONTROL - 1 : 0] 		control_word;
	wire 										carry_bit;
	
	alu_control #(WIDTH_OP_CODE, WIDTH_INSTR_TYPE, WIDTH_CONTROL) DUT(
		.op_code(tb_op_code),
		.instr_type(tb_instr_type),
		.control_word(tb_control_word),
		.carry_bit(tb_carry_bit)
	);
	
	initial begin
		$display("hello there!");
	end
	
	
endmodule