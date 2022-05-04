module binarySearch(clk, Reset, A, Start, Loc, Found, Done); 

	input logic clk, Reset, Start;
	input logic [7:0] A;
	output logic [4:0] Loc;
	output logic Found, Done;

	logic [7:0] currRamOut;
	logic [4:0] L, R;
	
	enum { idle, search, done, searchBuffer } ps, ns; 
	always_comb begin 
		case(ps) 
			idle: begin Done = 0; Found = 0;
					if (Start) ns = search;
					else ns = idle;
					end
					
			search: begin Done = 0; Found = 0;
					  if ((currRamOut == A) || (L > R) || (R == 0) || (L == 31)) ns = done;
					  else ns = searchBuffer;
					  end
			
			searchBuffer: begin Done = 0; Found = 0;
							  ns = search; 
							  end
			
			done: begin Done = 1; Found = 0;
					if (Start)
						ns = done;
					else
						ns = idle;
					if (currRamOut == A) Found = 1;
					end
		endcase
	end
	
	
	assign Loc = (R + L) / 6'd2;

	
	always_ff @(posedge clk) begin
		// Loc <= (R + L) / 6'd2;
		if (Reset) begin
			ps <= idle;
			L <= 5'd0;
			R <= 5'd31;
		end else 
			ps <= ns;
	
		if ((ps == idle) && ~Start) begin
			L <= 5'd0;
			R <= 5'd31;
		end
	
		if (ps == search) begin
			if (currRamOut < A)
				L <= Loc + 5'd1;
			else if (currRamOut > A)
				R <= Loc - 5'd1;
		end
	end
	
	
	// ram32x8port1 myArrayMif(.address(Loc), .clock(clk), .data(8'd0), .wren(0), .q(currRamOut));
	ram32x8async intheinstatiation(.address(Loc), .clock(clk), .q(currRamOut));

endmodule 


`timescale 1 ps / 1 ps
module binarySearch_testbench();

	logic clk, Reset, Start;
	logic [7:0] A;
	logic [4:0] Loc;
	logic Found, Done;

	binarySearch dut(.*);
	
	// generated clock for sim
	initial begin
		clk = 1;
		forever #10 clk = ~clk;
	end // initial	
	

	initial begin
		Reset <= 1; Start <= 0; A <= 8'd211; @(posedge clk);
		Reset <= 0; Start <= 1; repeat(16) @(posedge clk);
		
		Start <= 0; A <= 8'd0; repeat(2) @(posedge clk);
		Start <= 1; repeat(18) @(posedge clk);
		
		Start <= 0; A <= 8'd255; repeat(2) @(posedge clk);
		Start <= 1; repeat(15) @(posedge clk);
		
		
	$stop;
	end
	
	
endmodule
