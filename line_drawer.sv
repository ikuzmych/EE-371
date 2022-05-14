/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
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
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic signed [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic signed [10:0]	x, y;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	logic signed [11:0] error;  // example - feel free to change/delete
	logic signed [12:0] e2;
	logic signed [10:0] dx, dy;
	logic signed [2:0] sx, sy;
	
	/** 
	 * Always comb block to assign values of dx and dy
	 * based on their signs
	 *
	 */
	
	assign sx = x0 < x1 ? 1: -1;
	assign sy = y0 < y1 ? 1: -1;
	assign e2 = 2 * error;
	
	/**
	 *
	 *
	 */
	always_comb begin
		if (x0 > x1)
			dx = x0 - x1;
	
		else
			dx = x1 - x0;
			
		if (y0 > y1)
			dy = -(y0 - y1);
			
		else
			dy = -(y1 - y0);
			
	end // always_comb
	
	/**
	 *
	 *
	 */	
	always_ff @(posedge clk) begin 
		if (reset) begin
			done <= 0;
			x <= x0;
			y <= y0;
			error <= dx + dy;
			
		end // if
		else begin
			
			if ((x == x1) && (y == y1))
				done <= 1;
			else begin
				
				if (e2 >= dy) begin
					if (x != x1) begin
						x <= x + sx;
						error <= error + dy;
					end // if
				end // if
				
				if (e2 <= dx) begin
					if (y != y1) begin
						y <= y + sy;
						error <= error + dx;
					end // if
				end // if
				
				if ((e2 <= dx) && (e2 >= dy))
					error <= error + dx + dy;
			end // else
		end // else
	end // always_ff
endmodule  // line_drawer

/* line_drawer testbench */
module line_drawer_testbench();
	logic clk, reset;
	logic signed [10:0]	x0, y0, x1, y1;
	logic done;
	logic signed [10:0] x, y;

	line_drawer dut(.*);
	
	initial begin 
		clk <= 0;
		forever #10 clk <= ~clk;
	end // initial

	
	initial begin
		reset <= 1; x0 <= 0; y0 <= 100; x1 <= 200; y1 <= 0; @(posedge clk);
		reset <= 0; repeat(300) @(posedge clk);
		// reset <= 1; @(posedge clk);
		// reset <= 0; repeat(15) @(posedge clk);
		// reset <= 1; repeat(2); @(posedge clk);
	
	$stop;
	end // initial
	
endmodule // line_drawer_testbench




