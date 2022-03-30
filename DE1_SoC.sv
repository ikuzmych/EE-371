// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
		output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		output logic [9:0] LEDR;
		input logic [3:0] KEY;
		input logic [9:0] SW;
		input logic CLOCK_50;
		
		assign HEX0 = '1;
		assign HEX1 = '1;
		assign HEX2 = '1;
		assign HEX3 = '1;
		assign HEX4 = '1;
		assign HEX5 = '1;
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;

endmodule