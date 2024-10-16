module tb_alu;
	//parameters
	parameter WIDTH_DATA = 16;
	parameter WIDTH_CONTROL = 4;
	parameter CONTROL_ADD =	'b0;
	parameter CONTROL_SUB =	'b1;
	parameter CONTROL_CMP =	'b10;
	parameter CONTROL_AND =	'b11;
	parameter CONTROL_OR =	'b100;
	parameter CONTROL_XOR =	'b101;
	parameter CONTROL_LSH =	'b110;
	//tb_parameters
	integer i;
	
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

	alu DUT(
	A(tb_A),
	B(tb_B),
	control_word(tb_control_word),
	carry_in(tb_carry_in)
	);
	
	initial begin
		//#5;
		//tb_control_word = CONTROL_ADD;
		//tb_A = 5;
		//tb_B = 6;
		//#5;
	end
endmodule