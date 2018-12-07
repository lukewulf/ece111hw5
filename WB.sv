import definitions::*;
module WB(
	input  WB_input  in,
	output WB_output out
);

	assign out.val = in.src ? in.mem : in.alu;
endmodule
