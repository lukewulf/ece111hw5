
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
DX_ctrl dx_ctrl;

DX_data dx_in;
DX_data dx_out;

// Execute Wires
X_input  x_in;
X_output x_out;
X_ctrl   x_ctrl;

XM_ctrl xm_ctrl;

// Data Memory Wires
M_input  m_in;
M_output m_out;
M_ctrl m_ctrl;

MW_ctrl mw_ctrl;

// Writeback Wires
WB_input  wb_in;
WB_output wb_out;
WB_ctrl   wb_ctrl;

// Control Wiring
assign if_in.stall    = stall;
assign if_in.branch   = m_ctrl.branch;
assign if_in.jmp      = m_ctrl.jmp;

assign d_ctrl.write = wb_ctrl.reg_write;

assign x_in.reg_dst = x_ctrl.reg_dst;
assign x_in.alu_src = x_ctrl.alu_src;

assign m_in.read  = m_ctrl.mem_read;
assign m_in.write = m_ctrl.write_mem;

assign wb_in.src = wb_ctrl.mem_to_reg;

// Interstage Wiring
assign if_in.alu_zero  = x_out.zero;
assign if_in.pc_branch = x_out.pc_branch;
assign if_in.pc_jmp    = pc_jmp;

assign d_in.rd    = wb_out.val;
assign d_in.instr = instr;

assign x_in.op      = x_ctrl.alu_op;
assign x_in.pc      = dx_out.pc;
assign x_in.imm     = dx_out.imm;
assign x_in.rs      = dx_out.rs_d;
assign x_in.rt      = dx_out.rt_d;
assign x_in.rt_addr = dx_out.rt_a;
assign x_in.rd_addr = dx_out.rd_a;

assign m_in.addr = x_out.alu;
assign m_in.val  = x_out.rt;

assign wb_in.mem = m_out.val;
assign wb_in.alu = x_out.alu;

// Stage Buffer Wiring

// struct DX_data {
//     dx_in.pc <- fetch_decode_buffer
assign dx_in.rs_a = RegAddr'(0);
assign dx_in.rs_d = d_out.rs;
assign dx_in.rt_a = RegAddr'(0);
assign dx_in.rt_d = d_out.rt;
assign dx_in.imm  = {{16{instr_i.imm[15]}}, instr_i.imm};
//}

assign y = m_out.val;

IF fetch(
	.clk(clk),
	.reset(reset),
	.in(if_in),
	.out(if_out)
);

FD fetch_decode_buffer(
	.clk(clk),
	.rst(rst),
	.stall(),

	.next_pc_i(if_out.pc),
	.instr_i(instr),

	.next_pc_o(dx_in.pc),
	.instr_o(d_in.instr),
);

D decode(
	.clk(clk),
	.reset(reset),
	.ctrl(d_ctrl),
	.in(d_in),
	.out(d_out)
);

DX decode_execute_buffer(
	.clk(clk),
	.rst(rst),

	.fwdX_rs(),
	.fwdX_rt(),
	.fwdM_rs(),
	.fwdM_rt(),
	.stall(),

	.M_d(m_out.val),
	.X_d(x_out.alu),

	.ctrl(dx_ctrl),
	.data_i(dx_in),

	.xm(xm_ctrl),
	.x(x_ctrl),
	.data_o(dx_out)
);

X execute(
	.in(x_in),
	.out(x_out)
);

XM execute_mem_buffer(
	.clk(clk),
	.rst(rst),

	.fwdM_rt

)

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
	.signals(dx_ctrl)
	// .ALUop(x_op),
	// .aluSrc(alu_src),
	// .reg_write(_reg_write),
	// .read_mem(_mem_read),
	// .write_mem(_mem_write),
	// .memToReg(mem_to_reg),
	// .jmp(jmp),
	// .branch(branch),
	// .reg_dst(reg_dst)
);

endmodule
