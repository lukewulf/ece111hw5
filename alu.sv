
import definitions::*;
	 
module alu (	input  [31:0] rs_i,
            	input  [31:0] rt_i,
            	input  op_code op_i,
           	output logic [31:0] result_o,
		output logic zero);
		


op_code op3; 	                   
assign op3 = op_i;		 

always_comb							
  begin
	result_o = 'd0;        
  
  
  case (op3)   						

	OR: begin					
		result_o = rs_i | rt_i;
		end

	AND: begin					
		result_o = rs_i & rt_i;
		end

	ADD: begin					
		result_o = rs_i + rt_i;
		end

	SUB: begin
		result_o = rs_i - rt_i;
		end

  endcase

  zero = ~(|result_o);

  end

endmodule 
