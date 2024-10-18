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
	input immediate,
	input [4:0] aluControl,
	input [REG_ADDR_BITS-1:0] regAddressA, regAddressB,
	
	output [REG_WIDTH-1:0] aluRegOutput,
	output carry, low, flag, zero, negative,
	output [6:0] sevenSeg1, sevenSeg2, sevenSeg3, sevenSeg4
);

	// Instantiate the source address register.
	wire srcAddressRegEnable;
	wire [REG_ADDR_BITS-1:0] srcAddressRegOutput;
	flopenr #(REG_ADDR_BITS) srcAddressReg(clk, reset, srcAddressRegEnable, regAddressA, srcAddressRegOutput);

	// Instantiate the destination address register.
	wire dstAddressRegEnable;
	wire [REG_ADDR_BITS-1:0] dstAddressRegOutput;
	flopenr #(REG_ADDR_BITS) dstAddressReg(clk, reset, dstAddressRegEnable, regAddressB, dstAddressRegOutput); 

	// Instantiate a register to hold an immediate value (currently unused).
	wire immediateRegEnable;
	wire [REG_WIDTH-1:0]	immediateRegOut;
	flopenr #(REG_WIDTH) immediateReg(clk, reset, immediateRegEnable, immediate, immediateRegOut);
	
	// Instantiate the program counter (currently unused).
	wire pcEnable;
	wire [REG_WIDTH-1:0] pcOut;
	flopenr #(REG_WIDTH) programCounter(clk, reset, pcEnable, aluOutput, pcOut);

	// Instantiate the register file and connect it to the datapath.
	wire regWriteEnable;
	wire [REG_WIDTH-1:0] regReadData1, regReadData2;
	registerFile #(REG_WIDTH, REG_ADDR_BITS, FILE_LOCATION) registers(clk, regWriteEnable, srcAddressRegOutput, dstAddressRegOutput, aluOutput, regReadData1, regReadData2);

	// Instantiate a MUX for the ALU's A input.
	wire aluInputAMuxSelect;
	wire [REG_WIDTH-1:0] aluInputA;
	mux2 #(REG_WIDTH) aluInputAMux(aluInputAMuxSelect, regReadData1, pcOut, aluInputA);
	
	// Instantiate a MUX for the ALU's B input.
	wire aluInputBMuxSelect;
	wire [REG_WIDTH-1:0] aluInputB;
	mux2 #(REG_WIDTH) aluInputBMux(aluInputBMuxSelect, regReadData2, immediateRegOut, aluInputB);
	
	// Instantiate the ALU and connect it to the datapath.
	wire [REG_WIDTH-1:0] aluOutput;
	wire aluCarryIn, aluCarryOut, aluZeroOut;
	alu #(REG_WIDTH, REG_ADDR_BITS) alu(aluInputA, aluInputB, aluControl, aluCarryIn, aluOutput, aluCarryOut, aluZeroOut);
		
	// Instantiate a register to hold the ALU's output.
	wire aluOutputRegEnable;
	flopenr #(REG_WIDTH) aluOutputReg(clk, reset, aluOutputRegEnable, aluOutput, aluRegOutput);
	
	// Instantiate some hex-to-7-seg converters to display the result of the ALU.
	hexTo7Seg sevenSegConverter1(aluRegOutput[3:0], sevenSeg1);
	hexTo7Seg sevenSegConverter2(aluRegOutput[7:4], sevenSeg2);
	hexTo7Seg sevenSegConverter3(aluRegOutput[11:8], sevenSeg3);
	hexTo7Seg sevenSegConverter4(aluRegOutput[15:12], sevenSeg4);
	
	// Tie some of the enable signals of the registers to high as there is no master control unit to do so.
	assign srcAddressRegEnable = 1;
	assign dstAddressRegEnable = 1;
	assign immediateRegEnable  = 1;
	assign aluOutputRegEnable  = 1;
	assign regWriteEnable      = 1;
	
	// Tie the PC's enable signal to low as we aren't using it yet.
	assign pcEnable = 0;
endmodule