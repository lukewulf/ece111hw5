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

  input  DX_control_bundle control_i,
  output DX_control_bundle control_o,

  input  DX_data_bundle data_i,
  output DX_data_bundle data_o
);

always_ff @(posedge clk) begin
	if(stall != DISABLE) begin
		// Control signals
		control_o   <= control_i;

    data_o.pc   <= data_i.pc;

		data_o.rs_a <= data_i.rs_a;
		data_o.rs_d <= (fwdX_rs == ENABLE) ? X_d : (fwdM_rs == ENABLE) ? M_d : data_i.rs_d;
		data_o.rt_a <= data_i.rt_a;
		data_o.rt_d <= (fwdX_rt == ENABLE) ? X_d : (fwdM_rt == ENABLE) ? M_d : data_i.rt_d;
		
		data_o.rd_a <= data_i.rd_a;

		data_o.imm  <= data_i.imm;
	end 
	else begin
    control_o.reg_write <= DISABLE;
    control_o.write_mem <= DISABLE;
    data_o.rd_a         <= RegAddr'(0);
	end
end

endmodule
