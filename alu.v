//
// alu.v
//
// This file contains all the implementation for the ALU for use in the ECE3710-CPU project.
//	The ALU module is defined here, as well as the supplementary ALU control module for generating
// ALU control words from the op_codes.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 18, 2024
//

module alu_control#(
	parameter WIDTH_OP_CODE = 4, 
	parameter WIDTH_INSTR_TYPE = 1,
	parameter WIDTH_CONTROL = 4
)(
	input [WIDTH_OP_CODE - 1 : 0] op_code,
	input [WIDTH_INSTR_TYPE - 1 : 0] instr_type,	// This is determined before sending op code to this controller
	output reg [WIDTH_CONTROL - 1 : 0] control_word,
	output reg carry_bit
);

	localparam INSTR_STATIC		= 'b0;
	localparam INSTR_SHIFT		= 'b1;
	
	localparam OP_CODE_ADD		=	'b0101;
	localparam OP_CODE_ADDU		=	'b0110;
	localparam OP_CODE_ADDC		=	'b0111;
	localparam OP_CODE_SUB		=	'b1001;
	localparam OP_CODE_SUBC		= 	'b1010;
	localparam OP_CODE_CMP		=	'b1011;
	localparam OP_CODE_AND		=	'b0001;
	localparam OP_CODE_OR		=	'b0010;
	localparam OP_CODE_XOR		=	'b0011;
	localparam OP_CODE_LSH		=	'b0100;
	localparam OP_CODE_ALSHU	=	'b0110;
	
	localparam CONTROL_ADD 	=	'b0;
	localparam CONTROL_ADDU	=	'b1;
	localparam CONTROL_SUB 	=	'b10;
	localparam CONTROL_SUBU	=	'b11;
	localparam CONTROL_CMP 	=	'b100;
	localparam CONTROL_AND 	=	'b101;
	localparam CONTROL_OR 	=	'b110;
	localparam CONTROL_XOR	=	'b111;
	localparam CONTROL_LSH 	=	'b1000;
	
	always @(*) begin
		control_word <= 'b1111;
		carry_bit <= 0;
		
		case (instr_type)
			INSTR_STATIC : begin
				case (op_code)
					OP_CODE_ADD 	: control_word <= CONTROL_ADD;	// ADD is normal
					OP_CODE_ADDU 	: control_word <= CONTROL_SUB;	// ADDU is normal
					OP_CODE_ADDC 	: begin
						control_word <= CONTROL_ADD;						// ADDC is normal with carry bit enabled
						carry_bit <= 'b1;
					end
					OP_CODE_SUB 	: control_word <= CONTROL_SUB;	// SUB is normal
					OP_CODE_SUBC 	: begin
						control_word <= CONTROL_SUB;						// SUBC is normal with carry bit enabled
						carry_bit <= 'b1;
					end
					OP_CODE_CMP		: control_word <= CONTROL_CMP;	// CMP is normal
					OP_CODE_AND		: control_word <= CONTROL_AND;	// AND is normal
					OP_CODE_OR		: control_word <= CONTROL_OR;		// OR is normal
					OP_CODE_XOR		: control_word <= CONTROL_XOR;	// XOR is normal
				endcase
			end
			INSTR_SHIFT : begin
				case (op_code)
					OP_CODE_LSH		: control_word <= CONTROL_LSH;	// LSH is normal
					OP_CODE_ALSHU	: begin
						control_word <= CONTROL_LSH;						// ALSH is normal and uses carry bit for RSH
						carry_bit <= 'b1;
					end
				endcase
			end
		endcase
	
	end
	
endmodule


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
	
	parameter CONTROL_ADD 	=	'b0000;
	parameter CONTROL_ADDU	=	'b0001;
	parameter CONTROL_SUB 	=	'b0010;
	parameter CONTROL_SUBU	=	'b0011;
	parameter CONTROL_CMP 	=	'b0100;
	parameter CONTROL_AND 	=	'b0101;
	parameter CONTROL_OR 	=	'b0110;
	parameter CONTROL_XOR	=	'b0111;
	parameter CONTROL_LSH 	=	'b1000;
		
	wire [WIDTH_DATA : 0] adder_sum, adder_diff;
	wire [WIDTH_DATA - 1 : 0] inv_B;
	wire low_flag, over_flag_sum, over_flag_diff, zero_flag, neg_flag;
	
	// Continuous Assignment Values
	// ADD / SUB
	assign adder_sum = A + B;
	assign adder_diff = A - B;
	
	assign inv_B = ~B + 1'b1;
	
	// Internal Computation of Flags
	// OVERFLOW
	assign over_flag_sum = (A[WIDTH_DATA - 1] == B[WIDTH_DATA - 1] ? ((A[WIDTH_DATA - 1] != result[WIDTH_DATA - 1]) ? 1'b1 : 1'b0) : 1'b0);
	assign over_flag_diff = (A[WIDTH_DATA - 1] == inv_B[WIDTH_DATA - 1] ? ((A[WIDTH_DATA - 1] != result[WIDTH_DATA - 1]) ? 1'b1 : 1'b0) : 1'b0)
	
	// ZERO
	assign zero_flag = (result == 0) ? 1'b1 : 1'b0;
	
	// LOW
	assign low_flag = A < B;
	
	// NEGATIVE
	assign neg_flag = result[WIDTH_DATA];
		
	always @(*) begin
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
				over_out <= over_flag_sum;
			end
			CONTROL_ADDU : begin
				{carry_out, result} <= adder_sum + carry_in;
			end
			CONTROL_SUB : begin
				result <= adder_diff[WIDTH_DATA - 1 : 0];
				over_out <= over_flag_diff;
			end
			CONTROL_SUBU : begin
				{carry_out, result} <= adder_diff - carry_in;
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
					result <= {carry_in, A} >> inv_B;
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