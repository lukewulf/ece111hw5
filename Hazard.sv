import definitions::*;

module Hazard(
	input  Hazard_input  h_i,
	output Hazard_output h_o
);

assign h_o.fwdXX_rs = (h_i.Drs == 5'bZZZZZ) ? DISABLE : (h_i.Xrd == h_i.Drs) ? ENABLE : DISABLE;
assign h_o.fwdXX_rt = (h_i.Drt == 5'bZZZZZ) ? DISABLE : (h_i.Xrd == h_i.Drt) ? ENABLE : DISABLE;
assign h_o.fwdMX_rs = (h_i.Drs == 5'bZZZZZ) ? DISABLE : (h_i.Mrd == h_i.Drs) ? ENABLE : DISABLE;
assign h_o.fwdMX_rt = (h_i.Drt == 5'bZZZZZ) ? DISABLE : (h_i.Mrd == h_i.Drt) ? ENABLE : DISABLE;
assign h_o.fwdMM_rt = (h_i.Xrt == 5'bZZZZZ) ? DISABLE : (h_i.Mrd == h_i.Xrt) ? ENABLE : DISABLE;
// assign h_o.stallD   = (h_i.Mrd == 5'bZZZZZ) ? DISABLE : (h_i.Mrd == h_i.Drs || h_i.Mrd == h_i.Drt) ? ENABLE : DISABLE;
assign h_o.stallD   = DISABLE;
assign h_o.stallIF  = h_o.stallD; 
endmodule