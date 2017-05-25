`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:51:43 04/02/2015
// Design Name:   MIPStestsystem
// Module Name:   D:/CS224/Lab05/MIPStest.v
// Project Name:  Lab05
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MIPStestsystem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MIPStest;

	// Inputs
	reg clk_50MHz;
	reg push_clk;
	reg push_reset;
	reg clear;
	reg [2:0] LED_cntl;
	reg [2:0] MUXdata_cntl;
	reg [7:0] data_switches;

	// Outputs
	wire [7:0] Digilent_LEDS;
	wire [7:0] Beti_LEDS;
	wire [3:0] AN;
	wire [6:0] C;
	wire DP;

	// Instantiate the Unit Under Test (UUT)
	MIPStestsystem uut (
		.clk_50MHz(clk_50MHz), 
		.push_clk(push_clk), 
		.push_reset(push_reset), 
		.clear(clear), 
		.LED_cntl(LED_cntl), 
		.MUXdata_cntl(MUXdata_cntl), 
		.data_switches(data_switches), 
		.Digilent_LEDS(Digilent_LEDS), 
		.Beti_LEDS(Beti_LEDS), 
		.AN(AN), 
		.C(C), 
		.DP(DP)
	);

	initial begin
		// Initialize Inputs
		clk_50MHz = 0;
		push_clk = 0;
		push_reset = 0;
		clear = 0;
		LED_cntl = 0;
		MUXdata_cntl = 0;
		data_switches = 0;

		// Wait 100 ns for global reset to finish
		#10; push_reset = 1; clear = 1;
		#10; push_reset = 0; clear = 0;
		#10; push_reset = 1; clear = 1;
		
        
		// Add stimulus here

	end
	
	always
		#10 clk_50MHz = ~clk_50MHz;
		
	always @(posedge clk_50MHz) begin
		#5 push_clk = ~push_clk;
		#5 push_clk = ~push_clk;
	end
	
endmodule

