/* Bit-counting algorithm to count number of present "1"s in an 8-bit number
 * 
 * Inputs:
 *   clk    - 1-bit clock input
 *   Reset    - 1-bit reset input from KEY[0], 1-bit start input from KEY[3]
 *   A     - 8-bit input specifiying which to count bits from. Counts bits when s is high. Connected to SW[7:0] in top-level module
 *   s     - 1-bit input to direct when to start the bit counting operation. Connected to KEY[3] in the top-level module
 *
 * Output:
 * 	done      - 1-bit input to show that algorithm is done running. Connected to LEDR[9] in top-level module
 * 	result     - 4-bit input showing how many 1s there are. Goes to HEX0 in top-level module
 */

module bitCount(clk, reset, s, A, result, done);
	parameter N = 8;
	input logic clk, reset, s;
	input logic [N-1:0] A;
	output logic [3:0] result;
	output logic done;
	
	enum { S1, S2, S3} ps, ns;
	
	/* register to load in A */
	logic [N-1:0] Q;
	
	
	/* Controller for bit counting algorithm 
	 * Controls flow from state to state based on Q and s
	 */
	always_comb begin 
		case(ps) 
			S1: begin done = 0; 
				 if (s == 0) ns = S1;
				 else ns = S2;
				 end // S1
				 
			S2: begin done = 0;
				 if (Q == 0) ns = S3;
				 else ns = S2;
				 end // S2
				 
			S3: begin done = 1;
				 if (s == 0) ns = S1;
				 else ns = S3;
				 end // S3
		endcase // case
	end // always_comb
	
	
	/* Datapath block for our bit counting algorithm 
	 * If reset is high, go back to S1 and reset the result
	 * While in S1, reset the result
	 * While in S2, keep shifting and counting bits
	 */
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= S1;
			result <= 0;
		end // if
		else
			ps <= ns;
			
		if (ps == S1)
			result <= 4'd0;
		
		if ((ps == S1) && (s == 0)) Q <= A;
		
		if (ps == S2) begin
			Q <= Q >> 1;
			if (Q[0])
				result <= result + 1'd1;
		end // if
	end // always_ff
	
	
	

endmodule // bitCount


/* bitCount testbench */
module bitCount_testbench();
	
	parameter N = 8;
	logic clk, reset, s;
	logic [N-1:0] A;
	logic [3:0] result;
	logic done;

	bitCount dut(.*);
	
	// generated clock for sim
	initial begin
		clk = 1;
		forever #50 clk = ~clk;
	end // initial
	
	
	/* Simple testbench to test function of bitCount
	 * Counts the number of present 1s in an 8 bit number successfully
	 */
	initial begin
		reset <= 1; A <= 8'b11111111; @(posedge clk);
		reset <= 0; s <= 0; repeat(2) @(posedge clk); // turn off reset, load in A
		s <= 1; repeat(12) @(posedge clk); // allow the algorithm to run for a few cycles
		s <= 0; A <= 8'b10100001; repeat(2) @(posedge clk); // load in new value
		s <= 1; repeat(12) @(posedge clk);
		
	$stop;
	end // initial


endmodule

