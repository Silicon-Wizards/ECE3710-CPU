//
// memFSM.v
//
// (Explanation)
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 23, 2024
//

module memFSM #(
	// parameter DATA_WIDTH = 16, 
	// parameter ADDR_WIDTH = 16,
	parameter DATA_WIDTH = 4,
	parameter ADDR_WIDTH = 4,
	parameter FILE_LOCAION = "../ram.dat"
)(
	input clk,
	input [3:0] setAddress,
	input [3:0] inputData,
	input portType,				// portType=0 indicates portA, portType=1 indicates portB
	nextRWstatus,					// nextRWstatus=0 means next status will be READ
										// nextRWstatus=1 means next status will be WRITE
	input nextStateButton,
	
	output portLED,				// port LED turns off at portA, turns on at portB
	output reg RWLED,				// Read/Write LED turns off at Read state, turns on at Write state
	output [3:0] addressLED,
	output [6:0] readDataSeg1, readDataSeg2, writeDataSeg1, writeDataSeg2
);
	reg currentStatus;

	wire slowclk;
	clkDiv clockDivider (clk, slowclk);

	reg [DATA_WIDTH-1:0] data_a, data_b;
	reg [ADDR_WIDTH-1:0] addr_a, addr_b;
	reg writeEnable_a, writeEnable_b;
	wire [DATA_WIDTH-1:0] read_a, read_b;
	bram #(DATA_WIDTH, ADDR_WIDTH, FILE_LOCAION) blockMemory(
		.data_a(data_a), 
		.data_b(data_b),
		.addr_a(addr_a), 
		.addr_b(addr_b),
		.we_a(writeEnable_a), 
		.we_b(writeEnable_b), 
		.clk(slowclock),
		.q_a(read_a), 
		.q_b(read_b)
		);
	
	
	reg [DATA_WIDTH-1:0] readData;
	reg [DATA_WIDTH-1:0] writeData;
	
	always @ (posedge slowclk)
	begin
		if (~nextStateButton)
		begin
			if (currentStatus != nextRWstatus)
			begin
				currentStatus = ~currentStatus;
			end
		end
		
		else if (currentStatus == 0)			// READ state
		begin
			if (portType == 0)					// Port A
			begin
				writeEnable_a = 0;
				addr_a <= setAddress;
				readData <= read_a;
			end
			else										// Port B
			begin
				writeEnable_b = 0;
				addr_b <= setAddress;
				readData <= read_b;
			end
		end 
		
		else if (currentStatus == 1)			// WRITE state
		begin
			if (portType == 0)					// Port A
			begin
				writeEnable_a = 1;
				addr_a <= setAddress;
				data_a <= inputData;
				writeData <= data_a;
			end
			else										// Port B
			begin
				writeEnable_b = 1;
				addr_b <= setAddress;
				data_b <= inputData;
				writeData <= data_b;
			end
		end
		RWLED <= currentStatus;
	end
	
	hexTo7Seg2 sevenSegConverter1(readData, readDataSeg1, readDataSeg2);
	hexTo7Seg2 sevenSegConverter2(writeData, writeDataSeg1, writeDataSeg2);

endmodule