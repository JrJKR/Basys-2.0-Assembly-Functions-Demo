//------------------------------------------------
// newMIPStop.v
// Will Sawyer 23 November 2013
// based on Figure 7.59 page 429 in DDCA 2nd ed, 
//   and on top.v, by David_Harris written 9 November 2005
// Top-level system including MIPS, instruction and data memories,
//    with inputs and outputs for BASYS2 board implementation
//------------------------------------------------

module newtop(input clk, reset, 
           input Rs_switch, Rt_switch, RFin_switch,
           input  [7:0]  input_switch_data,
           output [15:0] ControlSignals, Instr_LSH, Rs_LSH, Rt_LSH,
           output [15:0] ReadData_LSH, RF_indata_LSH,
           output [7:0]  PC_LSB, ALUOut_LSB );

  wire [31:0] PC, Instr, ReadData, WriteData, ALUOut;
  wire memwrite;
 
  // assign the LSB and LSH outputs, for display
   assign Instr_LSH = Instr[15:0];
   assign ReadData_LSH = ReadData[15:0];
   assign PC_LSB = PC[7:0];
   assign ALUOut_LSB = ALUOut[7:0];

  
  // instantiate processor and memories
  newmips mips(clk, reset, PC, Instr, memwrite, ALUOut, WriteData, ReadData, 
               Rs_switch, Rt_switch, RFin_switch, input_switch_data, 
	       ControlSignals, Rs_LSH, Rt_LSH, RF_indata_LSH);
  imem imem(PC[7:2], Instr);
  dmem dmem(clk, memwrite, ALUOut, WriteData, ReadData);

endmodule
