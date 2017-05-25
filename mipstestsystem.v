//////////////////////////////////////////////////////////////////////////////////
// 
//  MIPStestsystem.v
// 
//  by Will Sawyer on 11/23/2013 
// 
//  detailed explanation in the document "Verilog Modules for MIPS testing.doc"
// 
//////////////////////////////////////////////////////////////////////////////////

module MIPStestsystem(
    input clk_50MHz,
    input push_clk,
    input push_reset,
    input clear,
    input [2:0] LED_cntl,
    input [2:0] MUXdata_cntl,
    input [7:0] data_switches,
    output [7:0] Digilent_LEDS,
    output [7:0] Beti_LEDS,
    output [3:0] AN,
    output [6:0] C,
    output       DP      
    );

    wire clk_internal, reset_internal;
	 wire [15:0] ControlSignals, Instr_LSH, Rs_LSH, Rt_LSH;
	 wire [15:0] ReadData_LSH, RF_indata_LSH, MUXout;
	 wire [7:0]  PC_LSB, ALUOut_LSB;

	 
	 assign Beti_LEDS = MUXout[15:8];
	 assign Digilent_LEDS = MUXout[7:0];

    newtop ntop (clk_internal, reset_internal, MUXdata_cntl[2], 
	              MUXdata_cntl[1], MUXdata_cntl[0], data_switches,
					  ControlSignals, Instr_LSH, Rs_LSH, Rt_LSH, ReadData_LSH,
					  RF_indata_LSH, PC_LSB, ALUOut_LSB);
					  
    display_controller dc (clk_50MHz, push_reset, 4'b1111, PC_LSB[7:4], PC_LSB[3:0], 
	                        ALUOut_LSB[7:4], ALUOut_LSB[3:0], AN, C, DP);
    pulse_controller  pc1 (clk_50MHz, push_clk, clear, clk_internal);
    pulse_controller  pc2 (clk_50MHz, push_reset, clear, reset_internal);
    MUX_8to1 mux (LED_cntl, MUXout,
	               ControlSignals, Instr_LSH, Rs_LSH, 
	               Rt_LSH, ReadData_LSH, RF_indata_LSH,
						{16{1'b0}}, {16{1'b0}} );
endmodule
