//-----------------------------------------------
// dmem.v by David_Harris 23 October 2005
// 
// External data memory used by MIPS single-cycle
// processor
//------------------------------------------------

module dmem(input         clk, we,
            input  [31:0] addr, wd,
            output [31:0] rd);

  reg  [31:0] RAM[63:0];

  assign rd = RAM[addr[31:2]]; // word aligned read (for lw)

  always @(posedge clk)
    if (we)
      RAM[addr[31:2]] <= wd;   // word aligned write (for sw)

endmodule
