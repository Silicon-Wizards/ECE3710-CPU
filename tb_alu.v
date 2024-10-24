module tb_alu;
	//parameters
	parameter WIDTH_DATA = 16;
	parameter WIDTH_CONTROL = 4;
	
	localparam CONTROL_ADD 	=	'b0;
	localparam CONTROL_ADDU	=	'b1;
	localparam CONTROL_SUB 	=	'b10;
	localparam CONTROL_SUBU	=	'b11;
	localparam CONTROL_CMP 	=	'b100;
	localparam CONTROL_AND 	=	'b101;
	localparam CONTROL_OR 	=	'b110;
	localparam CONTROL_XOR	=	'b111;
	localparam CONTROL_LSH 	=	'b1000;
	//tb_parameters
	integer i;
	integer j;
	
	reg [WIDTH_DATA - 1 : 0]		tb_A; 				//input [WIDTH_DATA - 1 : 0] A, B
	reg [WIDTH_DATA - 1 : 0] 		tb_B; 				//input [WIDTH_DATA - 1 : 0] A, B
	reg [WIDTH_CONTROL - 1 : 0]	tb_control_word;	//input [WIDTH_CONTROL - 1 : 0] control_word
	reg 									tb_carry_in; 		//input carry_in,
	
	wire [WIDTH_DATA - 1 : 0] 		tb_result;			//output reg [WIDTH_DATA - 1 : 0] result
	wire 									tb_carry_out;		//output reg carry_out, zero_out
	wire 									tb_low_out;
	wire									tb_over_out;
	wire									tb_neg_out;
	wire 									tb_zero_out;		//output reg carry_out, zero_out

	alu #(WIDTH_DATA, WIDTH_CONTROL) DUT(
		.A(tb_A),
		.B(tb_B),
		.control_word(tb_control_word),
		.carry_in(tb_carry_in),
		.result(tb_result),
		.carry_out(tb_carry_out),
		.low_out(tb_low_out),
		.over_out(tb_over_out),
		.neg_out(tb_neg_out),
		.zero_out(tb_zero_out)
	);
	
	initial begin
		
		assign DUT.low_flag = 1'b0;
		
