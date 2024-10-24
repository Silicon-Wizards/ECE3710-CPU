//
// cpu.v
//
// This module is the top-level-module for the ECE3710-CPU project and contains all of the connections
// necessary to synthesize the circuit onto the FPGA.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 28, 2024
//

module cpu #(
	parameter REG_WIDTH = 16,
	parameter REG_ADDR_BITS = 4,
	parameter REG_FILE_LOCATION = "../reg_values.dat",
	parameter MEM_ADDR_BITS = 16
)(
	input clk, reset
);

	// // Common Wire Definitions \\ \\
	
	// ALU Wires
	wire alucontrol_cin_to_alu;
	wire [3:0] alucontrol_op_to_alu, instr_aluopmux_to_alucontrol;
	wire [4:0] alu_flag_to_fsm;
	wire [7:0] alu_immz_to_muxrfimm;
	wire [REG_WIDTH-1:0] muxa_data_to_alua, muxb_data_to_alub, alu_imma_to_muxb, 
								alu_imml_to_muxb_muxrfimm, alu_result_to_muxrf_muxpc;
								
	// Instruction Wires
	wire [REG_WIDTH-1:0] instr_ir_to_fsm, muxrfimm_to_muxrf;
	wire [REG_ADDR_BITS-1:0] instr_ir_op_to_muxopalu, instr_ir_op_imm_to_muxopalu_sign,
									 instr_ir_dest_to_rf_aaddr, instr_ir_src_to_muxmem_rf_baddr_sign;
	
	// Memory Wires
	wire [REG_WIDTH-1:0] mem_dataout_to_ir_muxrf; 
	wire [MEM_ADDR_BITS-1:0] muxmem_to_mem_addr;
	
	// PC Wires
	wire [REG_WIDTH-1:0] muxpc_to_pc, pc_to_muxa_muxmem;
	
	// RF Wires
	wire [REG_WIDTH-1:0] muxrf_to_rf_datain, rf_areg_to_muxa_muxrfimm_mem_datain,
								rf_breg_to_muxb_muxpc_muxrf, rf_areg_aluimmz_to_muxrfimm;
								
	
	// // Control Wires \\ \\
	
	// ALU Control Wires
	
	
	// Instruction Control Wires
	wire ir_we;
	
	// Memory Control Wires
	
	
	// PC Control Wires
	
	
	// RF Control Wires
	wire rf_we;
	wire muxrfimm_select;
	wire [1:0] muxrf_select;
	
	
	// // ALU Unit \\ \\
	
	mux2 muxA(
		.select(), // Needs a wire...
		.dataA(rf_areg_to_muxa_muxrfimm_mem_datain),
		.dataB(pc_to_muxa_muxmem),
		.dataOut(muxa_data_to_alua)
	);
	
	mux4 muxB(
		.select(), // Needs a wire...
		.dataA(rf_breg_to_muxb_muxpc_muxrf),
		.dataB(alu_imml_to_muxb_muxrfimm),
		.dataC(alu_imma_to_muxb),
		.dataD(16'b0000000000000001),
		.dataOut(muxb_data_to_alub)
	);
	
	mux2 #(4) muxopalu(
		.select(), // Needs a wire...
		.dataA(instr_ir_op_imm_to_muxopalu_sign),
		.dataB(instr_ir_op_to_muxopalu),
		.dataOut(instr_aluopmux_to_alucontrol)
	);
	
	alu_control alu_controller(
		.op_code(instr_aluopmux_to_alucontrol),
		.instr_type(), // Needs a wire...
		.control_word(alucontrol_op_to_alu),
		.carry_bit(alucontrol_cin_to_alu)
	);
	
	alu alu(
		.A(muxa_data_to_alua),
		.B(muxb_data_to_alub),
		.control_word(alucontrol_op_to_alu),
		.carry_in(alucontrol_cin_to_alu),
		.result(alu_result_to_muxrf_muxpc),
		.carry_out(alu_flag_to_fsm[0]),
		.low_out(alu_flag_to_fsm[1]),
		.over_out(alu_flag_to_fsm[2]),
		.neg_out(alu_flag_to_fsm[3]),
		.zero_out(alu_flag_to_fsm[4])
	);
	
	
	
	
	// // Immediate Calculation Area \\ \\
	
