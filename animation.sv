module animation(clk, reset, start, clearScreen, clearState, pixel_color, done, x0, y0, x1, y1);
	input logic clk, reset, done;
	input logic clearScreen;
	output logic start;
	output logic clearState, pixel_color;
	output logic signed [10:0] x0, y0, x1, y1;
		
	
	assign clearState = (ps == clear);
	logic [31:0] counter;
	
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
	always_ff @(posedge clk) begin
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
	always_ff @(posedge clk) begin
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
		
endmodule // animation
