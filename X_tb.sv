import definitions::*;

module X_tb();

// input
logic [1:0] alu_op;
logic reg_dst;
logic alu_src;
logic [31:0] pc;
logic [31:0] immediate;
logic [31:0] rs_val;
logic [31:0] rt_val;
logic [4:0] rt_addr;
logic [4:0] rd_addr;

// output
logic zero;
logic [31:0] pc_branch;
logic [31:0] alu_out;
logic [31:0] rt_val_out;
logic [4:0] reg_dst_addr;

X uut(.op(alu_op),
	.reg_dst(reg_dst),
	.aluSrc(alu_src),
	.pc(pc),
	.immediate(immediate),
	.rs_val(rs_val),
	.rt_val(rt_val),
	.rt_addr(rt_addr),
	.rd_addr(rd_addr),
	.zero(zero),
	.pc_branch(pc_branch),
	.alu_out(alu_out),
	.rt_val_out(rt_val_out),
	.reg_dst_addr(reg_dst_addr));

initial begin
	// R-Type add, 4 + 4 expect 8
	alu_op = 2'b00;
	reg_dst = 1'b1;
	alu_src = 1'b0;
	pc = 999;
	immediate = 32'h0000_0020;
	rs_val = 4;
	rt_val = 4;
	rt_addr = 5'b1_1111;
	rd_addr = 5'b0_0000;

	#100ns;

	// R-Type sub, 4 - 4 expect 0
	alu_op = 2'b00;
	reg_dst = 1'b1;
	alu_src = 1'b0;
	pc = 999;
	immediate = 32'hFF00_0022;
	rs_val = 4;
	rt_val = 4;
	rt_addr = 5'b1_1111;
	rd_addr = 5'b0_0000;

	#100ns;

	// R-Type and, 32'hFFFF_FFFF AND 32'hf0f0_f0f0
	alu_op = 2'b00;
	reg_dst = 1'b1;
	alu_src = 1'b0;
	pc = 999;
	immediate = 32'hFF00_0024;
	rs_val = 32'hFFFF_FFFF;
	rt_val = 32'hF0F0_F0F0;
	rt_addr = 5'b1_1111;
	rd_addr = 5'b0_0000;

	#100ns;
	
	// R-Type or, 32'hf0f0_f0f0 OR 32'h0f0f_0f0f
	alu_op = 2'b00;
	reg_dst = 1'b1;
	alu_src = 1'b0;
	pc = 999;
	immediate = 32'hFF00_0025;
	rs_val = 32'hf0f0_f0f0;
	rt_val = 32'h0f0f_0f0f;
	rt_addr = 5'b1_1111;
	rd_addr = 5'b0_0000;

	#100ns;

	// I-Type ADDI 15 + 17 = 32
	alu_op = 2'b01;
	reg_dst = 1'b0;
	alu_src = 1'b1;
	pc = 999;
	immediate = 15;
	rs_val = 17;
	rt_val = 199;
	rt_addr = 5'b1_1111;
	rd_addr = 5'b0_0000;

	#100ns;
	
	// I-Type BNE
	alu_op = 2'b10;
	reg_dst = 1'b0;
	alu_src = 1'b0;
	pc = 1000;
	immediate = 1;
	rs_val = 15;
	rt_val = 15;
	rt_addr = 5'b1_1111;
	rd_addr = 5'b0_0000;

	#100ns;
end

endmodule