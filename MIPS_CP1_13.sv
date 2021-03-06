
import definitions::*;

module MIPS_CP1_13(
  input clk,  
        rst,
  output y
);

Signal reset;
assign reset = Signal'(rst);

// Control Wires
Signal stall;
wire [5:0] opcode = d_in.instr[31:26];
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
FRType instr_fr; assign instr_fr = FRType'(instr);

assign pc_jmp = instr_j.addr[7:0];

// Instruction Fetch Wires
IF_input  if_in;
IF_output if_out;

// Instruction Decode Wires
D_control d_ctrl;
D_input   d_in;
D_output  d_out;
DX_ctrl dx_ctrl;
XM_ctrl dx_xm_ctrl;

DX_data dx_in;
Signal dx_bubble;
X_input dx_out;
ProgramCounter dx_pc_jmp;

Register dx_xm_ft;

// Execute Wires
X_input  x_in;
X_output x_out;
X_ctrl   x_ctrl;

XM_ctrl xm_ctrl;

// Data Memory Wires
M_input  m_in;
M_output m_out;
M_ctrl m_ctrl;
XM_data xm_data;
ProgramCounter xm_pc_jmp;

MW_ctrl  mw_ctrl;
WB_input mw_data;

// Writeback Wires
WB_input  wb_in;
WB_output wb_out;
WB_ctrl   wb_ctrl;

// Hazard Wires
Hazard_input h_i;
Hazard_output h_o;

// FPU stuff
Compare_in cmp_in;
Operate_in cmp_out;
Operate_in op_in;
Align_in   op_out;
Align_in   align_in;
Align_out  align_out;

// Control Wiring
assign if_in.stall    = h_o.stallIF;
assign if_in.branch   = m_ctrl.branch;
assign if_in.jmp      = m_ctrl.jmp;

assign d_ctrl.write = wb_ctrl.reg_write;
assign d_ctrl.fp_write = wb_ctrl.fpu_write;

// assign x_in.reg_dst = x_ctrl.reg_dst;
// assign x_in.alu_src = x_ctrl.alu_src;

// assign m_in.read  = m_ctrl.read_mem;
// assign m_in.write = m_ctrl.write_mem;

// assign wb_in.src = wb_ctrl.mem_to_reg;

// Interstage Wiring
assign if_in.alu_zero  = xm_data.alu_zero;
assign if_in.pc_branch = xm_data.pc_branch;
assign if_in.pc_jmp    = xm_pc_jmp;

assign d_in.rd       = wb_out.val;
assign d_in.dst      = wb_out.dst;
assign d_in.fd       = wb_out.fpu_val;
assign d_in.fpu_dst  = wb_out.fpu_dst;

// assign m_in.data = m_data;

assign mw_data.mem = m_out.val;
assign mw_data.alu = xm_data.addr;
assign mw_data.fpu = xm_data.fpu_val;
assign mw_data.dst = xm_data.dst;
assign mw_data.fpu_dst = xm_data.fpu_dst;

// Stage Buffer Wiring

assign dx_bubble = (if_in.jmp | (if_in.branch & if_in.alu_zero)) ? ENABLE : DISABLE;
// assign dx_bubble = DISABLE;

// struct DX_data {
//     dx_in.pc     <- fetch_decode_buffer
assign dx_in.rs_a   = d_out.rs_a;
assign dx_in.rs_d   = d_out.rs;
assign dx_in.rt_a   = d_out.rt_a;
assign dx_in.rt_d   = d_out.rt;
assign dx_in.rd_a   = d_out.rd_a;

assign dx_in.fs_d   = d_out.fs;
assign dx_in.fs_a   = d_out.fs_a;
assign dx_in.ft_d   = d_out.ft;
assign dx_in.ft_a   = d_out.ft_a;
assign dx_in.fd_a   = d_out.fd_a;

assign dx_in.imm    = {{16{d_in.instr[15]}}, d_in.instr[15:0]};
assign dx_in.pc_jmp = d_out.pc_jmp;
//}

// struct Hazard_input {
assign h_i.Drs = dx_out.rs_addr;    //   RegAddr Drs
assign h_i.Drt = dx_out.rt_addr;    //   RegAddr Drt

// assign h_i.Xrt = x_in.rt_addr;  //   RegAddr Xrt;
// assign h_i.read_mem = m_ctrl.read_mem;
assign h_i.Xrd = xm_data.dst;  //   RegAddr Xrd;
assign h_i.read_mem = m_ctrl.read_mem;

