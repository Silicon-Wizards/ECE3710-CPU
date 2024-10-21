//
// cpu.v
//
// This module is the top-level-module for the ECE3710-CPU project and contains all of the connections
// necessary to synthesize the circuit onto the FPGA.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 18, 2024
//

module cpu #(
	parameter REG_WIDTH = 16,
	parameter REG_ADDR_BITS = 3, // Changed from 4 to 3 for synthesis as we don't have enough pins for 4.
	parameter FILE_LOCATION = "../reg_values.dat" // Load a register file with values for FPGA testing.
)(
	input clk, reset,
	input regWriteEnableButton, // Careful with this button as it runs at 50MHz.  IE; (0+1 = 1) * 50e^6 for 1 second.
	input [3:0] aluControl,
	input [REG_ADDR_BITS-1:0] regAddressA, regAddressB,
	
	//output [REG_WIDTH-1:0] aluRegOutput, // Needs to be removed to properly synthesize on the board.
	output carryFlag, lowFlag, overflowFlag, negFlag, zeroFlag,
	output [6:0] sevenSeg1, sevenSeg2, sevenSeg3, sevenSeg4
);

	// Temporary fix as this shouldn't be an output when we synthesize it on the board.
	// This is because we simply don't have enough outputs for this value on the board.
	// Keeping it will actually break the FPGA's displays (it will display wrong info).
	wire [REG_WIDTH-1:0] aluRegOutput;

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
	
	// wire regWriteEnable; // Temporarily removed for board synthesis.
	assign regWriteEnable = ~regWriteEnableButton; // Button is active low, signal is active high.
	
	wire [REG_WIDTH-1:0] regReadData1, regReadData2;
	registerFile #(REG_WIDTH, REG_ADDR_BITS, FILE_LOCATION) registers(
		.clk(clk),
		.writeEnable(regWriteEnable),
		.address1(srcAddressRegOutput),
		.address2(dstAddressRegOutput),
		.writeData(aluOutput),
		.readData1(regReadData1),
		.readData2(regReadData2)
	);

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
	wire [REG_ADDR_BITS-1:] aluControl;
	wire aluCarryIn;
	alu #(REG_WIDTH, REG_ADDR_BITS) alu(
		.A(aluInputA),
		.B(aluInputB),
		.control_word(aluControl),
		.carry_in(aluCarryIn),
		.result(aluOutput),
		.carry_out(carryFlag),
		.low_out(lowFlag),
		.over_out(overflowFlag),
		.neg_out(negFlag),
		.zero_out(zeroFlag)
	);
		
	// Instantiate a register to hold the ALU's output.
	wire aluOutputRegEnable;
	flopenr #(REG_WIDTH) aluOutputReg(clk, reset, aluOutputRegEnable, aluOutput, aluRegOutput);
	
	// Instantiate some hex-to-7-seg converters to display the result of the ALU.
	hexTo7Seg sevenSegConverter1(aluRegOutput[3:0],   sevenSeg1);
	hexTo7Seg sevenSegConverter2(aluRegOutput[7:4],   sevenSeg2);
	hexTo7Seg sevenSegConverter3(aluRegOutput[11:8],  sevenSeg3);
	hexTo7Seg sevenSegConverter4(aluRegOutput[15:12], sevenSeg4);
	
	// Control signal logic
	// Since we don't have a controller, you'll have to manually configure these values
	// We don't have enough inputs on the FPGA to make each of these values configurable for this circuit.
	
	// Tie some of the enable signals of the registers to high as there is no master control unit to do so.
	assign srcAddressRegEnable = 1;
	assign dstAddressRegEnable = 1;
	assign aluOutputRegEnable  = 1;
	
	// Tie the PC's enable signal and the immediate register's enable signal to low as we aren't using them.
	assign pcEnable           = 0;
	assign immediateRegEnable = 0;
	
	// Set the ALU MUX values to only use the register values.
	assign aluInputAMuxSelect = 0;
	assign aluInputBMuxSelect = 0;
	
endmodule