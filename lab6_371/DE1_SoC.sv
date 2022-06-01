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
			 
	
	logic [23:0] counter;
	logic unsigned [9:0] circle_width, x_paddle1_left, x_paddle1_right;
	logic unsigned [8:0] circle_height, y_paddle1_bottom, y_paddle1_top;
	logic rst;
	
	logic signed [10:0] x0, x1;
	logic signed [10:0] y0, y1;
	logic done, start;
	
	assign rst = SW[0];
	assign moveUp = ~KEY[0];
	assign moveDown = ~KEY[1];
	
	logic moveLeft, moveRight;
	
	Click onepress1(.clock(CLOCK_50), .reset(rst), .in(~KEY[3]), .out(moveLeft));
	Click onepress2(.clock(CLOCK_50), .reset(rst), .in(~KEY[2]), .out(moveRight));
	

	always_comb begin
		
		
	
	end
	
	always_ff @(posedge CLOCK_50) begin
		start <= 1;
		if (rst) begin
			x0 <= 0;
			x1 <= 320;
			y0 <= 0;
			y1 <= 450;
			start <= 0;
		end
		else if (done) begin
			x0 <= x1;
			x1 <= 639;
			y0 <= y1;
			y1 <= 0;
			start <= 0;
		end
	end
	
	
	line_drawer circleTesting(.clk(CLOCK_50), .reset(rst), .start(), .x0, .y0, .x1, .y1, .x(circle_width), .y(circle_height), .done);
	
	
	always_ff @(posedge CLOCK_50) begin
		counter <= counter + 24'd1;	
		r <= 8'd0;
		g <= 8'd0;
		b <= 8'd0;
		
		if (rst) begin
			counter <= 24'd0;
			y_paddle1_bottom <= 9'd479;
			y_paddle1_top <= 9'd460;
			x_paddle1_right <= 10'd280;
			x_paddle1_left <= 10'd190;
		end
		
		if (counter == 24'd1000000) begin
			counter <= 24'd0;
		end
		
		if (moveLeft && (x_paddle1_left > 0)) begin 
			x_paddle1_left <= x_paddle1_left - 10;
			x_paddle1_right <= x_paddle1_right - 10;
		end else if (moveRight && (x_paddle1_right < 639)) begin 
			x_paddle1_left <= x_paddle1_left + 10;
			x_paddle1_right <= x_paddle1_right + 10;
		end
		
		if ((x >= x_paddle1_left) && (x <= x_paddle1_right) && (y >= y_paddle1_top) && (y <= y_paddle1_bottom)) begin
			r <= 8'd255;
			g <= 8'd255;
			b <= 8'd255;
		end

		if ((((x - circle_width)**2) + ((y - circle_height)**2)) <= (10**2)) begin
			r <= 8'd255;
			g <= 8'd255;
			b <= 8'd255;
		end
		
	end
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign reset = 0;
	
endmodule
