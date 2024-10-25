//
// Module for modifying the clock speed that affects the display speed
//
module clkDiv (
	input 	  fastclk,				// 50MHz built-in clock

	output reg slowclk		// clock with modified frequency
);

reg [25 : 0] count;			// counter for the always loop


// always will be based on the fastclk(50MHz)
// adds 1 on count reg on every loop
// will give a tick on the slowclock when count reg reaches certain value
always @ (posedge fastclk)
begin

count <= count + 1;

if(count == 10000000)
	begin
		slowclk <= ~slowclk;
		count <= 0;				// give a tick and reset the counter to 0
	end
	
end // always

endmodule // Clk_div
