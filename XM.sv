import definitions::*;

module XM(	input wire clk,
		input wire rst,

		input XM_ctrl ctrl,

		// Data from Execute
		input X_output x_out,

		input ProgramCounter pc_jmp,

		// Control signals from control
		output MW_ctrl mw_ctrl,
		output M_ctrl  m_ctrl,

		output M_data  m_data,
		output RegAddr m_src,

		output ProgramCounter pc_jmp_o
);

always_ff @ (posedge clk) begin
	mw_ctrl          <= ctrl.mw;
	m_ctrl           <= ctrl.m;
	m_data.dst       <= (rst) ? RegAddr'(0) : x_out.dst_addr;
	m_data.addr      <= x_out.alu;
	m_data.val       <= x_out.rt;
	m_data.alu_zero  <= x_out.zero;
	m_data.pc_branch <= x_out.pc_branch;
	m_src            <= x_out.rt_addr;
	pc_jmp_o         <= pc_jmp;
end

endmodule

