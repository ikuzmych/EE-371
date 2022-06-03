module vgaOutputs(clk, reset, moveLeft, moveRight, lose, x, y, x_paddle1_left, x_paddle1_right, xCirclePosition, yCirclePosition, r, g, b);
	input logic clk, reset, moveLeft, moveRight, lose;
	input logic [9:0] x;
	input logic [8:0] y;
	input logic [9:0] xCirclePosition;
	input logic [8:0] yCirclePosition;
	
	output logic [7:0] r, g, b;
	
	
	output logic unsigned [9:0] x_paddle1_left, x_paddle1_right;
	logic unsigned [8:0] y_paddle1_bottom, y_paddle1_top;	
	
	
	
	always_ff @(posedge clk) begin
		r <= 8'd0;
		g <= 8'd0;
		b <= 8'd0;		
		
		if (reset) begin
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
	
endmodule








