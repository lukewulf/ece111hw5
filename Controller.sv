// Create Date:    2018.05.10
// Latest rev:     2018.05.10
// Created by:     Luke Wulf and Jasmine Simmons
// Design Name:    CSE141L
// Module Name:    controller.sv
/*Function: 	Decodes the opCode from the first 4 bits of the instruction and sends the necessary control signals
		to the rest of the processor
*/
import definitions::*;

module Controller(
	input [5:0] opCode,		//opCode to decode
	output logic [1:0] ALUop,		//ALU operation to send to ALU
	output logic aluSrc,
	output logic reg_write,		//Register File Write Control
	output logic read_mem,		//Data Memory Read Control
	output logic write_mem,		//Data Memory Write Control
	output logic memToReg,		//Control to choose between memory and ALU output
	output logic jmp,		//Control to Jump
	output logic branch,
	output logic reg_dst		//Control to Choose which reg to write to
);



always_comb								  // no registers, no clocks
  begin
 	 case (opCode)   			   // case statement for opCode

		// ADD, SUB, AND, OR
		6'b00_0000: begin		// R Type
				ALUop = 2'b00;			
				aluSrc = 1'b0;
				reg_write = 1'b1;		// writing to a register
				read_mem = 1'b0;		// reading from mem
				write_mem = 1'b0;
				memToReg = 1'b0;		// porting mem data to register
				jmp = 1'b0;
				branch = 1'b0;
				reg_dst = 1'b1;
			end
		// ADDI
		6'b00_1000: begin	
				ALUop = 2'b01;			
				aluSrc = 1'b1;
				reg_write = 1'b1;		
				read_mem = 1'b0;		
				write_mem = 1'b0;
				memToReg = 1'b0;		
				jmp = 1'b0;
				branch = 1'b0;
				reg_dst = 1'b0;		
			end
		// BEQ
		6'b00_0100: begin	
				ALUop = 2'b10;				
				aluSrc = 1'b0;
				reg_write = 1'b0;		
				read_mem = 1'b0;		
				write_mem = 1'b0;
				memToReg = 1'b0;		
				jmp = 1'b0;
				branch = 1'b1;
				reg_dst = 1'b1;
			end
		// LW
		6'b10_0011: begin					
				ALUop = 2'b01;		
				aluSrc = 1'b1;
				reg_write = 1'b1;		
				read_mem = 1'b1;		
				write_mem = 1'b0;
				memToReg = 1'b1;		
				jmp = 1'b0;
				branch = 1'b0;
				reg_dst = 1'b0;

			end
		// SW
		6'b10_1011: begin					
				ALUop = 2'b01;		
				aluSrc = 1'b1;
				reg_write = 1'b0;		
				read_mem = 1'b0;		
				write_mem = 1'b1;
				memToReg = 1'b0;		
				jmp = 1'b0;
				branch = 1'b0;
				reg_dst = 1'b0;

			end

		// J
		6'b00_0010: begin
				ALUop = 2'b00;
				aluSrc = 1'b0;
				reg_write = 1'b0;
				read_mem = 1'b0;
				write_mem = 1'b0;
				memToReg = 1'b0;
				jmp = 1'b1;
				branch = 1'b0;
				reg_dst = 1'b0;
		end
		default: begin

			end
   	 endcase

  end

endmodule 