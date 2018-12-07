import definitions::*;

module FD(
	input wire clk,
	input wire rst,
	input Signal stall,
		
	input ProgramCounter next_pc_i,
	input Instruction instr_i,

	output ProgramCounter next_pc_o,
	output Instruction instr_o
);

always_ff@(posedge clk) begin
	if(stall != ENABLE) begin
		next_pc_o <= next_pc_i;
		instr_o <= instr_i;
	end
end

endmodule
