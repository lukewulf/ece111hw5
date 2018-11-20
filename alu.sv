// Create Date:     2017.05.05
// Latest rev date: 2017.10.26
// Created by:      J Eldon
// Design Name:     CSE141L
// Module Name:     ALU (Arithmetic Logical Unit)


//This is the ALU module of the core, op_code_e is defined in definitions.v file
// Includes new enum op_mnemonic to make instructions appear literally on waveform.
import definitions::*;
	 
module alu (	input  [31:0] rs_i,	 // operand s
            	input  [31:0] rt_i,	 // operand t
            	input  op_code op_i,	 // instruction / opcode
           	output logic [31:0] result_o,	 // rslt
		output logic zero);
		


op_code op3; 	                     // type is op_code, as defined
assign op3 = op_i;		       // Assuming that controller takes care of ALUop signal

always_comb								  // no registers, no clocks
  begin
	result_o = 'd0;                 // default or NOP result
  
  
  case (op3)   						      // using top 3 bits as ALU instructions

	OR: begin					//Simple XOR
		result_o = rs_i | rt_i;
		end

	AND: begin					//Simple AND
		result_o = rs_i & rt_i;
		end

	ADD: begin					// Addition
		result_o = rs_i + rt_i;
		end

	SUB: begin
		result_o = rs_i - rt_i;
		end

  endcase

  zero = ~(|result_o);

  end

endmodule 
