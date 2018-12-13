import definitions::*;

module Hazard(
	input  Hazard_input  h_i,
	output Hazard_output h_o
);

assign h_o.fwdXX_rs = (h_i.Xrd == 5'b0) ? DISABLE : (h_i.Xrd == h_i.Drs) ? ENABLE : DISABLE;
assign h_o.fwdXX_rt = (h_i.Xrd == 5'b0) ? DISABLE : (h_i.Xrd == h_i.Drt) ? ENABLE : DISABLE;
assign h_o.fwdMX_rs = (h_i.Mrd == 5'b0) ? DISABLE : (h_i.Mrd == h_i.Drs) ? ENABLE : DISABLE;
assign h_o.fwdMX_rt = (h_i.Mrd == 5'b0) ? DISABLE : (h_i.Mrd == h_i.Drt) ? ENABLE : DISABLE;

assign h_o.fwdMM_rt = DISABLE;
Signal stall_load_use;
assign stall_load_use = (h_i.Xrd == 5'b0) ? DISABLE : (h_i.read_mem == DISABLE) ? DISABLE : (h_i.Xrd == h_i.Drs || h_i.Xrd == h_i.Drt) ? ENABLE : DISABLE;

Signal stall_fpu, stall_fpu_x, stall_fpu_m;
assign stall_fpu_x = (h_i.Xfd == 5'b0) ? DISABLE : (h_i.Xfd == h_i.Dfs | h_i.Xfd == h_i.Dft) ? ENABLE : DISABLE;
assign stall_fpu_m = (h_i.Mfd == 5'b0) ? DISABLE : (h_i.Mfd == h_i.Dfs | h_i.Mfd == h_i.Dft) ? ENABLE : DISABLE;
assign stall_fpu   = Signal'(stall_fpu_x | stall_fpu_m);
assign h_o.stallD  = Signal'(stall_load_use | stall_fpu);

assign h_o.stallIF  = h_o.stallD; 
endmodule