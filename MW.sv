import definitions::*;

module MW(
	input wire      clk,
	input wire      rst,

	input MW_ctrl   ctrl,
	input WB_input  data_i,

        input Align_in op_out,

	output WB_ctrl  wb_ctrl,
	output WB_input wb_data,

	output Align_in align_in
);

	always_ff @(posedge clk) begin
		if(rst) begin
			wb_ctrl <= WB_ctrl'(0);
			wb_data <= WB_input'(0);
			align_in <= Align_in'(0);
		end
		else begin
			wb_ctrl <= ctrl.wb;
			wb_data <= data_i;
			align_in <= op_out;
		end
	end
	
endmodule

