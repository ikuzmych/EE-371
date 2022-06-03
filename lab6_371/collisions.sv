module collisions(clk, reset, paddleXLeft, paddleXRight, x, y, lose); 
	input logic clk, reset;
	output logic [10:0] x; 
	output logic [10:0] y;
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
	
	logic signed [10:0] xLineDrawer, yLineDrawer;
	logic check;
	
	assign x = xLineDrawer;
	assign y = yLineDrawer;
	
	

	
	assign circleX = x; assign circleY = y;
	assign clock = clk;
	assign paddlePositionChecker = (circleX - paddleXLeft) / 12;
	assign rdAddress = paddlePositionChecker;	
	
	
	
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
					if (done || collisionTrue || reset) begin ns = updateReg1; start = 0; end
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
			currentSlope <= -1;
			lose <= 0;
			x0 <= 20;
			y0 <= 20;
			check <= 0;
		end

		if ((((circleX == 629) || (circleX == 10) || (circleY == 20))) && check) begin
			currentSlope <= currentSlope * -1;
			x0 <= circleX;
			y0 <= circleY;
			check <= 0;
			collisionTrue <= 1;
		end
		
		if ((circleX > 10) && (circleX < 629) && (circleY < 458) && (circleY > 20)) begin
			check <= 1;
		end

		if ((circleY == 459) && check) begin
			check <= 0;
			lose <= 1;
			
			if (((paddlePositionChecker >= 0) && (paddlePositionChecker <= 6))) begin
				lose <= 0;
				collisionTrue <= 1;
				
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
	
	line_drawer drawCircle(.clk, .reset, .start, .slope(currentSlope), .x0, .y0, .x(xLineDrawer), .y(yLineDrawer), .done);


endmodule

`timescale 1 ps / 1 ps
module collisions_testbench();
	logic clk, reset;
	logic [10:0] x; 
	logic [10:0] y;
	logic [9:0] paddleXLeft, paddleXRight; // gets you the center of the circle
	logic lose;
	
	collisions dut(.*);
	

	initial begin
		clk <= 0;
		forever #10 clk <= ~clk;
	end
	
	initial begin
		reset <= 1; paddleXLeft <= 176; paddleXRight <= 250; @(posedge clk);
		reset <= 0; repeat(4000) @(posedge clk);
	$stop;
	end
	

endmodule



