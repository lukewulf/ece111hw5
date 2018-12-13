import definitions::*;

module ALU_Controller(	input [5:0] func,
			input alu_control_signals op,
			output alu_operation alu_op);
	
always_comb
begin
	case(op)
		2'b00:		// R Type -> Function Bits
		begin
			case(func)
				// Add
				6'b10_0000: alu_op = ALU_O_ADD;
				// Sub
				6'b10_0010: alu_op = ALU_O_SUB;
				// And
				6'b10_0100: alu_op = ALU_O_AND;
				// Or
				6'b10_0101: alu_op = ALU_O_OR;
				// XOR
				6'b10_0110: alu_op = ALU_O_XOR;
			endcase
		end
		2'b01:		// I Type Add -> ADD
		begin
			alu_op = ALU_O_ADD;
		end

		2'b10:		// BEQ -> SUB
		begin
			alu_op = ALU_O_SUB;
		end

		default:
		begin

		end
	endcase
end
endmodule
