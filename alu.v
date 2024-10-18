
// This module contains all the implementation for the ALU for use in the ECE3710-CPU project.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 18, 2024
//


module alu #(
	parameter WIDTH_DATA = 16, 
	parameter WIDTH_CONTROL = 4
)(
	input [WIDTH_DATA - 1 : 0] A, B,	// A is usually Rdest, B is Rsrc, Imm, or Ramount
	input [WIDTH_CONTROL - 1 : 0] control_word,
	input carry_in,
	output reg [WIDTH_DATA - 1 : 0] result,
	output reg carry_out, low_out, over_out, neg_out, zero_out
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
		
	wire [WIDTH_DATA : 0] adder_sum, adder_diff;
	wire [WIDTH_DATA - 1 : 0] inv_B;
	wire low_flag, over_flag, zero_flag, neg_flag;
	
	// Continuous Assignment Values
	// ADD / SUB
	assign adder_sum = A + B;
	
	assign inv_B = ~B + 1'b1;
	assign adder_diff = A + inv_B;
	
	// Internal Computation of Flags
	// OVERFLOW
	assign over_flag = (A[WIDTH_DATA - 1] == B[WIDTH_DATA - 1] ? ((A[WIDTH_DATA - 1] != result[WIDTH_DATA - 1]) ? 1'b1 : 1'b0) : 1'b0);
	
	// ZERO
	assign zero_flag = (result == 0) ? 1'b1 : 1'b0;
	
	// LOW
	assign low_flag = A < B;
	
	// NEGATIVE
	assign neg_flag = adder_diff[WIDTH_DATA];
		
	always @(*) 
		begin
		// Set the defaults
		carry_out <= 0;
		low_out <= 0;
		over_out <= 0;
		neg_out <= 0;
		
		result <= 0;
				
		case (control_word)
			// Arithmetic Operations
			CONTROL_ADD : begin
				result <= adder_sum[WIDTH_DATA - 1 : 0];
				over_out <= over_flag;
			end
			CONTROL_ADDU : begin
				{carry_out, result} <= adder_sum;
			end
			CONTROL_SUB : begin
				result <= adder_diff[WIDTH_DATA - 1 : 0];
				over_out <= over_flag;
			end
			CONTROL_SUBU : begin
				{carry_out, result} <= adder_diff;
			end
			
			// Logical Operations
			CONTROL_CMP : begin
				neg_out <= neg_flag;
				low_out <= low_flag;
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
			
			// Shifting Operations
			// Shifting assumes A is Rdest, B is Ramount
			CONTROL_LSH	: begin
				if (B[WIDTH_DATA - 1] == 1'b1) begin
					result <= A >> (inv_B);
				end else begin
					result <= A << B;
				end
				
			end
			default : begin result <= 0; end
		endcase
		
		// Update the ZERO output register
		zero_out <= zero_flag;
		
	end
	
endmodule