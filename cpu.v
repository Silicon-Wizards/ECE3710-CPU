//
// cpu.v
//
// This module is the top-level-module for the ECE3710-CPU project and contains all of the connections
// necessary to synthesize the circuit onto the FPGA.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 14, 2024
//

module cpu #(
	parameter REG_WIDTH = 16,
	parameter REG_ADDR_BITS = 4,
	parameter FILE_LOCATION = "../reg.dat"
)(
	input clk, reset,
	output [REG_WIDTH-1:0] regALUoutput
);

	// Register datapath variables.
	wire regWriteEnable;
	wire [REG_ADDR_BITS-1:0] regAddress1, regAddress2;
	wire [REG_WIDTH-1:0] regWriteData, regReadData1, regReadData2;
	
	// Instantiate the register file.
	registerFile #(REG_WIDTH, REG_ADDR_BITS, FILE_LOCATION) registers(clk, regWriteEnable, regAddress1, regAddress2, regWriteData, regReadData1, regReadData2);
	
	

	wire progCountEnable;
	wire [REG_WIDTH-1:0] pcIn;
	wire [REG_WIDTH-1:0]	pcOut;
	
	flopenr #(REG_WIDTH) programCounter(clk, reset, progCountEnable, pcIn, pcOut);
	
	
	
	wire immediateEnable;
	wire [REG_WIDTH-1:0] immIn;
	wire [REG_WIDTH-1:0]	immOut;
	
	flopenr #(REG_WIDTH) immediate(clk, reset, immediateEnable, immIn, immOut);
	
	
	
	wire mux_1Select;
	wire [REG_WIDTH-1:0] mux_1Out; // change var name
	
	mux2 #(REG_WIDTH) mux_1(mux_1Select, pcOut, regReadData1, mux_1Out);
	
	
	
	wire mux_2Select;
	wire [REG_WIDTH-1:0] mux_2Out; // change var name
	
	mux2 #(REG_WIDTH) mux_2(mux_2Select, regReadData2, immOut, mux_1Out);
	
	
	
	wire regALUEnable;
	wire [REG_WIDTH-1:0] regALUIn 	// ALU output
	
	flopenr #(REG_WIDTH) regALU(clk, reset, regALUEnable, regALUIn, regALUoutput);
	
	
endmodule