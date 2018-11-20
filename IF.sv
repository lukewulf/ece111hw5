// Create Date:    17:44:49 2012.16.02 
// Latest rev:     2017.10.26
// Design Name:    CSE141L
// Module Name:    IF 

// generic program counter
module IF(
  input              branch,      // branch to "offset"
  input signed[7:0] branch_adr,
  input Reset,
  input Halt,
  input CLK,
  output logic[7:0] PC             // pointer to insr. mem
  );

  logic state = 2'b00;

  always @(posedge CLK)

	if(Reset)                       // reset to 0 and hold there
	  PC <= 0;
	else if(Halt)					// freeze
	  PC <= PC;						
    	else if(branch)				// jump to definite address
	  PC <= branch_adr;
	else							// normal advance thru program
	  PC <= PC+1;

endmodule
