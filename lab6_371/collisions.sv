module collisions(clk, reset, paddleXLeft, paddleXRight, x, y, lose); 
	input logic clk, reset;
	output logic signed [10:0] x, y;
	input logic [9:0] paddleXLeft, paddleXRight; // gets you the center of the circle
	

	output logic lose;
	
	logic signed [10:0] x0, y0; // new variables to pass into line_drawer
	logic clock;
	logic [9:0] ROMSlope;
	logic [4:0] rdAddress;
	logic start, done;
	logic signed [3:0] currentSlope;
	logic [9:0] circleX;
	logic [8:0] circleY;
	
	logic collisionTrue;
	logic [9:0] paddlePositionChecker;
	
	assign circleX = x; assign circleY = y;
	assign clock = clk;
	assign paddlePositionChecker = (circleX - paddleXLeft) / 7;
	
	
	
	
	/* Enumerations for the controller block */
	enum { draw, updateReg1, updateReg2 } ps, ns;

	/**
	 * Controller for the animation, directing the states in proper order
	 * The clear state is responsible for directing how long to stay in it and draw the blank line across the VGA
	 * The draw state draws the specified line in the color white
	 * The two buffer states are simply for updating the registers, and giving the machine enough clock cycles to update values in line_buffer
	 */
	always_comb begin 
		case(ps)
			
			draw: begin start = 1;
					if (done || collisionTrue) begin ns = updateReg1; start = 0; end
					else ns = draw;
					end // draw
	
			updateReg1: begin start = 0; ns = updateReg2;
							end // updateReg1
			updateReg2: begin start = 0;
							ns = draw;
						   end // updateReg2
		endcase // case(ps)
	end // always_comb
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= updateReg1;
		else
			ps <= ns;
	end


	always_ff @(posedge clk) begin
		collisionTrue <= 0;

		if (reset) begin
			currentSlope <= 1;
			lose <= 0;
			x0 <= 100;
			y0 <= 100;
		end

		if ((circleX == 629) || (circleX == 0) || (circleY == 10)) begin
			currentSlope <= currentSlope * -1;
			x0 <= circleX;
			y0 <= circleY;
			collisionTrue <= 1;
		end

		if (circleY == 469) begin
			if ((paddlePositionChecker < 0) || (paddlePositionChecker > 6)) begin
				lose <= 1;
			end else begin
				collisionTrue <= 1;
				rdAddress <= paddlePositionChecker;
				x0 <= circleX;
				y0 <= circleY;

				if (paddlePositionChecker < 3) begin
					currentSlope <= ROMSlope * -1;
				end else if (paddlePositionChecker == 3) begin
					currentSlope <= currentSlope * -(ROMSlope);
				end else begin
					currentSlope <= ROMSlope;
				end

			end
		end
	end
	
	paddlePositionsROM ranges(.address(rdAddress), .clock, .q(ROMSlope));
	
	line_drawer drawCircle(.clk, .reset, .start, .slope(currentSlope), .x0, .y0, .x, .y, .done);
	
	
endmodule
