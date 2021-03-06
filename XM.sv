import definitions::*;

module XM(	input wire clk,
		input wire rst,
		input Signal bubble,
		input XM_ctrl ctrl,

		// Data from Execute
		input X_output x_out,
		input Register ft,

		input ProgramCounter pc_jmp,
		
		input Operate_in cmp_out,

		// Control signals from control
		output MW_ctrl mw_ctrl,
		output M_ctrl  m_ctrl,

		output XM_data  xm_data,
		output RegAddr m_src,

		output ProgramCounter pc_jmp_o,

		output Operate_in op_in
);

always_ff @ (posedge clk) begin
if(bubble) begin
	mw_ctrl <= MW_ctrl'(0);
	m_ctrl <= M_ctrl'(0);
	xm_data <= XM_data'(0);
	m_src <= RegAddr'(0);
	pc_jmp_o <= ProgramCounter'(0);
    op_in <= Operate_in'(0);
end
else begin
	mw_ctrl          <= ctrl.mw;
	m_ctrl           <= ctrl.m;
	xm_data.dst       <= (rst) ? RegAddr'(0) : x_out.dst_addr;
	xm_data.fpu_dst   <= RegAddr'(0);
	xm_data.addr      <= x_out.alu;
	xm_data.alu_val   <= x_out.rt;
    xm_data.fpu_val   <= ft;
	xm_data.alu_zero  <= x_out.zero;
	xm_data.pc_branch <= x_out.pc_branch;
	m_src            <= x_out.rt_addr;
	pc_jmp_o         <= pc_jmp;

        op_in <= cmp_out;
end
end
endmodule

