import definitions::*;
module XMForwarding(
  input Signal fwdM_rt,
  input Register M_d,

  input  XM_data   xm_data,
  input  Signal   read_mem,
  input  Signal   write_mem,
  input  Signal   fpu_to_mem,
  input  Signal   fpu_to_wb,
  output M_input  m_in
);

assign m_in.read  = read_mem;
assign m_in.write = write_mem;

assign m_in.addr = (fpu_to_wb) ? xm_data.fpu_addr : xm_data.alu_addr;
//assign m_in.data.val  = (fwdM_rt) ? M_d : m_data.val;		// not forwarding into memory
assign m_in.val = (fpu_to_mem) ? xm_data.fpu_val : xm_data.alu_val;
assign m_in.dst  = xm_data.dst;


endmodule
