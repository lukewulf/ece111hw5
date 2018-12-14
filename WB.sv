import definitions::*;
module WB(
	input  WB_ctrl   ctrl,
	input  WB_input  in,
	input  Align_out align_out,
	output WB_output out
);

	assign out.val     = ( ctrl.mem_to_reg ) ? in.mem : in.alu;
	assign out.dst     = in.dst;
	assign out.fpu_dst = align_out.dst;
	assign out.fpu_val = ( ctrl.mem_to_reg ) ? in.mem : align_out.val;
endmodule
