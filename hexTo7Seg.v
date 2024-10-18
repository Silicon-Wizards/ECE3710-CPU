//
// hexTo7Seg.v
//
// This module takes a signle (4-bit) binary value and displays it onto a 7-segment display as a hex number.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 17, 2024
//

module hexTo7Seg(
	input [3:0] binaryValue,   // Input binary number
	output reg [6:0] hexOutput // Output 7-seg display number
);

  always @(*) begin
	 // Since the 7-seg displays are active low, invert the below values as 1 is used as active below.
    case(binaryValue)
      4'b0000 : hexOutput = ~7'b0111111; // 0
      4'b0001 : hexOutput = ~7'b0000110; // 1
      4'b0010 : hexOutput = ~7'b1011011; // 2
      4'b0011 : hexOutput = ~7'b1001111; // 3
      4'b0100 : hexOutput = ~7'b1100110; // 4
      4'b0101 : hexOutput = ~7'b1101101; // 5
      4'b0110 : hexOutput = ~7'b1111101; // 6
      4'b0111 : hexOutput = ~7'b0000111; // 7
      4'b1000 : hexOutput = ~7'b1111111; // 8
      4'b1001 : hexOutput = ~7'b1100111; // 9
      4'b1010 : hexOutput = ~7'b1110111; // A
      4'b1011 : hexOutput = ~7'b1111100; // b
      4'b1100 : hexOutput = ~7'b1011000; // c
      4'b1101 : hexOutput = ~7'b1011110; // d
      4'b1110 : hexOutput = ~7'b1111001; // E
      4'b1111 : hexOutput = ~7'b1110001; // F
      default : hexOutput = ~7'b0000000; // Always good to have a default! 
    endcase
	end
endmodule // hexTo7Seg