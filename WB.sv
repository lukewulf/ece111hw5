module WB(	input [31:0] mem_data,
	  	input [31:0] alu_data,
		input memToReg,
		output [31:0] wb_data);

	assign wb_data = memToReg ? mem_data : alu_data;
endmodule
