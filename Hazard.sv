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
assign h_o.stallD   = (h_i.Xrd == 5'b0) ? DISABLE : (h_i.read_mem == DISABLE) ? DISABLE : (h_i.Xrd == h_i.Drs || h_i.Xrd == h_i.Drt) ? ENABLE : DISABLE;

assign h_o.stallIF  = h_o.stallD; 
endmodule