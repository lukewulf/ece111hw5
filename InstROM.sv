// Create Date:    2017.05.05
// Latest rev:     2017.10.26
// Created by:     J Eldon
// Design name:    CSE141L
// Module Name:    InstROM 

// Generic instruction memory
// same format as any lookup table
// width = 32 bits (per assignment spec.)  32/8 = 4 bytes * 16 = 64 bytes 
// depth = 2**IW (default IW=4) = 64 bytes
module InstROM #(parameter IW=4)(
  input       [IW-1:0] InstAddress,
  output logic[31:0] InstOut);
	 
  logic [31:0] inst_rom [2**IW];	   // 2**IW elements, 32 bits ea
// load machine code program into instruction ROM
  initial 
begin
	$display("TEST");
	$readmemb("newest16.bin", inst_rom);
end
// continuous combinational read output  
//   change the pointer (from program counter) ==> change the output
  assign InstOut = inst_rom[InstAddress];

endmodule
