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

Signal stall_fpu, stall_fpu_cmp, stall_fpu_op, stall_fpu_align;
assign stall_fpu_cmp   = (h_i.Cfd == 5'b0) ? DISABLE : (h_i.Cfd == h_i.Dfs | h_i.Cfd == h_i.Dft) ? ENABLE : DISABLE;
//assign stall_fpu_cmp   = DISABLE;
assign stall_fpu_op    = (h_i.Ofd == 5'b0) ? DISABLE : (h_i.Ofd == h_i.Dfs | h_i.Ofd == h_i.Dft) ? ENABLE : DISABLE;
assign stall_fpu_align = (h_i.Afd == 5'b0) ? DISABLE : (h_i.Afd == h_i.Dfs | h_i.Afd == h_i.Dft) ? ENABLE : DISABLE;

assign stall_fpu   = Signal'( stall_fpu_cmp | stall_fpu_op | stall_fpu_align );
assign h_o.stallD  = Signal'( stall_load_use | stall_fpu );

assign h_o.stallIF  = h_o.stallD; 
endmodule