import definitions::*;

module DX(
  input  wire clk,
  input  wire rst,
 
  // Control signals from hazard detection unit
  input  Signal fwdX_rs,
  input  Signal fwdX_rt,
  input  Signal fwdM_rs,
  input  Signal fwdM_rt,
  input  Signal stall,

  // Forwarded Data
  input  Register M_d,
  input  Register X_d,

  input  DX_ctrl ctrl,
  input  DX_data data_i,

  output XM_ctrl xm,
  output X_ctrl  x,
  output DX_data data_o
);

always_ff @(posedge clk) begin
	if(stall != DISABLE) begin
		// Control signals
		xm <= ctrl.xm;
    x  <= ctrl.x;

    data_o.pc   <= data_i.pc;

		data_o.rs_a <= data_i.rs_a;
		data_o.rs_d <= (fwdX_rs) ? X_d : (fwdM_rs) ? M_d : data_i.rs_d;
		data_o.rt_a <= data_i.rt_a;
		data_o.rt_d <= (fwdX_rt) ? X_d : (fwdM_rt) ? M_d : data_i.rt_d;
		
		data_o.rd_a <= data_i.rd_a;

		data_o.imm  <= data_i.imm;
	end 
	else begin
    xm.mw.reg_write <= DISABLE;
    xm.m.write_mem  <= DISABLE;
    data_o.rd_a     <= RegAddr'(0);
	end
end

endmodule
