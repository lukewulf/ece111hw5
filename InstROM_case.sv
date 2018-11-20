// Create Date:    2017.05.05
// Latest rev:     2017.10.26
// Created by:     J Eldon
// Design name:    CSE141L
// Module Name:    InstROM_case 

// Generic instruction memory
// using case statement instead of reading in a file
// good if small and constant; bad if large and/or w/ variable contents
// same format as any lookup table
// width = 9 bits (per assignment spec.)
// depth = 2**IW (default IW=16)
module InstROM_case #(parameter IW=8)(
  input       [IW-1:0] InstAddress,
  output logic[   8:0] InstOut);
	 
  logic [8:0] inst_rom [2**IW];	   // 2**IW elements, 9 bits each
// no need to load machine code program into instruction ROM,
//   because it is hard-wired into this design itself

// continuous combinational read output  
//   change the pointer (from program counter) ==> change the output
// note use of unsized binary for the index, since InstAddress width 
//  is parametric
  always_comb case(InstAddress)
    'b000: InstOut = 9'b1_0000_1100;   // whatever machine code you need
    'b001: InstOut = 9'b1_0011_1100;   // whatever machine code you need
    'b010: InstOut = 9'b1_1001_1100;   // whatever machine code you need
    'b011: InstOut = 9'b1_0000_1110;   // whatever machine code you need
    'b100: InstOut = 9'b1_0000_0000;   // whatever machine code you need
    'b101: InstOut = 9'b0_1000_1000;   // etc. 

  endcase

endmodule
