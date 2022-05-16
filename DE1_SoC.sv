/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [0:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	logic pixel_color;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	// assign LEDR[8:0] = SW[8:0];
	
	logic signed [10:0] x0, y0, x1, y1, x, y;

	logic reset;
	
	logic systemclock;
	assign systemclock = CLOCK_50;
	
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x,
		.y,
		.pixel_color, 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N),
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	logic done;
	logic start;
	logic clearScreen, clearState;
	
	/* Logic to completely clear out the VGA screen */
	assign clearScreen = SW[0];
	assign LEDR[0] = clearState;
	
	assign reset = ~KEY[0];
	
	
	
	animation customAnimation(.clk(systemclock), .reset, .start, .pixel_color, .clearScreen, .clearState, .done, .x0, .y0, .x1, .y1);
	
	line_drawer lines (.clk(systemclock), .reset(reset | done), .start, .x0, .y0, .x1, .y1, .x, .y, .done);
	
	
	/** 
	 * Animation pseudo-code: 
	 * Draw a line first, then when want to move, color it black, and draw the same line shifted in a specified
	 * direction
	 */
	
	
endmodule  // DE1_SoC


module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	DE1_SoC dut(.*);
	
	initial begin 
		CLOCK_50 <= 0;
		forever #5 CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin 
		KEY[0] <= 0; KEY[1] <= 0; repeat (2) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(50) @(posedge CLOCK_50);
		
	$stop;
	end

endmodule
