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
	  output [31:0] rt_val,
	  output [4:0] reg_dst_addr);


endmodule

