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
		if(rst) begin
			wb_ctrl <= WB_ctrl'(0);
			wb_data <= WB_input'(0);
		end
		else begin
			wb_ctrl <= ctrl.wb;
			wb_data <= data_i;
		end
	end
	
endmodule

