//
// datapathComponents.v
//
// This file contains the definitions of various datapath components for use in the ECE3710-CPU project.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 14, 2024
//

module flopenr #(parameter WIDTH = 16)(
	input                  clk, reset, enable,
   input      [WIDTH-1:0] dataIn, 
   output reg [WIDTH-1:0] dataOut
);
 
	// Create a register that is capable of being enabled and reset.
   always @(posedge clk) begin
		if (reset)
			dataOut <= 0;
		else if (enable)
			dataOut <= dataIn;
	end
endmodule // flopenr

module mux2 #(parameter WIDTH = 16)(
	input              select,
	input  [WIDTH-1:0] dataA, dataB,
	output [WIDTH-1:0] dataOut
);
	// Mux based off of the value of the select signal.
	assign dataOut = select ? dataB : dataA;
endmodule // mux2

module mux4 #(parameter WIDTH = 16)(
	input      [1:0]       select,
	input      [WIDTH-1:0] dataA, dataB, dataC, dataD,
	output reg [WIDTH-1:0] dataOut
);
	// Mux based off of the value of the select signal.
	always @(*) begin
		case(select)
			2'b00: dataOut <= dataA;
			2'b01: dataOut <= dataB;
			2'b10: dataOut <= dataC;
			2'b11: dataOut <= dataD;
		endcase
	end
endmodule // mux4

