//
// alu.v
//
// This module contains all the implementation for the ALU for use in the ECE3710-CPU project.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 15, 2024
//


module alu #(
	parameter WIDTH_DATA = 16, 
	parameter WIDTH_CONTROL = 4
)(
	input [WIDTH_DATA - 1 : 0] A, B,
	input [WIDTH_CONTROL - 1 : 0] control_word,
	input carry_in,
	output reg [WIDTH_DATA - 1 : 0] result,
	output reg carry_out, low_out, over_out, zero_out, neg_out 
);

	parameter CONTROL_ADD 	=	'b0;
	parameter CONTROL_ADDU	=	'b1;
	parameter CONTROL_SUB 	=	'b10;
	parameter CONTROL_SUBU	=	'b11;
	parameter CONTROL_CMP 	=	'b100;
	parameter CONTROL_AND 	=	'b101;
	parameter CONTROL_OR 	=	'b110;
	parameter CONTROL_XOR	=	'b111;
	parameter CONTROL_LSH 	=	'b1000;
	
	reg [WIDTH_DATA - 1: 0] shift_wire; 
	
	always @(*) 
		begin
		// Set the default flags
		carry_out <= 0;
		low_out <= 0;
		zero_out <= 0;
		over_out <= 0;
		neg_out <= 0;
		
		shift_wire <= 0;
		
		case (control_word)
			CONTROL_ADD : begin
				{carry_out, result} <= A + B + carry_in;
			end
			CONTROL_ADDU : begin
				{carry_out, result} <= A + B + carry_in;
				over_out <= carry_out;
			end
			CONTROL_SUB : begin
				result <= A - B;
			end
			CONTROL_CMP : begin
				neg_out <= (B - A)[WIDTH_DATA - 1] == 'b1;
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
		
		assign zero <= result == 0 ? 'b1 : 1'b0;
	end
	
endmodule