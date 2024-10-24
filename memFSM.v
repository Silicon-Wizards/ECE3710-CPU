//
// memFSM.v
//
// (Explanation)
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 23, 2024
//

module memFSM #(
	parameter DATA_WIDTH = 16, 
	parameter ADDR_WIDTH = 16,
	parameter FILE_LOCAION = "FILL ME OUT!!"
)(
	input clk,
	input [3:0] setAddress
	input [3:0] writeData
	input portType, RWstatus
	
	output portLED, RWLED
	output [3:0] addressLED
	output [6:0] sevenSeg1, sevenSeg2, sevenSeg3, sevenSeg4
);