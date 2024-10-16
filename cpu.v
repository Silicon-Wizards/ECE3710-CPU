//
// cpu.v
//
// This module is the top-level-module for the ECE3710-CPU project and contains all of the connections
// necessary to synthesize the circuit onto the FPGA.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 17, 2024
//

module cpu #(
	parameter REG_WIDTH = 16,
	parameter REG_ADDR_BITS = 4,
	parameter FILE_LOCATION = "../reg.dat"
)(
	input clk, reset,
	input [4:0] aluControl,
	input [REG_ADDR_BITS-1:0] address1, address2,
	
	output [REG_WIDTH-1:0] regALUoutput,
	output carry, low, flag, zero, negative,
	output [6:0] sevenSeg1, sevenSeg2, sevenSeg3, sevenSeg4
);

	// Register datapath variables.
	wire regWriteEnable;
	wire [REG_WIDTH-1:0] regReadData1, regReadData2;
	
	// Instantiate the register file.
	registerFile #(REG_WIDTH, REG_ADDR_BITS, FILE_LOCATION) registers(clk, regWriteEnable, srcAddress, dstAddress, aluOutput, regReadData1, regReadData2);
	
	

	wire progCountEnable;
	wire [REG_WIDTH-1:0] pcIn;
	wire [REG_WIDTH-1:0]	pcOut;
	
	flopenr #(REG_WIDTH) programCounter(clk, reset, progCountEnable, aluOutput, pcOut);
	

	
	wire srcAddressEnable;
	wire [REG_WIDTH-1:0] srcAddress;
	
	flopenr2 #(REG_WIDTH) srcAddressReg(clk, reset, srcAddressEnable, address1, srcAddress);
	
	
	wire dstAddressEnable;
	wire [REG_WIDTH-1:0] dstAddress;
	
	flopenr2 #(REG_WIDTH) dstAddressReg(clk, reset, dstAddressEnable, address2, dstAddress); 
	

	
	wire immediateEnable;
	wire [REG_WIDTH-1:0] immIn;
	wire [REG_WIDTH-1:0]	immOut;
	
	flopenr #(REG_WIDTH) immediate(clk, reset, immediateEnable, immIn, immOut);
	
	
	
	wire mux_1Select;
	wire [REG_WIDTH-1:0] aluInputA;
	
	mux2 #(REG_WIDTH) mux_1(mux_1Select, pcOut, regReadData1, aluInputA);
	
	
	
	
	wire mux_2Select;
	wire [REG_WIDTH-1:0] aluInputB;
	
	mux2 #(REG_WIDTH) mux_2(mux_2Select, regReadData2, immOut, aluInputB);
	
	
	
	wire [REG_WIDTH-1:0] aluOutput;
	wire aluCarryIn, aluCarryOut, aluZeroOut;
	
	alu #(REG_WIDTH, REG_ADDR_BITS) alu(aluInputA, aluInputB, aluControl, aluCarryIn, aluOutput, aluCarryOut, aluZeroOut);
	
	
		
	wire regALUEnable;
	
	flopenr #(REG_WIDTH) regALU(clk, reset, regALUEnable, aluOutput, regALUoutput);
	
	
	hexTo7Seg sevenSegConverter1(regALUoutput[3:0], sevenSeg1);
	hexTo7Seg sevenSegConverter2(regALUoutput[7:4], sevenSeg2);
	hexTo7Seg sevenSegConverter3(regALUoutput[11:8], sevenSeg3);
	hexTo7Seg sevenSegConverter4(regALUoutput[15:12], sevenSeg4);
	
		
	
endmodule