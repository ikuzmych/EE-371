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
	// assign LEDR[8:0] = SW[8:0];
	
	logic signed [10:0] x0, y0, x1, y1, x, y;

	logic reset;
	logic [31:0] div_clk;
	
	logic systemclock;
	// assign systemclock = div_clk[12];
	assign systemclock = CLOCK_50;
	
//	clock_divider dividedClocks(.clock(CLOCK_50), .reset(1'b0), .divided_clocks(div_clk));
	
	
	
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
	logic clearScreen;
	logic [32:0] counter;
	
	/* Logic to completely clear out the VGA screen */
	assign clearScreen = SW[0];
	
	assign LEDR[9] = done;
	assign LEDR[0] = (x0 == 0);
	assign LEDR[1] = (x1 == 0);
	assign reset = ~KEY[0];
	
	assign LEDR[5] = (ps == clear);
	
	enum { clear, draw, pause, erase, updateReg1, updateReg2 } ps, ns;
	

	/**
	 *
	 *
	 *
	 */
	always_comb begin 
		case(ps)
			
			clear: begin start = 1;
					 
					 if ((x0 == 639) & done) ns = draw; 
					 
					 else if (done) ns = updateReg1;
					 
					 else ns = clear;
					 
					 end
			draw: begin start = 1;
					if (clearScreen) ns = updateReg1;
					
					else if (done) ns = pause;
	
					else ns = draw;
					end
			
			
			pause: begin start = 0;
						if (clearScreen) ns = updateReg1;
						
						else if (counter >= 10000000) ns = erase;
						
						else ns = pause;
			       end
			
			
			erase: begin start = 1;
					 if (clearScreen) ns = updateReg1;
					 
					 else if (done) begin ns = updateReg1; start = 0;
					 end
					 
					 else ns = erase;
					 end
			
			updateReg1: begin start = 0; ns = updateReg2;
												  end
			updateReg2: begin start = 0;
								 
								 if (clearScreen) ns = clear;
								 else ns = draw;
								 end
		endcase
	end
	
	/**
	 *
	 *
	 *
	 */
	always_ff @(posedge systemclock) begin
		if (reset)
			ps <= draw;
		else
			ps <= ns;	
	end
	
	/** 
	 *
	 *
	 *
	 */
	always_comb begin
		if (ps == draw)
			pixel_color = 1;
		else
			pixel_color = 0;
	end
	
	/** 
	 *
	 *
	 *
	 */	
	always_ff @(posedge systemclock) begin
		if (reset & ~clearScreen) begin
			x0 <= 55;
			x1 <= 440;
			y0 <= 175;
			y1 <= 15;
			counter <= 0;
		end
		
		if ((ns == clear) & (ps != clear) & (ps != updateReg1) & (ps != updateReg2)) begin
			x0 <= 0;
			y0 <= 0;
			x1 <= 0;
			y1 <= 459;
		end
		
		if ((ps == clear) & (ns == updateReg1)) begin
			x0 <= x0 + 1;
			x1 <= x1 + 1;
		end
		if ((ps == clear) & (ns != clear)) begin
			x0 <= 55;
			x1 <= 440;
			y0 <= 175;
			y1 <= 15;
		end
		if ((ns == pause) & (ps == draw)) counter <= 0;
		
		if (ps == pause) counter <= counter + 1;
		
		
		
		if ((ps == erase) & (ns == updateReg1) & ~clearScreen) begin
//			x0 <= x0 + 1;
//			x1 <= x1 + 1;
//			y0 <= y0 + 1;
//			y1 <= y1 + 1;
//		
//			if (((x1 > 639) | (y1 > 479))  & (~clearScreen)) begin
//				x0 <= 100;
//				y0 <= 100;
//				x1 <= 200;
//				y1 <= 250;
//			end
			if (x0 == 55 & x1 == 440) begin
				x0 <= 440;
				x1 <= 500;
				y0 <= 15;
				y1 <= 300;
			end
			else if (x0 == 440 & x1 == 500) begin
				x0 <= 500;
				x1 <= 500;
				y0 <= 300;
				y1 <= 450;
			end
			else if (x0 == 500 & x1 == 500) begin
				x0 <= 500;
				x1 <= 15;
				y0 <= 450;
				y1 <= 450;
			end
			else if (x0 == 500 & x1 == 15) begin
				x0 <= 15;
				x1 <= 55;
				y0 <= 450;
				y1 <= 175;
			end
			else if (x0 == 15 & x1 == 55) begin
				x0 <= 55;
				x1 <= 440;
				y0 <= 175;
				y1 <= 15;
			end			
			
		end
	end
	
	
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
