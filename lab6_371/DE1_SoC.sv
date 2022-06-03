/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *   start  - signal that tells the algorithm to perform the process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
 
 
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS, V_GPIO);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	inout logic [26:28] V_GPIO;
	
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
    wire up;
    wire down;
    wire left;
    wire right;
    wire a;
    wire b2;
	 wire select;
	 wire start;
	 
    wire latch;
    wire pulse;
    
	 assign V_GPIO[27] = pulse;
    assign V_GPIO[26] = latch;


	 n8_driver driver(
	  .clk(CLOCK_50),
	  .data_in(V_GPIO[28]),
	  .latch(latch),
	  .pulse(pulse),
	  .up(up),
	  .down(down),
	  .left(left),
	  .right(right),
	  .select,
	  .start,
	  .a(a),
	  .b(b2)
    ); 
			 
	logic unsigned [9:0] x_paddle1_left, x_paddle1_right;
	logic unsigned [8:0] y_paddle1_bottom, y_paddle1_top;
	logic rst;
	
	
	
	logic moveLeft, moveRight;
	logic lose;
	
	logic [9:0] xCirclePosition;
	logic [8:0] yCirclePosition;
	logic [7:0] score;
	
	assign rst = start; // assign the reset to switch 0 on the DE1_SoC board
	
	seg7 hex1Value(.hex(score[7:4]), .leds(HEX1));
	seg7 hex0Value(.hex(score[3:0]), .leds(HEX0));
	
	
	/* instantiations of all external modules */
	vgaOutputs colorCoding(.clk(CLOCK_50), .reset(rst), .moveLeft, .moveRight, .x, .y, .xCirclePosition, .x_paddle1_left, .x_paddle1_right, .yCirclePosition, .lose, .r, .g, .b);
	collisions ballsLogicShrek(.clk(CLOCK_50), .reset(rst), .paddleXLeft(x_paddle1_left), .score, .paddleXRight(x_paddle1_right), .x(xCirclePosition), .y(yCirclePosition), .lose); 
	
	/* module for ensuring that the fast clock will not glitch out and allow a single press to move the paddle more than we expect. One increment per button press */
	Click onepress1(.clock(CLOCK_50), .reset(rst), .in(left), .out(moveLeft));
	Click onepress2(.clock(CLOCK_50), .reset(rst), .in(right), .out(moveRight));	
	
	
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign reset = 0;
	
endmodule
