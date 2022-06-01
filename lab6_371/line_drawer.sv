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
module line_drawer(clk, reset, start, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic signed [10:0]	x0, y0, x1, y1;
	input logic start;
	
	
	output logic done;
	output logic signed [10:0]	x, y;
	
	/* 
	 * Created some custom registers for the algorithm 
	 * incl. dx, dy, sx, sy, and e2.
	 */
	logic signed [11:0] error;
	logic signed [12:0] e2;
	logic signed [11:0] dx, dy;
	logic signed [2:0] sx, sy;
	
	
	/* assigned values of sx and sy */
	assign sx = x0 < x1 ? 1: -1;
	assign sy = y0 < y1 ? 1: -1;
	assign e2 = 2 * error;
	
	/**
	 * always_comb block to determine the signed values
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
	 * always_ff block to control dataflow of the algorithm
	 */
	always_ff @(posedge clk) begin 
		if (reset | ~start) begin
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
	logic done, start;
	logic signed [10:0] x, y;


	line_drawer dut(.*);

	/* simulated clock */
	initial begin 
		clk <= 0;
		forever #10 clk <= ~clk;
	end // initial

	/**
	 * Simple testbench for line_drawer algorithm to showcase its functionality
	 * in drawing angled and vertical lines
	 */
	initial begin
		/* right-down for gradual slope */
		reset <= 1; start <= 1; x0 <= 0; y0 <= 0; x1 <= 5; y1 <= 5; @(posedge clk);
		reset <= 0; repeat(8) @(posedge clk);
		/* right-up for gradual slope */
		reset <= 1; x0 <= 100; y0 <= 100; x1 <= 105; y1 <= 95; @(posedge clk);
		reset <= 0; repeat(8) @(posedge clk);
		
		
		/* left-up for gradual slope */
		reset <= 1; x0 <= 5; y0 <= 5; x1 <= 0; y1 <= 0; @(posedge clk);
		reset <= 0; repeat(8) @(posedge clk);
		/* left-down for gradual slope */
		reset <= 1; x0 <= 100; y0 <= 100; x1 <= 90; y1 <= 105; @(posedge clk);
		reset <= 0; repeat(20) @(posedge clk);
		
		/* right-down for steep slope */
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 5; y1 <= 20; @(posedge clk);
		reset <= 0; repeat(30) @(posedge clk);
		/* right-up for steep slope */
		reset <= 1; x0 <= 0; y0 <= 20; x1 <= 5; y1 <= 0; @(posedge clk);
		reset <= 0; repeat(30) @(posedge clk);
		
		
		/* left-up for steep slope */
		reset <= 1; x0 <= 100; y0 <= 100; x1 <= 95; y1 <= 80; @(posedge clk);
		reset <= 0; repeat(30) @(posedge clk);
		/* left-down for steep slope */
		reset <= 1; x0 <= 100; y0 <= 100; x1 <= 95; y1 <= 120; @(posedge clk);
		reset <= 0; repeat(30) @(posedge clk);
		
		
		
		/* vertical line drawing straight down */
		reset <= 1; x0 <= 100; y0 <= 100; x1 <= 100; y1 <= 105; @(posedge clk);
		reset <= 0; repeat(8) @(posedge clk);
		/* horizontal line drawing towards the right */
		reset <= 1; x0 <= 100; y0 <= 100; x1 <= 105; y1 <= 100; @(posedge clk);
		reset <= 0; repeat(8) @(posedge clk);



	$stop;
	end // initial
	
endmodule // line_drawer_testbench


