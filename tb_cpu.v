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
	//OP codes
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
		.aluOpCode(tb_aluControl),
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
	assign alu_result = DUT.aluRegOutput;
	
	initial begin
	
		// zero every input
		tb_clk = 0;
		tb_reset = 0;
		tb_regWriteEnableButton = 1;
		tb_aluControl = 0;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		#5;
		
		
		$display("TEST: OP_CODE_ADD");//----------------------------------------------------------------------------------
		$display("TEST: 0+0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_ADD;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1+1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_ADD;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 2) 
			$display("ERROR!! result = %h should be 2", alu_result);
		$display("");
		
		$display("TEST: OP_CODE_ADDU");//----------------------------------------------------------------------------------
		$display("TEST: 0+0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_ADDU;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1+1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_ADDU;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 2) 
			$display("ERROR!! result = %h should be 2", alu_result);
		$display("");
		
		
		$display("TEST: OP_CODE_SUB");//----------------------------------------------------------------------------------
		$display("TEST: 0-0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_SUB;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1-1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_SUB;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1-0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_SUB;
		tb_regAddressA = 1;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		
		$display("TEST: OP_CODE_CMP");//----------------------------------------------------------------------------------
		$display("TEST: 1-0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_CMP;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		
		$display("TEST: OP_CODE_AND");//----------------------------------------------------------------------------------
		$display("TEST: 0 & 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_AND;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 & 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_AND;
		tb_regAddressA = 1;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 0 & 1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_AND;
		tb_regAddressA = 1;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 & 1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_AND;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		//-------------
		$display("TEST: 2 & 2");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_AND;
		tb_regAddressA = 2;
		tb_regAddressB = 2;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 2) 
			$display("ERROR!! result = %h should be 2", alu_result);
		$display("");
		//-------------
		$display("TEST: 3 & 3");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_AND;
		tb_regAddressA = 3;
		tb_regAddressB = 3;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 3) 
			$display("ERROR!! result = %h should be 3", alu_result);
		$display("");
		
		$display("TEST: OP_CODE_OR");//----------------------------------------------------------------------------------
		$display("TEST: 0 | 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_OR;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 | 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_OR;
		tb_regAddressA = 1;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		//-------------
		$display("TEST: 0 | 1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_OR;
		tb_regAddressA = 1;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 | 1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_OR;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		//-------------
		$display("TEST: 2 | 2");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_OR;
		tb_regAddressA = 2;
		tb_regAddressB = 2;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 2) 
			$display("ERROR!! result = %h should be 2", alu_result);
		$display("");
		//-------------
		$display("TEST: 3 | 3");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_OR;
		tb_regAddressA = 3;
		tb_regAddressB = 3;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 3) 
			$display("ERROR!! result = %h should be 3", alu_result);
		$display("");
		
		
		$display("TEST: OP_CODE_XOR");//----------------------------------------------------------------------------------
		$display("TEST: 0 ^ 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_XOR;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 ^ 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_XOR;
		tb_regAddressA = 1;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 1) 
			$display("ERROR!! result = %h should be 1", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 ^ 1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_XOR;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 2 ^ 2");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_XOR;
		tb_regAddressA = 2;
		tb_regAddressB = 2;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 3 ^ 3");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_XOR;
		tb_regAddressA = 3;
		tb_regAddressB = 3;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		
		/** to use these we need to edit the cpu instruction type to be 1
		$display("TEST: OP_CODE_LSH");//----------------------------------------------------------------------------------
		
		$display("TEST: 0 << 0");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_LSH;
		tb_regAddressA = 0;
		tb_regAddressB = 0;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 0) 
			$display("ERROR!! result = %h should be 0", alu_result);
		$display("");
		//-------------
		$display("TEST: 1 << 1");
		tb_reset = 0; #5; tb_reset = 1; #5; tb_reset = 0; #5; //reset
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_aluControl = OP_CODE_LSH;
		tb_regAddressA = 1;
		tb_regAddressB = 1;
		tb_clk = 0; #5; tb_clk = 1; #5;
		tb_clk = 0; #5; tb_clk = 1; #5;
		if(alu_result != 2) 
			$display("ERROR!! result = %h should be 2", alu_result);
		$display("");
		**/
	end
	
endmodule