import definitions::*;

module DX(	input wire clk,
		input wire rst,
		
		// Control signals from hazard detection unit
		input Signal fwdX_rs,
		input Signal fwdX_rt,
		input Signal fwdM_rs,
		input Signal fwdM_rt,
		input Signal stall,

		// Forwarded Data
		input Register X_d,
		input Register M_d,

		// Control signals from control
		input wire [1:0]  ALUop,
		input wire aluSrc,
		input wire reg_write,
		input wire read_mem,
		input wire write_mem,
		input wire memToReg,
		input wire jmp,
		input wire branch,
		input wire reg_dst,

		// Data from Instruction Decode
		input ProgramCounter pc,
		input RegAddr  rs_a,
		input Register rs_d,
		input RegAddr  rt_a,
		input Register rt_d,
		input RegAddr  rd_a,
		input wire [31:0] imm,

		// Control signals from control
		output reg [1:0]  ALUop_o,
		output reg aluSrc_o,
		output reg reg_write_o,
		output reg read_mem_o,
		output reg write_mem_o,
		output reg memToReg_o,
		output reg jmp_o,
		output reg branch_o,
		output reg reg_dst_o,

		// Data from Instruction Decode
		output ProgramCounter pc_o,
		output RegAddr  rs_a_o,
		output Register rs_d_o,
		output RegAddr  rt_a_o,
		output Register rt_d_o,
		output RegAddr  rd_a_o,
		output reg [31:0] imm_o);

always_ff @(posedge clk) begin
	if(stall != DISABLE) begin
		// Control signals
		ALUop_o <= ALUop;
		aluSrc_o <= aluSrc;
		reg_write_o <= reg_write;
		read_mem_o <= read_mem;
		write_mem_o <= write_mem;
		memToReg_o <= memToReg;
		jmp_o <= jmp;
		branch_o <= branch;
		reg_dst_o <= reg_dst;

		pc_o <= pc;
		rs_a_o <= rs_a;
		rs_d_o <= (fwdX_rs) ? X_d : (fwdM_rs) ? M_d : rs_d;
		

		rt_a_o <= rt_a;
		rt_d_o <= (fwdX_rt) ? X_d : (fwdM_rt) ? M_d : rt_d;
		
		rd_a_o <= rd_a;

		imm_o <= imm;
	end 
	else begin
		reg_write_o <= 0;
		write_mem_o <= 0;
	end
end

endmodule
