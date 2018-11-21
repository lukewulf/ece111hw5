
import definitions::*;

module top(
  input clk,  
        rst,
  output y
);

Signal reset;
assign reset = Signal'(rst);


// IF Wires
Signal stall; assign stall = DISABLE;

wire branch;
wire alu_zero;
wire jmp;
ProgramCounter _pc_branch, pc_jmp;

ProgramCounter pc;

IF fetch(
 	.clk(clk),
 	.reset(reset),
	.stall(stall),
	.branch(branch),
	.alu_zero(alu_zero),
	.jmp(jmp),
	.pc_branch(_pc_branch),
	.pc_jmp(pc_jmp),
	.pc(pc)
);
// InstROM Wires
Instruction instr;
RType instr_r; assign instr_r = RType'(instr);
JType instr_j; assign instr_j = JType'(instr);

assign pc_jmp = instr_j.addr[7:0];

InstROM i_mem(
	.addr(pc),
	.instr(instr)
);


// Control Signals
wire [5:0] opcode = instr_r.opcode;
wire [1:0] x_op;
wire reg_dst;
wire alu_src;
Signal reg_write;
Signal mem_read;
Signal mem_write;
wire mem_to_reg;


Controller control(
	.opCode(opcode),
	.ALUop(x_op),
	.aluSrc(alu_src),
	.reg_write(reg_write),
	.read_mem(mem_read),
	.write_mem(mem_write),
	.memToReg(mem_to_reg),
	.jmp(jmp),
	.branch(branch),
	.reg_dst(reg_dst)
);

// D Wires

Register reg_in, rs_out, rt_out;

D decode(
	.clk(clk),
	.reset(reset),
	.write(reg_write),
	.rd_i(reg_in),
	.instr(instr),
	.rs_o(rs_out),
	.rt_o(rt_out)
);

// X Wires


wire [31:0] _pc;
assign _pc = {24'b0, pc};

wire [31:0] immediate;
wire [31:0] rs_val; assign rs_val = rs_out;
wire [31:0] rt_val; assign rt_val = rt_out;

wire [4:0] rt_addr; assign rt_addr = instr_r.rt;
wire [4:0] rd_addr; assign rd_addr = instr_r.rd;

wire [31:0] pc_branch;
assign _pc_branch = pc_branch[7:0];

wire [31:0] alu_out;
wire [31:0] rt_val_out;

wire [4:0] reg_dst_addr;

X execute(
	.op(x_op),
	.reg_dst(reg_dst),
	.aluSrc(alu_src),
	.pc(_pc),
	.immediate(immediate),
	.rs_val(rs_val),
	.rt_val(rt_val),
	.rt_addr(rt_addr),
	.rd_addr(rd_addr),
	.zero(alu_zero),
	.pc_branch(pc_branch),
	.alu_out(alu_out),
	.rt_val_out(rt_val_out),
	.reg_dst_addr(reg_dst_addr)
);


// M Wires
Register mem_addr;
assign mem_addr = Register'(alu_out);



Register mem_in;
assign mem_in = Register'(rt_val_out);

Register mem_out;

M memory(
	.clk(clk),
	.reset(reset),
	.addr(mem_addr),
	.read(mem_read),
	.write(mem_write),
	.mem_in(mem_in),
	.mem_out(mem_out)
);

// WB Wires
wire [31:0] mem_data;
assign mem_data = mem_out;

wire [31:0] alu_data;
assign alu_data = alu_out;



wire [31:0] wb_data;

WB writeback(
	.mem_data(mem_data),
	.alu_data(alu_data),
	.memToReg(mem_to_reg),
	.wb_data(wb_data)
);

assign y = ^mem_data;
endmodule
