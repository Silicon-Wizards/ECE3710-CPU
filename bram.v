//
// bram.v
//
// This module is a dual port RAM with single clock.
//
// Authors:  Kenneth Gordon, Adrian Sucahyo, Bryant Watson, and Inhyup Lee
// Date:  October 23, 2024
//

module bram #(
	parameter DATA_WIDTH = 16, 
	parameter ADDR_WIDTH = 16,
	parameter FILE_LOCATION = "../ram.dat"
)(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
	
	// Fill the ram block with the initial values specified by a file.
	initial begin
		$display("Loading the ram file...");
		$readmemb(FILE_LOCATION, ram);
		$display("Finished loading the ram file!"); 
	end

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
