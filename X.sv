import definitions::*;

module X(
	input  X_input  in,
	output X_output out
);

assign out.pc_branch = in.pc + in.imm + 1;
assign out.dst_addr  = in.ctrl.reg_dst ? in.rd_addr : in.rt_addr;
assign out.rt        = in.rt;

op_code alu_controller_out;

wire [31:0] alu_b = in.ctrl.alu_src ? in.imm : in.rt;

wire alu_zero;
assign out.zero = Signal'(alu_zero);

ALU_Controller alu_c(
	.func(in.imm[5:0]), 
	.op(in.ctrl.alu_op),
	.alu_op(alu_controller_out)
);

alu alu_x(
	.rs_i(in.rs),
	.rt_i(alu_b),
	.op_i(alu_controller_out),
	.result_o(out.alu),
	.zero(alu_zero)
);

endmodule

