
import definitions::*;
	 
module alu (	input  [31:0] rs_i,
            	input  [31:0] rt_i,
            	input  alu_operation op_i,
           	output logic [31:0] result_o,
		output logic zero);
		


alu_operation op3; 	                   
assign op3 = op_i;		 

always_comb							
  begin
	result_o = 'd0;        
  
  
  case (op3)   						

	ALU_O_OR: begin					
		result_o = rs_i | rt_i;
		end

	ALU_O_AND: begin					
		result_o = rs_i & rt_i;
		end

	ALU_O_ADD: begin					
		result_o = rs_i + rt_i;
		end

	ALU_O_SUB: begin
		result_o = rs_i - rt_i;
		end

  endcase

  zero = ~(|result_o);

  end

endmodule 
