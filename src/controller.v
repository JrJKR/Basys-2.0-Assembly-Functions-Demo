//
//  from mips.v
//  by David_Harris and Sarah_Harris 23 October 2005
//
/////////////////////////////////////////////////////////


module controller (input [5:0] op, funct,
                  input        zero,
                  output [1:0] memtoreg, //*2bits
						output memwrite, pcsrc, 
						output [1:0] alusrc, regdst, //*2bits
						output regwrite,
                  output [1:0] jump, //*2bits
                  output [2:0] alucontrol);

  wire [1:0] aluop;
  wire       branch;

  maindec md (op, funct, regwrite, regdst, alusrc, //*funct
             branch, memwrite, memtoreg, 
             aluop, jump);
  aludec  ad (funct, aluop, alucontrol);

  assign pcsrc = branch & zero;
endmodule

module maindec (input [5:0] op, funct, //*funct
               output       regwrite,
               output [1:0] regdst, alusrc, //*2bits
					output branch, 
               output       memwrite, 
					output [1:0] memtoreg, //*2bits
               output [1:0] aluop, 
               output [1:0] /*2bits*/ jump);

  reg [12:0] controls; //*13bits

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, aluop, jump} = controls;

  always @ (*)
    case(op)
      6'b000000: controls <= ( funct == 6'b001001 )? 13'b1100000100010 : 13'b101000000xx00; //Rtype, *if(funct)
      6'b100011: controls <= 13'b1000100010000; //LW
      6'b101011: controls <= 13'b0000101000000; //SW
      6'b000100: controls <= 13'b0000010000100; //BEQ
      6'b001000: controls <= 13'b1000100000000; //ADDI
      6'b000010: controls <= 13'b0000000000001; //J
		6'b001100: controls <= 13'b1001000001000; //*ANDI
		6'b111110: controls <= 13'b0000000000000; //*NOP
		6'b111101: controls <= 13'b0000010001100; //**BGT
		6'b111100: controls <= 13'b1111101000000; //**PUSH
      default:   controls <= 13'bxxxxxxxxxxxxx; //???
    endcase
endmodule

module aludec (input      [5:0] funct,
               input      [1:0] aluop,
               output reg [2:0] alucontrol);

  always @ (*)
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add //push
      2'b01: alucontrol <= 3'b110;  // sub
		2'b10: alucontrol <= 3'b000;  // *andi
		2'b11: alucontrol <= 3'b111;  // **bgt
      default: case(funct)          // RTYPE
          6'b100000: alucontrol <= 3'b010; // ADD
          6'b100010: alucontrol <= 3'b110; // SUB
          6'b100100: alucontrol <= 3'b000; // AND
          6'b100101: alucontrol <= 3'b001; // OR
          6'b101010: alucontrol <= 3'b111; // SLT
			 6'b010010: alucontrol <= 3'b011; // **MFLO 3
			 6'b010011: alucontrol <= 3'b100; // **MTLO 4
			 6'b101011: alucontrol <= 3'b101; // **SLTE 5
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase
endmodule
