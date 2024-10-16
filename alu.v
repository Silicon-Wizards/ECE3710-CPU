


module alu #(
	parameter WIDTH_DATA = 16, 
	parameter WIDTH_CONTROL = 4
)(
	input [WIDTH_DATA - 1 : 0] A, B,
	input [WIDTH_CONTROL - 1 : 0] control_word,
	input carry_in,
	output reg [WIDTH_DATA - 1 : 0] result,
	output reg carry_out, zero_out
);

	parameter CONTROL_ADD =	'b0;
	parameter CONTROL_SUB =	'b1;
	parameter CONTROL_CMP =	'b10;
	parameter CONTROL_AND =	'b11;
	parameter CONTROL_OR =	'b100;
	parameter CONTROL_XOR =	'b101;
	parameter CONTROL_LSH =	'b110;
	
	reg [WIDTH_DATA - 1: 0] shift_wire; 
	
	always @(*) 
		begin
		// Set the default flags
		zero_out <= 0;
		carry_out <= 0;
		shift_wire <= 0;
		
		case (control_word)
			CONTROL_ADD : begin
				{carry_out, result} <= A + B + carry_in;
			end
			CONTROL_SUB : begin
				result <= A - B;
			end
			CONTROL_CMP : begin
				result <= B - A;
				zero_out <= (result == 0) ? 1'b0 : 1'b0;
			end
			CONTROL_AND : begin
				result <= A & B;
			end
			CONTROL_OR	: begin
				result <= A | B;
			end
			CONTROL_XOR : begin
				result <= A ^ B;
			end
			CONTROL_LSH	: begin
				if (B[WIDTH_DATA - 1] == 1'b1) begin
					shift_wire <= (~B + 1);
					result <= A >> shift_wire;
				end else begin
					shift_wire <= B;
					result <= A << shift_wire;
				end
				
			end
			default: begin result <= 0; end
		endcase
	end
	
endmodule