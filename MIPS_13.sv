
import definitions::*;

module MIPS_13(
  input clk,  
        rst,
  output y
);

Signal reset;
assign reset = Signal'(rst);

// Control Wires
Signal stall;
wire [5:0] opcode = instr_r.opcode;
wire [1:0] x_op;
wire reg_dst;
wire alu_src;

Signal reg_write;
wire _reg_write;
assign reg_write = Signal'(_reg_write);

Signal mem_read;
wire _mem_read;
assign mem_read = Signal'(_mem_read);

Signal mem_write;
wire _mem_write;
assign mem_write = Signal'(_mem_write);

wire mem_to_reg;

wire branch;
wire alu_zero;
wire jmp;
ProgramCounter _pc_branch, pc_jmp;

ProgramCounter pc;

Instruction instr;
RType instr_r; assign instr_r = RType'(instr);
JType instr_j; assign instr_j = JType'(instr);
IType instr_i; assign instr_i = IType'(instr);

assign pc_jmp = instr_j.addr[7:0];

// Instruction Fetch Wires
IF_input  if_in;
IF_output if_out;

// Instruction Decode Wires
D_control d_ctrl;
D_input   d_in;
D_output  d_out;

// Execute Wires
X_input  x_in;
X_output x_out;

// Data Memory Wires
M_input  m_in;
M_output m_out;

// Writeback Wires
WB_input  wb_in;
WB_output wb_out;

// Control Wiring
assign if_in.stall    = stall;
assign if_in.branch   = Signal'(branch);
assign if_in.jmp      = Signal'(jmp);

assign d_ctrl.write = reg_write;

assign x_in.reg_dst = reg_dst;
assign x_in.alu_src = alu_src;

assign m_in.read  = mem_read;
assign m_in.write = mem_write;

assign wb_in.src = Signal'(mem_to_reg);

// Interstage Wiring
assign if_in.alu_zero  = x_out.zero;
assign if_in.pc_branch = x_out.pc_branch;
assign if_in.pc_jmp    = pc_jmp;

assign d_in.rd    = wb_out.val;
assign d_in.instr = instr;

assign x_in.op      = op_code'(x_op);
assign x_in.pc      = if_out.pc;
assign x_in.imm     = {{16{instr_i.imm[15]}}, instr_i.imm};
assign x_in.rs      = d_out.rs;
assign x_in.rt      = d_out.rt;
assign x_in.rt_addr = instr_r.rt;
assign x_in.rd_addr = instr_r.rd;

assign m_in.addr = x_out.alu;
assign m_in.val  = x_out.rt;

assign wb_in.mem = m_out.val;
assign wb_in.alu = x_out.alu;

assign y = m_out.val;

IF fetch(
	.clk(clk),
	.reset(reset),
	.in(if_in),
	.out(if_out)
);

D decode(
	.clk(clk),
	.reset(reset),
	.ctrl(d_ctrl),
	.in(d_in),
	.out(d_out)
);

X execute(
	.in(x_in),
	.out(x_out)
);

M mem(
	.clk(clk),
	.in(m_in),
	.out(m_out)
);

WB writeback(
	.in(wb_in),
	.out(wb_out)
);

InstROM i_mem(
	.addr(if_out.pc),
	.instr(instr)
);

Controller control(
	.opCode(opcode),
	.ALUop(x_op),
	.aluSrc(alu_src),
	.reg_write(_reg_write),
	.read_mem(_mem_read),
	.write_mem(_mem_write),
	.memToReg(mem_to_reg),
	.jmp(jmp),
	.branch(branch),
	.reg_dst(reg_dst)
);




// IF fetch(
//  	.clk(clk),
//  	.reset(reset),
// 	.stall(stall),
// 	.branch(branch),
// 	.alu_zero(alu_zero),
// 	.jmp(jmp),
// 	.pc_branch(_pc_branch),
// 	.pc_jmp(pc_jmp),
// 	.pc(pc)
// );
// // InstROM Wires

// InstROM i_mem(
// 	.addr(pc),
// 	.instr(instr)
// );


// Controller control(
// 	.opCode(opcode),
// 	.ALUop(x_op),
// 	.aluSrc(alu_src),
// 	.reg_write(_reg_write),
// 	.read_mem(_mem_read),
// 	.write_mem(_mem_write),
// 	.memToReg(mem_to_reg),
// 	.jmp(jmp),
// 	.branch(branch),
// 	.reg_dst(reg_dst)
// );

// // D Wires

// Register reg_in, rs_out, rt_out;

// D decode(
// 	.clk(clk),
// 	.reset(reset),

// 	.ctrl(d_control),
// 	.in(d_input),
// 	.out(d_output)
// );

// // X Wires


// wire [31:0] _pc;
// assign _pc = {24'b0, pc};

// wire [31:0] immediate;
// assign immediate = {{16{instr_i.imm[15]}}, instr_i.imm};

// wire [31:0] rs_val; assign rs_val = rs_out;
// wire [31:0] rt_val; assign rt_val = rt_out;

// wire [4:0] rt_addr; assign rt_addr = instr_r.rt;
// wire [4:0] rd_addr; assign rd_addr = instr_r.rd;

// wire [31:0] pc_branch;
// assign _pc_branch = pc_branch[7:0];

// wire [31:0] alu_out;
// wire [31:0] rt_val_out;

// wire [4:0] reg_dst_addr;

// X execute(
// 	.op(x_op),
// 	.reg_dst(reg_dst),
// 	.aluSrc(alu_src),
// 	.pc(_pc),
// 	.immediate(immediate),
// 	.rs_val(rs_val),
// 	.rt_val(rt_val),
// 	.rt_addr(rt_addr),
// 	.rd_addr(rd_addr),
// 	.zero(alu_zero),
// 	.pc_branch(pc_branch),
// 	.alu_out(alu_out),
// 	.rt_val_out(rt_val_out),
// 	.reg_dst_addr(reg_dst_addr)
// );


// // M Wires
// Register mem_addr;
// assign mem_addr = Register'(alu_out);

// Register mem_in;
// assign mem_in = Register'(rt_val_out);

// Register mem_out;

// M memory(
// 	.clk(clk),
// 	.addr(mem_addr),
// 	.read(mem_read),
// 	.write(mem_write),
// 	.mem_in(mem_in),
// 	.mem_out(mem_out)
// );

// // WB Wires
// wire [31:0] mem_data;
// assign mem_data = mem_out;

// wire [31:0] alu_data;
// assign alu_data = alu_out;

// wire [31:0] wb_data;
// assign reg_in = Register'(wb_data);

// WB writeback(
// 	.mem_data(mem_data),
// 	.alu_data(alu_data),
// 	.memToReg(mem_to_reg),
// 	.wb_data(wb_data)
// );

// assign y = ^mem_data;
endmodule
