module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
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

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
			 
	logic unsigned [9:0] x_paddle1_left, x_paddle1_right;
	logic unsigned [8:0] y_paddle1_bottom, y_paddle1_top;
	logic rst;
	
	assign rst = SW[0];
	
	logic moveLeft, moveRight;
	
	/** x0 = 619 -> x1 = 639  
	 *  y0 = 0   -> y1 = 20
	 
	 // if edge pixels of circle reach x1 = 639  ** current coordinate (639, 20)
	 // x0 = x1 and 0 = y1
	 // x1 = 639 - (479 - 20)
	 */
	Click onepress1(.clock(CLOCK_50), .reset(rst), .in(~KEY[3]), .out(moveLeft));
	Click onepress2(.clock(CLOCK_50), .reset(rst), .in(~KEY[2]), .out(moveRight));
	
	logic lose;
	logic [9:0] xCirclePosition;
	logic [8:0] yCirclePosition;
	
	always_ff @(posedge CLOCK_50) begin
		r <= 8'd0;
		g <= 8'd0;
		b <= 8'd0;
		
		if (rst) begin
			y_paddle1_bottom <= 9'd479;
			y_paddle1_top <= 9'd470;
			x_paddle1_right <= 10'd274; // 90 pixels wide
			x_paddle1_left <= 10'd190;
		end
		

		if (moveLeft && (x_paddle1_left > 0)) begin 
			x_paddle1_left <= x_paddle1_left - 10;
			x_paddle1_right <= x_paddle1_right - 10;
		end else if (moveRight && (x_paddle1_right < 639)) begin 
			x_paddle1_left <= x_paddle1_left + 10;
			x_paddle1_right <= x_paddle1_right + 10;
		end
		
		if ((x >= x_paddle1_left) && (x <= x_paddle1_right) && (y >= y_paddle1_top) && (y <= y_paddle1_bottom)) begin // the good guy
			r <= 8'd255;
			g <= 8'd255;
			b <= 8'd255;
		end

		if ((((x - xCirclePosition)**2) + ((y - yCirclePosition)**2)) <= (10**2)) begin
			r <= 8'd255;
			g <= 8'd255;
			b <= 8'd255;
		end
		
		if (xCirclePosition <= 42) begin
			if ((y >= 9'd0) && (y <= 9'd10) && (x >= 0) && (x <= 84)) begin
				r <= 8'd255;
				g <= 8'd0;
				b <= 8'd0;				
			end
		end
		
		else if ((y >= 9'd0) && (y <= 9'd10) && (x >= (xCirclePosition - 10'd42)) && (x <= xCirclePosition + 10'd42)) begin // the villain argghhh
			r <= 8'd255;
			g <= 8'd0;
			b <= 8'd0;
		end
		
		if (lose) begin
			r <= 8'd0;
			g <= 8'd0;
			b <= 8'd0;
		end
	end
	
	 
	
	
	
	collisions ballsLogicShrek(.clk(CLOCK_50), .reset(rst), .paddleXLeft(x_paddle1_left), .paddleXRight(x_paddle1_right), .x(xCirclePosition), .y(yCirclePosition), .lose); 
	
	
	
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign reset = 0;
	
endmodule
