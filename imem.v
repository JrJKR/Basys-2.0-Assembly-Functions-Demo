//-----------------------------------------------
// imem.v   by Will Sawyer 21 November 2013
// External instruction memory used by MIPS single-cycle processor
// 
// Models instruction memory as a stored=program ROM, 
//    with address as input, and instruction as output
//------------------------------------------------



module imem(	input [5:0] addr,
    		output reg [31:0] instr);

	always@(addr)
	   case ({addr,2'b00})
//		address		instruction
//		-------		-----------
//		 8'h00: instr = 32'h20400001;
//		 8'h04: instr = 32'h20800002;
//		 8'h08: instr = 32'h00401013;
//		 8'h0c: instr = 32'h00002012;
//		 8'h10: instr = 32'h10820001;
//		 8'h14: instr = 32'h00000000;
//		 8'h18: instr = 32'h1082fffd;

		8'h00: instr = 32'h20020005; //*addi $v0, $0, 5
		8'h04: instr = 32'h2003000c; //*addi $v1, $0, 12
		8'h08: instr = 32'h00434020; //*add $t0, $v1, $v0
//		8'h08: instr = 32'h3068000F; //*andi $t0, $v1, 15
		8'h0c: instr = 32'h30680000; //*andi $t0, $v1, 0
		8'h10: instr = 32'h30680004; //*andi $t0, $v1, 4
		8'h14: instr = 32'h20020060; //*addi $v0, $0, 2h'60
		8'h18: instr = 32'h00400009; //*jalr $v0
		8'h1c: instr = 32'h08000005; // j 14, so it will loop here
		
		8'h60: instr = 32'hF8000000;
		8'h64: instr = 32'hF8000000;
		8'h68: instr = 32'hF8000000;
		8'h6c: instr = 32'hF8000000;
		8'h70: instr = 32'h00600013; //**MTLO lo = $v1, 12
		8'h74: instr = 32'h00001802; //**MFLO $v0 = lo
		8'h78: instr = 32'h00001802; //**MFLO $v0 = lo
		8'h7c: instr = 32'h20030000; //*addi $v0, $v0, 0
		8'h80: instr = 32'hf3a20000; //**push $v0
		8'h84: instr = 32'hf4430003; //**bgt $v0, $v1, 3
		
		8'h94: instr = 32'h08000008; //j 20
//	      default: instr = {32{1'bx}};	// unknown instruction
	    endcase

endmodule
