import definitions::*;

module Hazard(	input RegAddr Drs,
		input RegAddr Drt,
		input RegAddr Drd,
		input RegAddr Xrs,
		input RegAddr Xrt,
		input RegAddr Xrd,
		input RegAddr Mrs,
		input RegAddr Mrt,
		input RegAddr Mrd,
		input RegAddr WBrs,
		input RegAddr WBrt,
		input RegAddr WBrd,
		output Signal fwdXX_rs,
		output Signal fwdXX_rt,
		output Signal fwdMX_rs,
		output Signal fwdMX_rt,
		output Signal fwdMM_rt,
		output Signal stallD,
		output Signal stallIF);

assign fwdXX_rs = (Drs == 5'b00000) ? DISABLE : (Xrd == Drs) ? ENABLE : DISABLE;
assign fwdXX_rt = (Drt == 5'b00000) ? DISABLE : (Xrd == Drt) ? ENABLE : DISABLE;
assign fwdMX_rs = (Drs == 5'b00000) ? DISABLE : (Mrd == Drs) ? ENABLE : DISABLE;
assign fwdMX_rt = (Drt == 5'b00000) ? DISABLE : (Mrd == Drt) ? ENABLE : DISABLE;
assign fwdMM_rt = (Xrt == 5'b00000) ? DISABLE : (Mrd == Xrt) ? ENABLE : DISABLE;
assign stallD = (Mrd == 5'b00000) ? DISABLE : (Mrd == Drs || Mrd == Drt) ? ENABLE : DISABLE;
assign stallF = stallD; 
endmodule