module tb_alu_control;


	//input [WIDTH_OP_CODE - 1 : 0] op_code,
	//input [WIDTH_INSTR_TYPE - 1 : 0] instr_type,	// This is determined before sending op code to this controller
	//output reg [WIDTH_CONTROL - 1 : 0] control_word,
	//output reg carry_bit
	parameter WIDTH_INSTR_TYPE = 1;
	parameter WIDTH_OP_CODE = 4;
	parameter WIDTH_CONTROL = 4;
	//op code
	localparam OP_CODE_ADD		=	'b0101; //tb_instr_type = INSTR_STATIC vvv
	localparam OP_CODE_ADDU		=	'b0110;
	localparam OP_CODE_ADDC		=	'b0111;
	localparam OP_CODE_SUB		=	'b1001;
	localparam OP_CODE_SUBC		= 	'b1010;
	localparam OP_CODE_CMP		=	'b1011;
	localparam OP_CODE_AND		=	'b0001;
	localparam OP_CODE_OR		=	'b0010;
	localparam OP_CODE_XOR		=	'b0011;
	localparam OP_CODE_LSH		=	'b0100; //tb_instr_type = INSTR_SHIFT vvv
	localparam OP_CODE_ALSHU	=	'b0110; 
	//instr type
	localparam INSTR_STATIC		= 'b0;
	localparam INSTR_SHIFT		= 'b1;
	//control words
	localparam CONTROL_ADD 	=	'b0000;
	localparam CONTROL_ADDU	=	'b0001;
	localparam CONTROL_SUB 	=	'b0010;
	localparam CONTROL_SUBU	=	'b0011;
	localparam CONTROL_CMP 	=	'b0100;
	localparam CONTROL_AND 	=	'b0101;
	localparam CONTROL_OR 	=	'b0110;
	localparam CONTROL_XOR	=	'b0111;
	localparam CONTROL_LSH 	=	'b1000;
	
	reg  [WIDTH_OP_CODE - 1 : 0] 		tb_op_code;
	reg  [WIDTH_INSTR_TYPE - 1 : 0] 	tb_instr_type;
	wire [WIDTH_CONTROL - 1 : 0] 		tb_control_word;
	wire 										tb_carry_bit;
	
	alu_control #(WIDTH_OP_CODE, WIDTH_INSTR_TYPE, WIDTH_CONTROL) DUT(
		.op_code(tb_op_code),
		.instr_type(tb_instr_type),
		.control_word(tb_control_word),
		.carry_bit(tb_carry_bit)
	);
	
	initial begin
		#5;
		$display("TEST: OP_CODE_ADD");
		tb_op_code = OP_CODE_ADD;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_ADD || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_ADD, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_ADDU");
		tb_op_code = OP_CODE_ADDU;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_ADDU || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_ADDU, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_ADDC");
		tb_op_code = OP_CODE_ADDC;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_ADD || tb_carry_bit != 1)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_ADD, tb_carry_bit, 1);
		
		//-------------
		$display("TEST: OP_CODE_SUB");
		tb_op_code = OP_CODE_SUB;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_SUB || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_SUB, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_SUBC");
		tb_op_code = OP_CODE_SUBC;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_SUB || tb_carry_bit != 1)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_SUB, tb_carry_bit, 1);
		
		//-------------
		$display("TEST: OP_CODE_CMP");
		tb_op_code = OP_CODE_CMP;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_CMP || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_CMP, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_AND");
		tb_op_code = CONTROL_AND;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_AND || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_AND, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_OR");
		tb_op_code = OP_CODE_OR;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_OR || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_OR, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_XOR");
		tb_op_code = OP_CODE_XOR;
		tb_instr_type = INSTR_STATIC;
		#5;
		if(tb_control_word != CONTROL_XOR || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_XOR, tb_carry_bit, 0);
		
		//-------------
		$display("TEST: OP_CODE_LSH");
		tb_op_code = OP_CODE_LSH;
		tb_instr_type = INSTR_SHIFT;
		#5;
		if(tb_control_word != CONTROL_LSH || tb_carry_bit != 0)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_LSH, tb_carry_bit, 0);
			
		//-------------
		$display("TEST: OP_CODE_ALSHU");
		tb_op_code = OP_CODE_ALSHU;
		tb_instr_type = INSTR_SHIFT;
		#5;
		if(tb_control_word != CONTROL_LSH || tb_carry_bit != 1)
			$display("ERROR!! tb_control_word: %h should be %h \n tb_carry_bit: %h should be %h", tb_control_word, CONTROL_LSH, tb_carry_bit, 1);
			
	end
	
	
endmodule