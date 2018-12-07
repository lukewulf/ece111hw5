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

  output ProgramCounter pc_jmp,
  output XM_ctrl xm_ctrl,
  output X_input x_data
);

always_ff @(posedge clk) begin

  pc_jmp <= data_i.pc_jmp;

	if(stall != DISABLE) begin
		// Control signals
		xm <= ctrl.xm;

    x_data.ctrl <= ctrl.x;
    x_data.op   <= data_i.alu_op;
    x_data.pc   <= data_i.pc;

		x_data.rs_a <= data_i.rs_a;
		x_data.rs_d <= (fwdX_rs) ? X_d : (fwdM_rs) ? M_d : data_i.rs_d;
		x_data.rt_a <= data_i.rt_a;
		x_data.rt_d <= (fwdX_rt) ? X_d : (fwdM_rt) ? M_d : data_i.rt_d;
		
		x_data.rd_a <= data_i.rd_a;

		x_data.imm  <= data_i.imm;
	end 
	else begin
    xm.mw.reg_write <= DISABLE;
    xm.m.write_mem  <= DISABLE;
    x_data.rd_a     <= RegAddr'(0);
	end
end

endmodule
