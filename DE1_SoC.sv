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
	output logic [9:0] LEDR;
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
	assign LEDR[8:0] = SW[8:0];
	
	logic signed [11:0] x0, y0, x1, y1, x, y;
	logic white, black;
	assign white = 1;
	assign black = 0;
	logic moveRight, moveLeft, moveDown, moveUp;
	
	assign moveRight = ~KEY[0];
	assign moveLeft = ~KEY[1];
	assign moveDown = ~KEY[2];
	assign moveUp = ~KEY[3];
	logic in;
	logic reset;
	logic [31:0] div_clk;
	
	
	clock_divider dividedClocks(.clock(CLOCK_50), .reset(1'b0), .divided_clocks(div_clk));
	
	
	
	assign in = moveRight | moveLeft | moveDown | moveUp;
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
				
	logic done, doneMoving;
	assign LEDR[9] = done;

	assign reset = ~KEY[0];
	
//	enum { drawOriginalLine, colorblack, drawNewLine, Done } ps, ns;
//	always_comb begin 
//		case(ps) 
//			
//			drawOriginalLine: if (in) ns = colorblack;
//									else ns = drawOriginalLine;
//									
//			colorblack: if (in) ns = drawNewLine;
//							else ns = colorblack;
//							
//			drawNewLine: if (doneMoving) ns = Done;
//							 else ns = drawNewLine;
//							 
//			Done: if (reset) ns = drawOriginalLine;
//					else ns = Done;
//			
//		endcase
//	
//	end

	enum { draw, erase } ps, ns;
	
	
	always_comb begin 
		case(ps)
			draw: if (done) ns = erase;
					else ns = draw;
	
			erase: if (done) ns = draw;
					 else ns = erase;
		endcase
	end
	
	always_ff @(posedge div_clk[10]) begin
		if (reset)
			ps <= draw;
		else 
			ps <= ns;	
	
	end
	
	always_comb begin
		if (ps == draw)
			pixel_color = white;
		else 
			pixel_color = black;
	end
	
	
	always_ff @(posedge div_clk[24]) begin
		if (reset) begin
			x0 <= 100;
			y0 <= 100;
			x1 <= 300;
			y1 <= 300;
		end else if ((ps == erase) && (ns == draw))
			x0 <= x0 + 1;
			x1 <= x1 + 1;
	end
	
	
	line_drawer lines (.clk(div_clk[10]), .reset(reset | done), .x0, .y0, .x1, .y1, .x, .y, .done);
	
	
	/** 
	 * Animation pseudo-code: 
	 * Draw a line first, then when want to move, color it black, and draw the same line shifted in a specified
	 * direction
	 */

	
	

	// assign pixel_color = colorselect;
	
endmodule  // DE1_SoC

/*
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
	logic clk;
	
	DE1_SoC dut(.*);
	
	initial begin 
		CLOCK_50 <= 0;
		forever #5 CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin 
		SW[0] <= 1; KEY[0] <= 1; KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1; @(posedge CLOCK_50);
		SW[0] <= 0; repeat (50) @(posedge CLOCK_50); // draw the original line
		KEY[3] <= 0; repeat(3) @(posedge CLOCK_50); // draw new line moved up one
		KEY[3] <= 1; repeat(20) @(posedge CLOCK_50);
	$stop;
	end

endmodule


*/