//	assign alu_imma_to_muxb = {{6{1'b10}}, instr_ir_src_to_muxmem_rf_baddr_sign}; // Replace the {6{1'b10}} with the sign extender's output when it is made.
//	assign alu_imml_to_muxb_muxrfimm = {{8{1'b0}}, alu_immz_to_muxrfimm};
//	assign alu_immz_to_muxrfimm = {instr_ir_op_imm_to_muxopalu_sign, instr_ir_src_to_muxmem_rf_baddr_sign};
	
	signExtender #(
		REG_ADDR_BITS,
		REG_WIDTH - REG_ADDR_BITS
	)
	sign
	(
		.input_data(instr_ir_op_imm_to_muxopalu_sign),
		.output_data(alu_imma_to_muxb[15:4])
	);
	
	assign alu_immz_to_muxrfimm = {instr_ir_op_imm_to_muxopalu_sign, instr_ir_src_to_muxmem_rf_baddr_sign};
	assign alu_imml_to_muxb_muxrfimm = {{8{1'b0}}, alu_immz_to_muxrfimm};
	assign alu_imma_to_muxb[3:0] = instr_ir_src_to_muxmem_rf_baddr_sign;
	
	// // Instruction Register \\ \\
	
	flopenr ir(
		.clk(clk),
		.reset(reset),
		.enable(ir_we),
		.dataIn(mem_dataout_to_ir_muxrf),
		.dataOut(instr_ir_to_fsm)
	);
	
	assign instr_ir_op_to_muxopalu = 					instr_ir_to_fsm[15:12];
	assign instr_ir_dest_to_rf_aaddr = 					instr_ir_to_fsm[11:8];
	assign instr_ir_op_imm_to_muxopalu_sign =			instr_ir_to_fsm[7:4]; 
	assign instr_ir_src_to_muxmem_rf_baddr_sign = 	instr_ir_to_fsm[3:0];

	
	// // Program Counter \\ \\
	
	mux2 muxPC(
		.select(), // Needs a wire...
		.dataA(alu_result_to_muxrf_muxpc),
		.dataB(rf_breg_to_muxb_muxpc_muxrf),
		.dataOut(muxpc_to_pc)
	);
	
	flopenr pc(
		.clk(clk),
		.reset(reset),
		.enable(), // Needs a wire...
		.dataIn(muxpc_to_pc),
		.dataOut(pc_to_muxa_muxmem)
	);

	
	
	// // REGISTER FILE \\ \\
	
	// Register File Data In MUX ( NAME = "muxrf" )
	mux4 #(
		REG_WIDTH
	)
		muxrf
	(
		.select(muxrf_select),
		.dataA(alu_result_to_muxrf_muxpc),
		.dataB(mem_dataout_to_ir_muxrf),
		.dataC(rf_breg_to_muxb_muxpc_muxrf),
		.dataD(muxrfimm_to_muxrf),
		.dataOut(muxrf_to_rf_datain)
	);
	
	// Register File ( NAME = "rf" )
	registerFile #(
		REG_WIDTH,
		REG_ADDR_BITS,
		REG_FILE_LOCATION
	)
		rf
	(
		.clk(clk),
		.writeEnable(rf_we),
		.address1(instr_ir_dest_to_rf_aaddr),
		.address2(instr_ir_src_to_muxmem_rf_baddr_sign),
		.writeData(muxrf_to_rf_datain),
		.readData1(rf_areg_to_muxa_muxrfimm_mem_datain),
		.readData2(rf_breg_to_muxb_muxpc_muxrf)
	);
	
	// MOVI / LUI Immediate Calculation
	
	assign rf_areg_aluimmz_to_muxrfimm = {alu_immz_to_muxrfimm, rf_areg_to_muxa_muxrfimm_mem_datain[7:0]};
	
	// Register File Immediate Data MUX ( NAME = "muxrfimm" )
	mux2 #(
		REG_WIDTH
	)
		muxrfimm
	(
		.select(muxrfimm_select),
		.dataA(alu_imml_to_muxb_muxrfimm),
		.dataB(rf_areg_aluimmz_to_muxrfimm),
		.dataOut(muxrfimm_to_muxrf)
	);
	
endmodule


module signExtender #(
	parameter INPUT_WIDTH,
	parameter OUTPUT_WIDTH
)(
	input [INPUT_WIDTH - 1: 0] input_data,
	output [OUTPUT_WIDTH - 1: 0] output_data
);

	assign output_data = {{(OUTPUT_WIDTH - INPUT_WIDTH){input_data[INPUT_WIDTH - 1]}}, input_data};

endmodule