//
// tb_cpu.v
//
// This file contains all the implementation for the ALU for use in the ECE3710-CPU project.
//	The ALU module is defined here, as well as the supplementary ALU control module for generating
// ALU control words from the op_codes.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 15, 2024
//

module tb_cpu;
	//cpu param
	parameter REG_WIDTH = 16;
	parameter REG_ADDR_BITS = 3; // Changed from 4 to 3 for synthesis as we don't have enough pins for 4.
	parameter FILE_LOCATION = "X:/Documents/ECE3710/3710-cpu/ECE3710-CPU/reg.dat"; // Load a register file with values for FPGA testing.
	//contorl singals
	localparam CONTROL_ADD 	=	'b0000;
	localparam CONTROL_ADDU	=	'b0001;
	localparam CONTROL_SUB 	=	'b0010;
	localparam CONTROL_SUBU	=	'b0011;
	localparam CONTROL_CMP 	=	'b0100;
	localparam CONTROL_AND 	=	'b0101;
	localparam CONTROL_OR 	=	'b0110;
	localparam CONTROL_XOR	=	'b0111;
	localparam CONTROL_LSH 	=	'b1000;

	//input clk, reset,
	//input regWriteEnableButton, // Careful with this button as it runs at 50MHz.  IE; (0+1 = 1) * 50e^6 for 1 second.
	//input [3:0] aluControl,
	//input [REG_ADDR_BITS-1:0] regAddressA, regAddressB,
	
	//output [REG_WIDTH-1:0] aluRegOutput, // Needs to be removed to properly synthesize on the board.
	//output carryFlag, lowFlag, overflowFlag, negFlag, zeroFlag,
	//output [6:0] sevenSeg1, sevenSeg2, sevenSeg3, sevenSeg4
	
	reg 							tb_clk;
	reg 							tb_reset;
	reg 							tb_regWriteEnableButton;
	reg [3:0] 					tb_aluControl;
	reg [REG_ADDR_BITS-1:0]	tb_regAddressA;
	reg [REG_ADDR_BITS-1:0]	tb_regAddressB;
	
	wire 			tb_carryFlag;
	wire 			tb_lowFlag;
	wire 			tb_overflowFlag;
	wire 			tb_negFlag;
	wire 			tb_zeroFlag;
	wire [6:0]	tb_sevenSeg1;
	wire [6:0]	tb_sevenSeg2;
	wire [6:0]	tb_sevenSeg3;
	wire [6:0]	tb_sevenSeg4;
	
	cpu #(REG_WIDTH, REG_ADDR_BITS, FILE_LOCATION) DUT(
		.clk(tb_clk), //--------------------------------INPUTS vvv
		.reset(tb_reset),
		.regWriteEnableButton(tb_regWriteEnableButton), //dosnt do anything yet
		.aluControl(tb_aluControl),
		.regAddressA(tb_regAddressA),
		.regAddressB(tb_regAddressB),
		.carryFlag(tb_carryFlag), //--------------------OUTPUTS vvv
		.lowFlag(tb_lowFlag),
		.overflowFlag(tb_overflowFlag),
		.negFlag(tb_negFlag),
		.zeroFlag(tb_zeroFlag),
		.sevenSeg1(tb_sevenSeg1),
		.sevenSeg2(tb_sevenSeg2),
		.sevenSeg3(tb_sevenSeg3),
		.sevenSeg4(tb_sevenSeg4)
	);
	
	wire [REG_WIDTH - 1: 0] alu_result;
	assign alu_result = DUT.alu.result;
	
	initial begin
		// zero every input
		tb_clk = 0;
		tb_reset = 0;
		tb_regWriteEnableButton = 0;
		tb_aluControl = 0;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		#5;
		
		//NOTE: I have added
		
		$display("TEST: CONTROL_ADD");//-----------------------------------------
		$display("TEST: 0+0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = CONTROL_ADD;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		$display("result = %h", alu_result);
		
		$display("TEST: 1+1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = CONTROL_ADD;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		$display("result = %h", alu_result);
		
		$display("TEST: CONTROL_ADDU");//-----------------------------------------
		$display("TEST: FFFF+1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = CONTROL_ADDU;
		tb_regAddressA = 2;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		$display("result = %h", alu_result);
		
		
		/**
		$display("TEST: CONTROL_SUB");
		$display("TEST: CONTROL_SUBU");
		$display("TEST: CONTROL_CMP");
		$display("TEST: CONTROL_AND");
		$display("TEST: CONTROL_OR");
		$display("TEST: CONTROL_XOR");
		$display("TEST: CONTROL_LSH");
		**/
	end
	
endmodule