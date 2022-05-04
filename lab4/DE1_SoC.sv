/* Top level module for DE1_SoC board
 * 
 * Inputs:
 *   CLOCK_50    - 1-bit clock input
 *   KEY    - 1-bit reset input from KEY[0], 1-bit start input from KEY[3]
 *   SW     - used as an 8-bit signal to determine input value "A" in both tasks, and SW[9] used to toggle between which task is active
 *
 * Output:
 * 	HEX      - 7-bit display outputs. In task1, shows the count of 1s in a binary number. In task2, shows the address of found digit   
 * 	LEDR     - 1-bit displays. LEDR[9] for done in both tasks, and LEDR[0] for Found in task2
 */
 
module DE1_SoC(CLOCK_50, SW, LEDR, KEY, HEX0, HEX1);

	input logic [9:0] SW;
	input logic [3:0] KEY;
	input logic CLOCK_50;
	
	output logic [9:0] LEDR;
	output logic [6:0] HEX0, HEX1;
	
	/* logic to assign to board */
	logic reset, clk, s;
	logic [7:0] A;
	
	/* logic for task1 inputs and outputs*/
	logic [6:0] task1leds;
	logic [3:0] seg7in;
	
	
	
	/* temp key logic to use in double flip flop to prevent metastability */ 
	logic oldKey0, newKey0;
	logic oldKey3, newKey3;
	
	/* output from status of task1 */
	logic task1done;
	
	/* hold the output of Loc from binarySearch */
	logic [4:0] Loc;
	
	/* otuputs from binarySearch*/
	logic Found, task2done;
	
	/* temporary logic for LocOuts from Task 2 */
	logic [6:0] locOut0, locOut1;
	
	/* 2 DFFs to prevent metastability for start and reset */
	always_ff @(posedge clk) begin
		oldKey0 <= ~KEY[0];
		newKey0 <= oldKey0;
		
		oldKey3 <= ~KEY[3];
		newKey3 <= oldKey3;
	
	end // always_ff
	
	/* global assignments for the board */
	assign reset = newKey0;
	assign s = newKey3;
	assign clk = CLOCK_50;
	assign A = SW[7:0];
	
	
	
	
	/* Instantiations of Task1 */
	bitCount countOnes(.clk, .reset, .s, .A, .result(seg7in), .done(task1done));
	seg7 hexOut(.hex(seg7in), .leds(task1leds));
	
	
	/* Instantiations of Task2 */
	binarySearch algorithm(.clk, .Reset(reset), .A, .Start(newKey3), .Loc, .Found, .Done(task2done));
	seg7 hexOut0(.hex(Loc[3:0]), .leds(locOut0));
	seg7 hexOut1(.hex(Loc[4]), .leds(locOut1));
	
	
	
	/* Toggle between Task1 and Task2 
	 * If SW[9] is high, perform task 1
	 * Otherwise, do task 2
	 */
	always_comb begin 
		if (SW[9]) begin
			HEX0 = task1leds; 
			HEX1 = 7'b1111111; // do not need HEX1 for task1
			LEDR[9] = task1done;
			LEDR[0] = 0;
		end // if
		else if (Found) begin // if the address is found, display it
			HEX0 = locOut0;
			HEX1 = locOut1;
			LEDR[9] = task2done;
			LEDR[0] = Found;
		end // else if
		else begin            // if the address is not found, do nothing
			HEX0 = 7'b1111111;
			HEX1 = 7'b1111111;
			LEDR[9] = task2done;
			LEDR[0] = Found;
		end // else
	end // always_comb
	
endmodule


/* DE1_SoC top level testbench */
`timescale 1 ps / 1 ps
module DE1_SoC_testbench();
	
	logic [9:0] SW;
	logic [3:0] KEY;
	logic CLOCK_50;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1;

	DE1_SoC dut(.*);
	// generated clock for sim
	initial begin
		CLOCK_50 = 1;
		forever #50 CLOCK_50 = ~CLOCK_50;
	end // initial	
	
	/* Simple test bench to test top-level functionality
	 * First, do task1 and perform a simple bit count with a random number with 4 1s
	 * Then, toggle to task2 and find the location of 33 in the ROM, and then display it 
	 * if it exists
	 */
	initial begin 
		SW[9] <= 1; KEY[0] <= 0; SW[7:0] <= 8'b11001100; @(posedge CLOCK_50); // has 4 ones
		KEY[0] <= 1; KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(15) @(posedge CLOCK_50);
		
		KEY[3] <= 1; repeat(3) @(posedge CLOCK_50);
		
		SW[9] <= 0; SW[7:0] <= 8'd33; @(posedge CLOCK_50); // finds a value that exists in the ROM
		KEY[3] <= 0; repeat(15) @(posedge CLOCK_50);
		KEY[3] <= 1; repeat(2) @(posedge CLOCK_50);
		KEY[3] <= 0; SW[7:0] <= 8'd255; repeat(15) @(posedge CLOCK_50); // try to find a value that does not exist in the ROM
		
	$stop;
	end // initial
	
endmodule // DE1_SoC testbench
