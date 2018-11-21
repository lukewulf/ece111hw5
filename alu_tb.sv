import definitions::*;

module alu_tb();
  bit clk;
  logic reset = 1;

logic  [31:0]       rs_i ;	
logic  [31:0]       rt_i	;	
op_code      op_i	;	
wire   [31:0]       result_o;
wire               zero;

alu alu1 (
  .rs_i     (rs_i),	
  .rt_i	 	(rt_i	  )	  	 ,	
  .op_i	    (op_i	  )      ,	
  .result_o	(result_o )	     ,
  .zero     (zero     )
);


  always begin
    	#5ns clk = 1;
	#5ns clk = 0;
  end

  initial begin
     	rs_i = 4;
	rt_i = 2;
	op_i = ADD;
    	#100ns reset = 0;
    	
	rs_i = 8;
	rt_i = 4;
	op_i = ADD;

	#100ns;
	rs_i = 8;
	rt_i = 4;
	op_i = SUB;

	#100ns;
	rs_i = 32'hFFFF_0000;
	rt_i = 32'h0000_FFFF;
	op_i = OR;

	#100ns;
	rs_i = 32'hFFFF_0000;
	rt_i = 32'h0000_FFFF;
	op_i = AND;

	#100ns;
	rs_i = 4;
	rt_i = 8;
	op_i = SUB;

	#100ns;
	rs_i = 10;
	rt_i = 10;
	op_i = SUB;
  end

initial #5000ns $stop;
endmodule