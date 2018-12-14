import definitions::*;

module FD(
	input wire clk,
	input wire rst,
	input Signal bubble,
	input Signal stall,
		
	input ProgramCounter next_pc_i,
	input Instruction instr_i,

	output ProgramCounter next_pc_o,
	output Instruction instr_o
);

always_ff@(posedge clk) begin
	if(bubble) begin
		next_pc_o <= ProgramCounter'(0);
		instr_o <= Instruction'(0);
	end
	else if(stall) begin
		next_pc_o <= next_pc_o;
		instr_o   <= instr_o;
	end
	else begin
		next_pc_o <= next_pc_i;
		instr_o   <= instr_i;
	end
end

endmodule
