module Controller_TB();

import definitions::*;

logic msb;
logic [2:0] opCode;
wire alu_control_signals ALUop;
wire reg_write;
wire set;
wire bne;
wire read_mem;
wire write_mem;
wire memToReg;
wire bypass;
wire slp;
   


Controller Controller1(
  .msb       	(msb),     		//msb of opcode (need for SET)
  .opCode  	(opCode  ),		//next 3 digits of opcode
  .ALUop        (ALUop  ),		//used for ALU, some are don't cares
  .reg_write    (reg_write    ),	//write to reg?
  .set         	(set     ),		//set instruction from msb
  .bne         	(bne     ),  		//branch not equals?	
  .read_mem     (read_mem    ), 	//read memory?
  .write_mem    (write_mem    ),	//write memory? 
  .memToReg     (memToReg     ),	//write from memory to reg?
  .bypass       (bypass     ),		//signal after ALU, choose ALU or bypass ALU
  .slp         	(slp     )  		//signal to choose shift or original value from reg

  );

initial begin
  msb = 1;
  opCode = 3'b000;
  #10ns

  msb = 0;
  opCode = 3'b000;
  #10ns

  msb = 0;
  opCode = 3'b001;
  #10ns

  msb = 0;
  opCode = 3'b010;
  #10ns

  msb = 0;
  opCode = 3'b011;
  #10ns

  msb = 0;
  opCode = 3'b100;
  #10ns
  
  msb = 0;
  opCode = 3'b101;
  #10ns

  msb = 0;
  opCode = 3'b110;
  #10ns

  msb = 0;
  opCode = 3'b111;
  #10ns
  
  #20ns $stop;
end



endmodule