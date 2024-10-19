//
// registerFile.v
//
// This module defines a true dual-port memory register file for use in the ECE3710-CPU project.
// (Or at least it will once we track down the bram.v file)
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 14, 2024
//

module registerFile #(
	parameter WIDTH = 16, 
	parameter ADDR_BITS = 4,
	parameter FILE_LOCATION = "FILL ME OUT!!"
)(
	input clk,
	input writeEnable,
	input  [ADDR_BITS-1:0] address1, address2,
	input  [WIDTH-1:0] writeData,
	output [WIDTH-1:0] readData1, readData2
);
	// Create the RAM block that will hold the register file.
	reg  [WIDTH-1:0] RAM [(1<<ADDR_BITS)-1:0];
	
	// Fill the RAM block with the initial values of the registers specified by a file.
	initial begin
		$display("Loading the register file...");
		$readmemb(FILE_LOCATION, RAM);
		$display("Finished loading the register file!"); 
	end	

	// Write to the second register sequentially.
	always @(posedge clk)
      if (writeEnable) RAM[address2] <= writeData;
		
	// Read the values of both registers combinationally.
	assign readData1 = RAM[address1];
	assign readData2 = RAM[address2];
endmodule