//		$display("TEST: and");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_AND;
//		for(i = 0; i < 4; i = i + 1) begin
//			for(j = 0; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] & j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] & j[15:0]));
//			end
//		end
//		
//		$display("TEST OR");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_OR;
//		for(i = 0; i < 4; i = i + 1) begin
//			for(j = 0; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] | j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] | j[15:0]));
//			end
//		end
//		
//		$display("TEST XOR");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_XOR;
//		for(i = 0; i < 4; i = i + 1) begin
//			for(j = 0; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] ^ j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] ^ j[15:0]));
//			end
//		end
//		
//		$display("TEST LSH");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_LSH;
//		for(i = 0; i < 4; i = i + 1) begin
//			for(j = 0; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] << j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] << j[15:0]));
//			end
//		end	
//		
//		$display("TEST ADDU");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		for(i = 0; i < 4; i = i + 1) begin
//			for(j = 0; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] + j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] + j[15:0]));
//			end
//		end
//		
//		$display("TEST ADD");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		for(i = -4; i < 4; i = i + 1) begin
//			for(j = -4; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] + j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] + j[15:0]));
//			end
//		end
//		
//		$display("TEST SUBU");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		for(i = 0; i < 4; i = i + 1) begin
//			for(j = 0; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] - j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] - j[15:0]));
//			end
//		end
//		
//		$display("TEST SUB");
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		for(i = -4; i < 4; i = i + 1) begin
//			for(j = -4; j < 4; j = j + 1) begin
//				tb_A = i;
//				tb_B = j;
//				#5;
//				if(tb_result != (i[15:0] - j[15:0]))
//					$display("ERROR!!: i: %h \t j: %h \t result: %h, \t should be: %h", i, j, tb_result, (i[15:0] - j[15:0]));
//			end
//		end
//		
//		$display("TEST CF- unsigned overflow"); //---------------------------------------------------------------------------------------------------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFFF; 
//		tb_B = 16'h0001;
//		#5;
//		if(tb_carry_out != 1) $display("ERROR!! CF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 1; //<<--Carry in
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFFF; 
//		tb_B = 16'h0000;
//		#5;
//		if(tb_carry_out != 1) $display("ERROR!! CF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFFF; 
//		tb_B = 16'h0002;
//		#5;
//		if(tb_carry_out != 1) $display("ERROR!! CF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFFE; 
//		tb_B = 16'h0001;
//		#5;
//		if(tb_carry_out != 0) $display("ERROR!! CF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 1;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFFE; 
//		tb_B = 16'h0001;
//		#5;
//		if(tb_carry_out != 1) $display("ERROR!! CF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFFF; 
//		tb_B = 16'h0000;
//		#5;
//		if(tb_carry_out != 0) $display("ERROR!! CF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0000; 
//		tb_B = 16'h0001;
//		#5;
//		if(tb_carry_out != 1) $display("ERROR!! CF flag: %h not set correctly should be 1", tb_carry_out);
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0000; 
//		tb_B = 16'h0002;
//		#5;
//		if(tb_carry_out != 1) $display("ERROR!! CF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0001; 
//		tb_B = 16'h0001;
//		#5;
//		if(tb_carry_out != 0) $display("ERROR!! CF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0000; 
//		tb_B = 16'h0000;
//		#5;
//		if(tb_carry_out != 0) $display("ERROR!! CF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		
//		$display("TEST OF- signed overflow"); //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h7FFF;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_over_out != 1) $display("ERROR!! OF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 1; //<<--Carry in
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h7FFF;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_over_out != 1) $display("ERROR!! OF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h7FFF;
//		tb_B = 16'h0002;
//		#5;
//		if(tb_over_out != 1) $display("ERROR!! OF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h7FFE;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_over_out != 0) $display("ERROR!! OF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 1; //<<--Carry in
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h7FFE;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_over_out != 1) $display("ERROR!! OF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h7FFF;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_over_out != 0) $display("ERROR!! OF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h8000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_over_out != 1) $display("ERROR!! OF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h8000;
//		tb_B = 16'h0002;
//		#5;
//		if(tb_over_out != 1) $display("ERROR!! OF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h8001;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_over_out != 0) $display("ERROR!! OF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h8000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_over_out != 0) $display("ERROR!! OF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		
//		
//		$display("TEST ZF- zero"); //------------------------------------------------------------------------------------------------------------------------------------------------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'h0000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 1) $display("ERROR!! ZF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'h0001;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h0000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 1) $display("ERROR!! ZF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h0001;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 1) $display("ERROR!! ZF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0001;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h0000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 1) $display("ERROR!! ZF flag: %h not set correctly should be 1", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h0001;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_zero_out != 0) $display("ERROR!! ZF flag: %h not set correctly should be 0", tb_carry_out);
//		//-------------
//		
//		
//		$display("TEST NF- Negitive first bit 1"); //------------------------------------------------------------------------------------------------------------------------------------------------------
//		/**
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUB;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_neg_out != 1) $display("ERROR!! NF flag: %h not set correctly should be 1", tb_neg_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_SUBU;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_neg_out != 1) $display("ERROR!! NF flag: %h not set correctly should be 1", tb_neg_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADD;
//		tb_A = 16'hFFF0;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_neg_out != 1) $display("ERROR!! NF flag: %h not set correctly should be 1", tb_neg_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_ADDU;
//		tb_A = 16'hFFF0;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_neg_out != 1) $display("ERROR!! NF flag: %h not set correctly should be 1", tb_neg_out);
//		**/
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_CMP;
//		tb_A = 16'h0001;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_neg_out != 0) $display("ERROR!! NF flag: %h not set correctly should be 0", tb_neg_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_CMP;
//		tb_A = 16'h0000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_neg_out != 0) $display("ERROR!! NF flag: %h not set correctly should be 0", tb_neg_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_CMP;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_neg_out != 1) $display("ERROR!! NF flag: %h not set correctly should be 1", tb_neg_out);
//		
//		$display("TEST LF- low_out"); //------------------------------------------------------------------------------------------------------------------------------------------------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_CMP;
//		tb_A = 16'h0001;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_low_out != 0) $display("ERROR!! LF flag: %h not set correctly should be 0", tb_low_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_CMP;
//		tb_A = 16'h0000;
//		tb_B = 16'h0001;
//		#5;
//		if(tb_low_out != 1) $display("ERROR!! LF flag: %h not set correctly should be 1", tb_low_out);
//		//-------------
//		tb_carry_in = 0;
//		tb_control_word = CONTROL_CMP;
//		tb_A = 16'h0000;
//		tb_B = 16'h0000;
//		#5;
//		if(tb_low_out != 0) $display("ERROR!! LF flag: %h not set correctly should be 0", tb_low_out);
		//-------------
		
	end
endmodule