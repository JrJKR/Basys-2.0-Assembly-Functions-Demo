////////////////////////////
//
//  by Will Sawyer  23 November 2013
//
//  16-bit 8-to-1 MUX 
//  modelled in behavioral style Verilog
//
//
////////////////////////////


module MUX_8to1 (
		input [2:0] select,
		output reg [15:0] Muxout,
		input [15:0] d0, d1, d2, d3, d4, d5, d6, d7	
		);

      always @ (*)
	case (select)
	3'b000: Muxout = d0;
	3'b001: Muxout = d1;
	3'b010: Muxout = d2;
	3'b011: Muxout = d3;
	3'b100: Muxout = d4;
	3'b101: Muxout = d5;
	3'b110: Muxout = d6;
	3'b111: Muxout = d7;
	default: Muxout = {16{1'bx}};	
	endcase
endmodule
