import definitions::*;

module X( input [1:0] op,
	  input reg_dst,
	  input aluSrc,
	  input [31:0] pc,
	  input [31:0] immediate,
	  input [31:0] rs_val,
	  input [31:0] rt_val,
	  input [4:0] rt_addr,
	  input [4:0] rd_addr,
	  output zero,
	  output [31:0] pc_branch,
	  output [31:0] alu_out,
	  output [31:0] rt_val_out,
	  output [4:0] reg_dst_addr);

assign pc_branch = pc + immediate;
assign reg_dst_addr = reg_dst ? rd_addr : rt_addr;
assign rt_val_out = rt_val;

op_code alu_controller_out;

wire [31:0] alu_b = aluSrc ? immediate : rt_val;


ALU_Controller alu_c(.func(immediate[5:0]), 
		     .op(op),
		     .alu_op(alu_controller_out));

alu alu_x(.rs_i(rs_val),
	  .rt_i(alu_b),
	  .op_i(alu_controller_out),
	  .result_o(alu_out),
	  .zero(zero));

endmodule