assign h_i.Mrd = wb_in.dst;    //   RegAddr Mrd;

assign h_i.Dfs = d_out.fs_a;
assign h_i.Dft = d_out.ft_a;

assign h_i.Cfd =   cmp_in.dst;
assign h_i.Ofd =    op_in.dst;
assign h_i.Afd = align_in.dst;
// }

assign y = m_out.val;

IF fetch(
	.clk(clk),
	.reset(reset),
	.in(if_in),
	.out(if_out)
);

InstROM i_mem(
	.addr(if_out.pc),
	.instr(instr)
);

FD fetch_decode_buffer(
	.clk(clk),
	.rst(rst),
	.stall(h_o.stallIF),
	.bubble(dx_bubble),

	.next_pc_i(if_out.pc),
	.instr_i(instr),

	.next_pc_o(dx_in.pc),
	.instr_o(d_in.instr)
);

D decode(
	.clk(clk),
	.reset(reset),
	.ctrl(d_ctrl),
	.in(d_in),
	.out(d_out)
);

Controller control(
	.opCode(opcode),
	.signals(dx_ctrl)
);

DX decode_execute_buffer(
	.clk(clk),
	.rst(rst),

	.stall(h_o.stallD),
	.bubble(dx_bubble),

	.ctrl(dx_ctrl),
	.data_i(dx_in),

	.pc_jmp(dx_pc_jmp),
	.xm_ctrl(dx_xm_ctrl),
	.x_data(dx_out),
    .cmp_in(cmp_in),
	.ft(dx_xm_ft)
);

Register m_d_forward;
assign m_d_forward = (wb_ctrl.mem_to_reg == ENABLE) ? wb_in.mem : wb_in.alu;

Signal dxf_bubble;
assign dxf_bubble = Signal'(dx_bubble | h_o.stallD);

DXForwarding dx_forward(
	.bubble(dxf_bubble),
	.fwdX_rs(h_o.fwdXX_rs),
	.fwdX_rt(h_o.fwdXX_rt),
	.fwdM_rs(h_o.fwdMX_rs),
	.fwdM_rt(h_o.fwdMX_rt),

	.M_d(m_d_forward),
	.X_d(xm_data.addr),

	.dx_out(dx_out),
	.dx_xm_ctrl(dx_xm_ctrl),
	.xm_ctrl(xm_ctrl),
	.x_in(x_in)
);

FP_C fpu_compare(
	.in(cmp_in),
	.out(cmp_out)
);

X execute(
	.in(x_in),
	.out(x_out)
);

XM execute_mem_buffer(
	.clk(clk),
	.rst(rst),
	.bubble(dx_bubble),
	.ctrl(xm_ctrl),
	.x_out(x_out),
	.ft(dx_xm_ft),
	.pc_jmp(dx_pc_jmp),

	.cmp_out(cmp_out),

	.mw_ctrl(mw_ctrl),
	.m_ctrl(m_ctrl),

	.xm_data(xm_data),
	.m_src(h_i.Xrt),
	.pc_jmp_o(xm_pc_jmp),

	.op_in(op_in)
);

XMForwarding xm_forward(
	.fwdM_rt(h_o.fwdMM_rt),
	.M_d(wb_out.val),

	.xm_data(xm_data),
	.read_mem(m_ctrl.read_mem),
	.write_mem(m_ctrl.write_mem),
	.fpu_to_mem(m_ctrl.fpu_to_mem),

	.m_in(m_in)
);

M mem(
	.clk(clk),
	.in(m_in),
	.out(m_out)
);

FP_O fpu_operate(
	.in(op_in),
	.out(op_out)
);

MW mem_writeback_buffer(
	.clk(clk),
	.rst(rst),

	.ctrl(mw_ctrl),
	.data_i(mw_data),
	.op_out(op_out),

	.wb_ctrl(wb_ctrl),
	.wb_data(wb_in),
	.align_in(align_in)
);

FP_A fpu_align(
	.in(align_in),
	.out(align_out)
);

WB writeback(
	.ctrl(wb_ctrl),
	.in(wb_in),
	.align_out(align_out),
	.out(wb_out)
);



Hazard hazard(
	.h_i(h_i),
	.h_o(h_o)
);
endmodule
