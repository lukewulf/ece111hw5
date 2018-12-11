import definitions::*;
module DXForwarding(
  // Control signals from hazard detection unit
  input  Signal stall,
  input  Signal fwdX_rs,
  input  Signal fwdX_rt,
  input  Signal fwdM_rs,
  input  Signal fwdM_rt,

  // Forwarded Data
  input  Register M_d,
  input  Register X_d,

  input  X_input dx_out,
  input  XM_ctrl dx_xm_ctrl,

  output X_input x_in,
  output XM_ctrl xm_ctrl
);

X_input _x_in;
assign x_in = (stall) ? X_input'(0) : _x_in;
assign xm_ctrl = (stall) ? XM_ctrl'(0) : dx_xm_ctrl;

assign _x_in.ctrl    = dx_out.ctrl;
assign _x_in.pc      = dx_out.pc;
assign _x_in.rs      = (fwdX_rs) ? X_d : (fwdM_rs) ? M_d : dx_out.rs;
assign _x_in.rt      = (fwdX_rt) ? X_d : (fwdM_rt) ? M_d : dx_out.rt;
assign _x_in.rs_addr = dx_out.rs_addr;
assign _x_in.rt_addr = dx_out.rt_addr;
assign _x_in.rd_addr = dx_out.rd_addr;
assign _x_in.imm     = dx_out.imm;

endmodule
