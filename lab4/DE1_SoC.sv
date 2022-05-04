module DE1_SoC(CLOCK_50, SW, LEDR, HEX0, HEX1, KEY);

	input logic [9:0] SW;
	input logic [3:0] KEY;
	input logic CLOCK_50;
	
	output logic [9:0] LEDR;
	output logic [6:0] HEX0, HEX1;
	
	logic reset, clk, s;
	logic [6:0] task1leds;
	logic [3:0] seg7in;
	logic [7:0] A;
	logic oldKey0, newKey0;
	logic oldKey3, newKey3;
	logic task1done;
	
	logic [4:0] Loc;
	logic Found, task2done;
	
	logic [6:0] locOut0, locOut1;
	
	// 2 DFFs to prevent metastability
	always_ff @(posedge clk) begin
		oldKey0 <= ~KEY[0];
		newKey0 <= oldKey0;
		
		oldKey3 <= ~KEY[3];
		newKey3 <= oldKey3;
	
	end // always_ff
	
	
	assign reset = newKey0;
	assign s = newKey3;
	assign clk = CLOCK_50;
	assign A = SW[7:0];
	
	
	
	// assign HEX0 = leds;
	
	bitCount countOnes(.clk, .reset, .s, .A, .result(seg7in), .done(task1done));
	seg7 hexOut(.hex(seg7in), .leds(task1leds));
	
	
	
	binarySearch algorithm(.clk, .Reset(reset), .A, .Start(newKey3), .Loc, .Found, .Done(task2done));
	
	seg7 hexOut0(.hex(Loc[3:0]), .leds(locOut0));
	seg7 hexOut1(.hex(Loc[4]), .leds(locOut1));
	
	
	
	/* Toggle between Task1 and Task2 */
	always_comb begin 
		if (SW[9]) begin
			HEX0 = task1leds; 
			HEX1 = 7'b1111111;
			LEDR[9] = task1done;
			LEDR[0] = 0;
		end
		else if (Found) begin
			HEX0 = locOut0;
			HEX1 = locOut1;
			LEDR[9] = task2done;
			LEDR[0] = Found;
		end 
		else begin
			HEX0 = 7'b1111111;
			HEX1 = 7'b1111111;
			LEDR[9] = task2done;
			LEDR[0] = Found;
		end
	end
	
endmodule


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
	

	initial begin 
		SW[9] <= 1; KEY[0] <= 0; SW[7:0] <= 8'b11001100; @(posedge CLOCK_50);
		KEY[0] <= 1; KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(15) @(posedge CLOCK_50);
		
		KEY[3] <= 1; repeat(3) @(posedge CLOCK_50);
		
		SW[9] <= 0; SW[7:0] <= 8'd33; @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(15) @(posedge CLOCK_50);
		
	$stop;
	end
	
endmodule
