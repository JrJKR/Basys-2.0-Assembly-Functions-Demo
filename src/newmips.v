//--------------------------------------------------------------
// newmips.v
// Will Sawyer 23 November 2013
//   based on mips.v by David_Harris and Sarah_Harris 23 October 2005
// single-cycle MIPS processor
//--------------------------------------------------------------


// single-cycle MIPS processor
module newmips (input clk, reset,
            output [31:0] pc,
            input  [31:0] instr,
            output memwrite,
            output [31:0] aluout, writedata,
            input  [31:0] readdata,
            input  Rs_switch, Rt_switch, RFin_switch,
            input  [7:0]  switch_data,
            output [15:0] ControlSignals, Rs_LSH, Rt_LSH, RF_indata_LSH);

  wire pcsrc, zero, regwrite;
  wire [1:0]  memtoreg, alusrc, regdst, jump; //*2bits
  wire [2:0]  alucontrol;
  
  assign ControlSignals = {zero, memtoreg, memwrite, pcsrc, alusrc, //*still 16b
                          regdst, regwrite, jump, 1'b0, alucontrol } ;

  controller c (instr[31:26], instr[5:0], zero, memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump, alucontrol);

  newdatapath dp (clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite,
                 jump, alucontrol, zero, pc, instr, aluout, writedata, 
                 readdata, Rs_switch, Rt_switch, RFin_switch, switch_data,
                 Rs_LSH, Rt_LSH, RF_indata_LSH);

endmodule
