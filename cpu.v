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
									 instr_ir_dest_to_rf_aaddr, ir_instr_src_to_muxmem_rf_baddr_sign;
	
	// Memory Wires
	wire [REG_WIDTH-1:0] mem_dataout_to_ir_muxrf; 
	wire [MEM_ADDR_BITS-1:0] muxmem_to_mem_addr;
	
	// PC Wires
	wire [REG_WIDTH-1:0] muxpc_to_pc, pc_to_muxa_muxmem;
	
	// RF Wires
	wire [REG_WIDTH-1:0] muxrf_to_rf_datain, rf_areg_to_muxa_muximm_mem_datain,
								rf_breg_to_muxb_muxpc_muxrf, rf_areg_aluimmz_to_muxrf;
	
endmodule