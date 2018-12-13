import definitions::*;
module WB(
	input  WB_ctrl   ctrl,
	input  WB_input  in,
	output WB_output out
);

	assign out.val = ctrl.mem_to_reg ? in.mem : ctrl.fpu_write ? in.fpu : in.alu;
	assign out.dst = in.dst;
	assign out.fpu_dst = in.fpu_dst;
endmodule
