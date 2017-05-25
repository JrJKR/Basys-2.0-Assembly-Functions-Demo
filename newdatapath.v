//--------------------------------------------------------------
//   newdatapath.v
//   Will Sawyer 23 November 2013
//      based on datapath in mips.v by David_Harris and Sarah_Harris 23 October 2005
//   datpath for single-cycle MIPS processor
//--------------------------------------------------------------

module newdatapath (input clk, reset, 
					 input [1:0] memtoreg, //2bits
					 input pcsrc,
                input [1:0] alusrc/*2bits*/, regdst, /*2bits*/
					 input regwrite, 
					 input [1:0] jump, //2bits
                input  [2:0]  alucontrol,
                output        zero,
                output [31:0] pc, 
                input  [31:0] instr,
                output [31:0] aluout, writedata,
                input  [31:0] readdata,
                input         Rs_switch, Rt_switch, RFin_switch,
                input  [7:0]  switch_data,
                output [15:0] Rs_LSH, Rt_LSH, RF_indata_LSH
                );

  wire [4:0]  writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [31:0] signimm, signimmsh;
  wire [31:0] Rs, Rt, srca, srcb;
  wire [31:0] result, regwrdata;
 
  
  
  // 3 MUXes are inserted, to allow choosing the 8-bit switch_data as LSByte
  assign srca = {Rs[31:8], (Rs_switch==1)? switch_data : Rs[7:0]};
  assign writedata = {Rt[31:8], (Rt_switch==1)? switch_data : Rt[7:0]};
  assign regwrdata = {result[31:8], (RFin_switch==1)? switch_data : result[7:0]};

	 
  // extra outputs are assigned 
  assign Rs_LSH = srca[15:0];
  assign Rt_LSH = writedata[15:0];
  assign RF_indata_LSH = regwrdata[15:0];
  
  // next PC logic
  flopr #(32) pcreg (clk, reset, pcnext, pc);
  adder       pcadd1 (pc, 32'b100, pcplus4);
  sl2         immsh (signimm, signimmsh);
  adder       pcadd2 (pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux (pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux3 #(32)  pcmux (pcnextbr, {pcplus4[31:28], //*jump -> 2bit,
                    instr[25:0], 2'b00}, srca,  //*srca added as inp
                    jump, pcnext);

  // register file logic
  regfile     rf (clk, regwrite, instr[25:21],
						instr[20:16], writereg,
						regwrdata, Rs, Rt );
  mux4 #(5)   wrmux (instr[20:16], instr[15:11], 5'b11111, //*regdst -> 2bit, b'31 added as inp
                  instr[25:21], regdst, writereg); //**inst[25:21] = $sp by assembler 
  mux3 #(32)  resmux (aluout, readdata, pcplus4, // *memtoreg->2bit, mux2->3, pclus4 added as inp
                  memtoreg, result);
  signext     se (instr[15:0], signimm);

  // ALU logic
  mux4 #(32)  srcbmux (writedata, signimm, {16'h0000, instr[15:0]}, // alusrc->2bit, instr[15:0] added as inp
						32'hfffffffc, alusrc, srcb); //**hardwired -4
  alu         alu (srca, srcb, alucontrol,
                  aluout, zero);
endmodule
