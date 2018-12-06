import definitions::*;

module XM(	input wire clk,
		input wire rst,
		
		input Signal fwdM_rt,

		input Register M_d,

		// Control signals from control
		input wire reg_write,
		input wire read_mem,
		input wire write_mem,
		input wire memToReg,
		input wire branch,
		input wire jmp,

		// Data from Execute
		input ProgramCounter pc,
		input wire alu_zero,
		input wire [31:0] alu_out,
		input wire [31:0] write_d,
		input RegAddr  rd_a,

		// Control signals from control
		output reg reg_write_o,
		output reg read_mem_o,
		output reg write_mem_o,
		output reg memToReg_o,
		output reg branch_o,
		output reg jmp_o,

		// Data to Memory / Branch
		output ProgramCounter pc_o,
		output reg alu_zero_o,
		output reg [31:0] alu_out_o,
		output reg [31:0] write_d_o,
		output RegAddr  rd_a_o);

always_ff @ (posedge clk) begin
	reg_write_o <= reg_write;
	read_mem_o <= read_mem;
	write_mem_o <= write_mem;
	memToReg_o <= memToReg;
	branch_o <= branch;
	jmp_o <= jmp;

	pc_o <= pc;
	alu_zero_o <= alu_zero;
	alu_out_o <= alu_out;
	write_d_o <= (fwdM_rt == ENABLE) ? M_d : write_d;
	rd_a_o <= rd_a;

end

endmodule

