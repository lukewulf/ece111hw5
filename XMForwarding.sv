import definitions::*;
module XMForwarding(
  input Signal fwdM_rt,
  input Register M_d,

  input  M_data   m_data,
  input  Signal   read_mem,
  input  Signal   write_mem,
  output M_input  m_in
);

assign m_in.read  = read_mem;
assign m_in.write = write_mem;

assign m_in.data.addr = m_data.addr;
//assign m_in.data.val  = (fwdM_rt) ? M_d : m_data.val;		// not forwarding into memory
assign m_in.data.val = m_data.val;
assign m_in.data.dst  = m_data.dst;


endmodule
