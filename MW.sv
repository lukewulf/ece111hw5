import definitions::*;

module MW(
	input wire      clk,
	input wire      rst,

	input Signal    reg_write,
	input wire      memToReg,
	input Register  mem_out,
	input Register  alu_out,
	input RegAddr   rd_a,

	output Signal   reg_write_o,
	
	output reg      memToReg_o,
	output Register mem_out_o,
	output Register alu_out_o,
	output RegAddr  rd_a_o
);

	always_ff @(posedge clk) begin
		reg_write_o <= reg_write;
		memToReg_o  <= memToReg;
		mem_out_o   <= mem_out;
		alu_out_o   <= alu_out;
		rd_a_o      <= rd_a;
	end
	
endmodule

