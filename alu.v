//////////////////////////////////////////////////////////////////////////////////
// Company: Bilkent
// Engineer: Will Sawyer
// 
// Create Date:    11/23/2013 
//
//////////////////////////////////////////////////////////////////////////////////

module alu  (input [31:0] A,
             input [31:0] B,
             input [2:0] ALUControl,
             output reg[31:0] Result,
             output Zero
             );

reg [31:0] regmt;

	always @ (A or B or ALUControl or regmt)
		case(ALUControl)
		  3'b000: Result <= A & B; // AND
		  3'b001: Result <= A | B; // OR
		  3'b010: Result <= A + B; // ADD
//		  3'b011: Result <= A * B; // **MULT
		  3'b110: Result <= A - B; // SUB
		  3'b111: Result <= (A < B)? 1:0; // SLT
		  3'b101: Result <= (A <= B)? 1:0; // **SLTE 5
		  3'b011: Result <= regmt; // **MFLO 3
		  3'b100: begin regmt <= A; Result <= regmt; end// **MTLO 4
		 default: Result <= {32{1'b1}}; //undefined ALU operation
		endcase

	assign Zero = (Result==0) ? 1 : 0 ;

endmodule
