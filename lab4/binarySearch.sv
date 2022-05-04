/* Binary search algorithm implemenation in hardware
 * 
 * Inputs:
 *   clk    - 1-bit clock input
 *   Reset    - 1-bit reset input connected to KEY[0] in top-level module
 *   A     - 8-bit input to determine which number to find in the ROM. Connected to SW[7:0] in top-level module
 *   Start      - 1-bit input to initialize the start of the algorithm. Connected to KEY[3] in top-level module 
 *
 * Output:
 * 	Loc     - 5-bit address output that outputs the address of the found number. Connected to HEX0 and HEX1 in top-level module
 * 	Found   - 1-bit output that is high if the number is found. Connected to LEDR[0] in top-level module
 * 	Done    - 1-bit output that is high if the algorithm finishes running. Connected to LEDR[9] in top-level module
 */

module binarySearch(clk, Reset, A, Start, Loc, Found, Done); 

	input logic clk, Reset, Start;
	input logic [7:0] A;
	output logic [4:0] Loc;
	output logic Found, Done;
	
	/* logic to hold current value coming out of RAM and temporary values for L and R */
	logic [7:0] currRamOut;
	logic [4:0] L, R;
	
	enum { idle, search, done, searchBuffer } ps, ns; 
	
	/* Controller block to show travel from state to state based on certain conditions 
	 * w/ 4 total states: idle, search, searchBuffer to delay by one cycle, and done when the algorithm finishes running
	 */
	always_comb begin 
		case(ps) 
			idle: begin Done = 0; Found = 0;
					if (Start) ns = search;
					else ns = idle;
					end // idle
					
			search: begin Done = 0; Found = 0;
					  if ((currRamOut == A) || (L > R) || (R == 0) || (L == 31)) ns = done; // if value is found, or if L and R go past thresholds
					  else ns = searchBuffer;
					  end // search
			
			searchBuffer: begin Done = 0; Found = 0;
							  ns = search; 
							  end // searchBuffer
			
			done: begin Done = 1; Found = 0;
					if (Start)
						ns = done;
					else
						ns = idle;
					if (currRamOut == A) Found = 1;
					end // done
		endcase // case
	end // always_comb
	
	/* the current location to check in the ROM */
	assign Loc = (R + L) / 6'd2;

	/* datapath flip-flop for the binary search algorithm 
	 * If reset is high, reset the values of L and R and go back to idle
	 * While in the search state, continues checking the proper conditions
	 */
	always_ff @(posedge clk) begin
		// Loc <= (R + L) / 6'd2;
		if (Reset) begin
			ps <= idle;
			L <= 5'd0;
			R <= 5'd31;
		end // if 
		else 
			ps <= ns;
	
		if ((ps == idle) && ~Start) begin
			L <= 5'd0;
			R <= 5'd31;
		end // if
	
		if (ps == search) begin
			if (currRamOut < A)
				L <= Loc + 5'd1;
			else if (currRamOut > A)
				R <= Loc - 5'd1;
		end // if
	end // always_ff
	
	/* Initialize the ROM to read out of */
	ram32x8async intheinstatiation(.address(Loc), .clock(clk), .q(currRamOut));

endmodule // binarySearch


/* binarySearch testbench*/
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
	
	/* Simple testbench to check functionality of binarySearch module 
	 * First, we give it value that exists
	 * Second, we give it low value that does not exist
	 * Third, we give it high value that does not exist
	 */
	
	initial begin
		Reset <= 1; Start <= 0; A <= 8'd211; @(posedge clk);
		Reset <= 0; Start <= 1; repeat(16) @(posedge clk);
		
		Start <= 0; A <= 8'd0; repeat(2) @(posedge clk);
		Start <= 1; repeat(12) @(posedge clk);
		
		Start <= 0; A <= 8'd255; repeat(2) @(posedge clk);
		Start <= 1; repeat(12) @(posedge clk);
		
		Start <= 0; A <= 8'd98; repeat(2) @(posedge clk);
		Start <= 1; repeat(15) @(posedge clk);
		
	$stop;
	end // initial
	
	
endmodule // binarySearch_testbench
