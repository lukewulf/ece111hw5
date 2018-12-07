import definitions::*;

module MW(
	input wire      clk,
	input wire      rst,

	input MW_ctrl   ctrl,
	input WB_input  data_i,

	output WB_ctrl  wb_ctrl,
	output WB_input wb_data
);

	always_ff @(posedge clk) begin
		wb_ctrl <= ctrl.wb;
		wb_data <= data_i;
	end
	
endmodule

