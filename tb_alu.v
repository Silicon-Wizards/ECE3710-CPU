module tb_alu;
	//parameters
	parameter WIDTH_DATA = 16;
	parameter WIDTH_CONTROL = 4;
	
	parameter CONTROL_ADD =	'b000;
	parameter CONTROL_SUB =	'b001;
	parameter CONTROL_CMP =	'b010;
	parameter CONTROL_AND =	'b011;
	parameter CONTROL_OR  =	'b100;
	parameter CONTROL_XOR =	'b101;
	parameter CONTROL_LSH =	'b110;
	//tb_parameters
	integer i;
	integer j;
	
	//input [WIDTH_DATA - 1 : 0] A, B,
	//input [WIDTH_CONTROL - 1 : 0] control_word,
	//input carry_in,
	//output reg [WIDTH_DATA - 1 : 0] result,
	//output reg carry_out, zero_out
	
	reg [WIDTH_DATA - 1 : 0]		tb_A; 				//input [WIDTH_DATA - 1 : 0] A, B
	reg [WIDTH_DATA - 1 : 0] 		tb_B; 				//input [WIDTH_DATA - 1 : 0] A, B
	reg [WIDTH_CONTROL - 1 : 0]	tb_control_word;	//input [WIDTH_CONTROL - 1 : 0] control_word
	reg 									tb_carry_in; 		//input carry_in,
	
	wire [WIDTH_DATA - 1 : 0] 		tb_result;			//output reg [WIDTH_DATA - 1 : 0] result
	wire 									tb_carry_out;		//output reg carry_out, zero_out
	wire 									tb_zero_out;		//output reg carry_out, zero_out

	alu #(WIDTH_DATA, WIDTH_CONTROL) DUT(
		.A(tb_A),
		.B(tb_B),
		.control_word(tb_control_word),
		.carry_in(tb_carry_in),
		.result(tb_result),
		.carry_out(tb_carry_out),
		.zero_out(tb_zero_out)
	);
	
	initial begin
	/**
		tb_carry_in = 0;
		tb_control_word = CONTROL_ADD;
		for(i = -4; i < 4; i = i + 1) begin
			for(j = -4; j < 4; j = j + 1) begin
				tb_A = i;
				tb_B = j;
				#5;
			end
		end
		
		tb_carry_in = 1;
		tb_control_word = CONTROL_ADD;
		for(i = -4; i < 4; i = i + 1) begin
			for(j = -4; j < 4; j = j + 1) begin
				tb_A = i;
				tb_B = j;
				#5;
			end
		end
		**/
		
		/**
		$display("TEST: and")
		tb_carry_in = 0;
		tb_control_word = CONTROL_AND;
		for(i = 0; i < 4; i = i + 1) begin
			for(j = 0; j < 4; j = j + 1) begin
				tb_A = i;
				tb_B = j;
				#5;
				$display("i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i & j));
			end
		end
		$display("");
		$display("");
		**/
		
		/**
		$display("TEST OR");
		tb_carry_in = 0;
		tb_control_word = CONTROL_OR;
		for(i = 0; i < 4; i = i + 1) begin
			for(j = 0; j < 4; j = j + 1) begin
				tb_A = i;
				tb_B = j;
				#5;
				$display("i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i | j));
			end
		end
		$display("");
		$display("");
		**/
		
		
		$display("TEST XOR");
		tb_carry_in = 0;
		tb_control_word = CONTROL_XOR;
		for(i = 0; i < 4; i = i + 1) begin
			for(j = 0; j < 4; j = j + 1) begin
				tb_A = i;
				tb_B = j;
				#5;
				$display("i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i ^ j));
			end
		end
		$display("");
		$display("");
		
		
		$display("TEST LSH");
		tb_carry_in = 0;
		tb_control_word = CONTROL_LSH;
		for(i = 0; i < 4; i = i + 1) begin
			for(j = 0; j < 4; j = j + 1) begin
				tb_A = i;
				tb_B = j;
				#5;
				$display("i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i << j));
			end
		end
		$display("");
		$display("");
		

	end
endmodule