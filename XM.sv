import definitions::*;

module XM(	input wire clk,
		input wire rst,
		
		input Signal fwdM_rt,

		input Register M_d,

		input XM_ctrl ctrl,

		// Data from Execute
		input X_output x_out,

		// Control signals from control
		output MW_ctrl mw_ctrl,
		output M_ctrl  m_ctrl,

		output M_data  m_data
);

always_ff @ (posedge clk) begin
	mw_ctrl     <= ctrl.mw;
	m_ctrl      <= ctrl.m;
	m_data.dst  <= x_out.dst_addr;
	m_data.addr <= x_out.alu;
	m_data.val  <= (fwdM_rt == ENABLE) ? M_d : x_out.rt;
end

endmodule

