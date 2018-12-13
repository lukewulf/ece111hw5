import definitions::*;
module XMForwarding(
  input Signal fwdM_rt,
  input Register M_d,

  input  XM_data   xm_data,
  input  Signal   read_mem,
  input  Signal   write_mem,
  input  Signal   fpu_to_mem,

  output M_input  m_in
);

assign m_in.read  = read_mem;
assign m_in.write = write_mem;

assign m_in.addr = xm_data.addr;
//assign m_in.data.val  = (fwdM_rt) ? M_d : m_data.val;		// not forwarding into memory
assign m_in.val = (fpu_to_mem) ? xm_data.fpu_val : xm_data.alu_val;


endmodule
