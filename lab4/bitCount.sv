/* Bit-counting algorithm to count number of present "1"s in an 8-bit number
 * 
 * Inputs:
 *   clk    - 1-bit clock input
 *   Reset    - 1-bit reset input from KEY[0], 1-bit start input from KEY[3]
 *   A     - used as an 8-bit signal to determine input value "A" in both tasks, and SW[9] used to toggle between which task is active
 *
 * Output:
 * 	Start      - 1-bit input to initialize the start of the algorithm. Connected to KEY[3] in top-level module   
 * 	Loc     - 5-bit address output that outputs the address of the found number. Connected to HEX0 and HEX1 in top-level module
 * 	Found   - 1-bit output that is high if the number is found. Connected to LEDR[0] in top-level module
 * 	Done    - 1-bit output that is high if the algorithm finishes running. Connected to LEDR[9] in top-level module
 */

module bitCount(clk, reset, s, A, result, done);
	parameter N = 8;
	input logic clk, reset, s;
	input logic [N-1:0] A;
	output logic [3:0] result;
	output logic done;
	
	enum { S1, S2, S3} ps, ns;
	
	/* only 8 bits because highest count ever will be 1 */
	// logic [2:0] currCount;
	logic [N-1:0] Q;
	// register to hold loaded-in value (if s is true)
	
	
	
	
	always_comb begin 
		case(ps) 
			S1: begin done = 0; 
				 if (s == 0) ns = S1;
				 else ns = S2;
				 end
				 
			S2: begin done = 0;
				 if (Q == 0) ns = S3;
				 else ns = S2;
				 end
				 
			S3: begin done = 1;
				 if (s == 0) ns = S1;
				 else ns = S3;
				 end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin 
			ps <= S1;
			result <= 0;
		end
		else
			ps <= ns;
			
		if (ps == S1)
			result <= 4'd0;
		
		if ((ps == S1) && (s == 0)) Q <= A;
		
		if (ps == S2) begin
			Q <= Q >> 1;
			if (Q[0])
				result <= result + 1'd1;
		end
	end
	
	
	
	/*always_ff @(posedge clk) begin
		if (reset)
			currCount <= 0;
		else if (s == 0)
			A <= load;
		else if (s)
			if (A == 0) begin
				done <= 1;
			end
			
			if ((A[0] == 1)) begin 
				currCount <= currCount + 1;
				A <= A >> 1;
			end else if (A == 0) begin
				
			end
			
	end */


endmodule



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
	
	assign A = 8'b11111111;
	
	initial begin 
		reset <= 1; @(posedge clk);
		reset <= 0; s <= 0; repeat(2) @(posedge clk);
		s <= 1; repeat(12) @(posedge clk);
		s <= 0; repeat(2) @(posedge clk);
		s <= 1;         @(posedge clk);
		
	$stop;
	end


endmodule

