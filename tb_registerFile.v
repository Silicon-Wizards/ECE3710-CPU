module tb_registerFile;
	//	parameter WIDTH = 16, 
	// parameter ADDR_BITS = 4,
	
	//Globals
	integer i;
	parameter WIDTH = 16;
	parameter ADDR_BITS = 4;
	parameter FILE_LOCATION = "D:/Classwork/ECE 3710/Projects/ECE3710-CPU/reg.dat";
	
	reg 						tb_clk;				// input clk,
	reg 						tb_writeEnable;	// input writeEnable,
	reg [ADDR_BITS-1:0] 	tb_address1;		// input  [ADDR_BITS-1:0] address1,
	reg [ADDR_BITS-1:0] 	tb_address2;		// input  [ADDR_BITS-1:0] address2,
	reg [WIDTH-1:0]		tb_writeData;		// input  [WIDTH-1:0] writeData,
	
	wire [WIDTH-1:0] 		tb_readData1;		// output [WIDTH-1:0] readData1,
	wire [WIDTH-1:0] 		tb_readData2;		// output [WIDTH-1:0] readData2
	

	
	registerFile #(WIDTH, ADDR_BITS, FILE_LOCATION) DUT (
		.clk(tb_clk),						//inputs
		.writeEnable(tb_writeEnable),
		.address1(tb_address1),
		.address2(tb_address2),
		.writeData(tb_writeData),
		.readData1(tb_readData1),		//outputs
		.readData2(tb_readData2));
	
	initial begin
		//Write 0-15 into each reg
		for(i = 0; i < WIDTH; i = i + 1) begin
			tb_writeEnable = 0;
			tb_address1 	= 0;
			tb_address2 	= 0;
			tb_writeData 	= 0;
			tb_clk = 1'b0; #1; tb_clk = 1'b1; #1;
			tb_writeEnable = 1;
			tb_address1 	= 0;
			tb_address2 	= i;
			tb_writeData 	= i;
			tb_clk = 1'b0; #1; tb_clk = 1'b1; #1;
		end
		tb_writeEnable = 0;
		tb_address1 	= 0;
		tb_address2 	= 0;
		tb_writeData 	= 0;
		
		//Test Read
		for(i = 0; i < WIDTH; i = i + 1) begin
			tb_address1 	= i;
			tb_clk = 1'b0; #1; tb_clk = 1'b1; #1;
			if(i != tb_readData1)
				$display("ERROR!!! NOT GOOD: index: %d  tb_readData1: %h should be %i", i, tb_readData1, i);
		end
	end
endmodule