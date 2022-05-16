/* Module to control the simulated animation that we designed. Responsible for directing and redirecting values we want drawn/erased
 * 
 * Inputs:
 *   clk    - 1-bit clock input, connected to CLOCK_50 in top-level module
 *   reset    - 1-bit reset input connected to KEY[0] in top-level module
 *   clearScreen     - 1-bit reset input specifying to clear the screen. Main reset, connected to SW[0] in top-level module
 *   done     - 1-bit input hooked up to the output of line_drawer in top-level, for our state machine
 *
 * Output:
 * 	start      - 1-bit input to show that algorithm is done running. Connected to LEDR[9] in top-level module
 * 	clearState     - 1-bit output that hooked up to an LED in the top-level module that turns on when reset is toggled
 *    pixel_color - 1-bit input hooked up to the VGA_framebuffer module to choose the color to display
 *    x0, y0, x1, y1      - 10-bit signed outputs that go to line_drawer, which performs the necessary algorithm and outputs to the VGA_framebuffer
 */
module animation(clk, reset, start, clearScreen, clearState, pixel_color, done, x0, y0, x1, y1);
	input logic clk, reset, done;
	input logic clearScreen;
	output logic start;
	output logic clearState, pixel_color;
	output logic signed [10:0] x0, y0, x1, y1;
		
	/* to toggle the LED in top-level whenever we are in the "clear" state */
	assign clearState = (ps == clear);
	
	/* counter to toggle how long we want each line to display before erasing and 
	 * drawing the next line in the animation
	 */
	logic [31:0] counter;
	
	/* Enumerations for the controller block */
	enum { clear, draw, pause, erase, updateReg1, updateReg2 } ps, ns;
	
	/**
	 * Controller for the animation, directing the states in proper order
	 * The clear state is responsible for directing how long to stay in it and draw the blank line across the VGA
	 * The draw state draws the specified line in the color white
	 * The pause state allows the drawn line to stay on a while longer before going to the erase state
	 * The erase state draws the same line as was in the draw state, except it draws it as a black line by changing the pixelcolor
	 * The two buffer states are simply for updating the registers, and giving the machine enough clock cycles to update values in line_buffer
	 */
	always_comb begin 
		case(ps)
			
			clear: begin start = 1;
					 
					 if ((x0 == 639) & done) ns = draw; 
					 
					 else if (done) ns = updateReg1;
					 
					 else ns = clear;
					 
					 end // clear
			draw: begin start = 1;
					if (clearScreen) ns = updateReg1;
					
					else if (done) ns = pause;
	
					else ns = draw;
					end // draw
			
			
			pause: begin start = 0;
						if (clearScreen) ns = updateReg1;
						
						else if (counter >= 10000000) ns = erase;
						
						else ns = pause;
			       end // pause
			
			
			erase: begin start = 1;
					 if (clearScreen) ns = updateReg1;
					 
					 else if (done) begin ns = updateReg1; start = 0;
					 end // else if
					 
					 else ns = erase;
					 end // erase
			
			updateReg1: begin start = 0; ns = updateReg2;
												  end // updateReg1
			updateReg2: begin start = 0;
								 
								 if (clearScreen) ns = clear;
								 else ns = draw;
								 end // updateReg2
		endcase // case(ps)
	end // always_comb
	
	/**
	 * always_ff block for the controller
	 */
	always_ff @(posedge clk) begin
		if (reset)
			ps <= draw;  // used for testing to pause the system, real reset hooked up to the clearScreen input
		else
			ps <= ns;
	end
	
	/** 
	 * Simple combinational block to direct pixel_color based
	 * on the state machine
	 */
	always_comb begin
		if (ps == draw)
			pixel_color = 1;
		else
			pixel_color = 0;
	end
	
	/** 
	 * Datapath to control flow of the animation and what each state is responsible for
	 * At reset, go back to initial line
	 * Clear datapath is responsible for clearing the entire screen by
	 * drawing a black line and going across the entire screen
	 */
	always_ff @(posedge clk) begin
		if (reset & ~clearScreen) begin
			x0 <= 55;
			x1 <= 440;
			y0 <= 175;
			y1 <= 15;
			counter <= 0;
		end // if
		
		if ((ns == clear) & (ps != clear) & (ps != updateReg1) & (ps != updateReg2)) begin
			x0 <= 0;
			y0 <= 0;
			x1 <= 0;
			y1 <= 459;
		end // if
		
		/* while in clear, update the register values every cycle */
		if ((ps == clear) & (ns == updateReg1)) begin
			x0 <= x0 + 1;
			x1 <= x1 + 1;
		end // if
		
		/* When leaving the clear state, go back to original animation start*/
		if ((ps == clear) & (ns != clear)) begin
			x0 <= 55;
			x1 <= 440;
			y0 <= 175;
			y1 <= 15;
		end // if
		
		/* two if statements to control the counter 
		 * that tells a line how long to remain drawn
		 */
		if ((ns == pause) & (ps == draw)) counter <= 0;
		if (ps == pause) counter <= counter + 1;
		
		
		/** 
		 * Animation dataflow, updating the values once a line has been drawn
		 * to the next line in the sequence
		 */
		if ((ps == erase) & (ns == updateReg1) & ~clearScreen) begin
			if (x0 == 55 & x1 == 440) begin
				x0 <= 440;
				x1 <= 500;
				y0 <= 15;
				y1 <= 300;
			end // if
			else if (x0 == 440 & x1 == 500) begin
				x0 <= 500;
				x1 <= 500;
				y0 <= 300;
				y1 <= 450;
			end // else if
			else if (x0 == 500 & x1 == 500) begin
				x0 <= 500;
				x1 <= 15;
				y0 <= 450;
				y1 <= 450;
			end // else if
			else if (x0 == 500 & x1 == 15) begin
				x0 <= 15;
				x1 <= 55;
				y0 <= 450;
				y1 <= 175;
			end // else if
			else if (x0 == 15 & x1 == 55) begin
				x0 <= 55;
				x1 <= 440;
				y0 <= 175;
				y1 <= 15;
			end // else if
		end // if
	end // always_ff

endmodule // animation
