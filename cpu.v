//
// cpu.v
//
// This module is the top-level-module for the ECE3710-CPU project and contains all of the connections
// necessary to synthesize the circuit onto the FPGA.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 13, 2024
//
module cpu #(
	parameter REG_WIDTH = 16,
	parameter REG_ADDR_BITS = 4,
	FILE_LOCATION = "D:/Classwork/ECE 3710/Projects/ECE3710-CPU/reg.dat"
)(
	input clk
);

	// Register datapath variables.
	wire regWriteEnable;
	wire [REG_ADDR_BITS-1:0] regAddress1, regAddress2;
	wire [REG_WIDTH-1:0] regWriteData, regReadData1, regReadData2;
	
	// Instantiate the register file.
	registerFile #(REG_WIDTH, REG_ADDR_BITS, FILE_LOCATION) registers(clk, regWriteEnable, regAddress1, regAddress2, regWriteData, regReadData1, regReadData2);
endmodule