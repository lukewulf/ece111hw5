import definitions::*;

module alu_tb();
  bit clk;
  logic reset = 1;

logic  [7:0]       rs_i ;	
logic  [7:0]       rt_i	;	
op_code      op_i	;	
wire   [7:0]       result_o;
wire               zero;
wire               parity;

alu alu1 (
  .rs_i     (rs_i     )      ,	
  .rt_i	 	(rt_i	  )	  	 ,	
  .op_i	    (op_i	  )      ,	
  .result_o	(result_o )	     ,
  .zero     (zero     )      ,
  .parity	(parity )
);


  always begin
    	#5ns clk = 1;
	#5ns clk = 0;
  end

  initial begin
     	rs_i = 16;
	rt_i = 24;
	op_i = XOR;
    	#100ns reset = 0;

	//Parity One Check
	rs_i = 8'b00110011;
	rt_i = 8'b11001010;
	op_i = AND;

	//Parity Zero Check
	#100ns
	rs_i = 8'b10010100;
	rt_i = 8'b10011000;
	op_i = AND;

	//Add Test
	#100ns
	rs_i = 8'b00000100;
	rt_i = 8'b00001000;
	op_i = ADD;

	#100ns
	rs_i = 8'b00010100;
	rt_i = 8'b00011000;
	op_i = ADD;

	//Sub Non-Zero
	#100ns
	rs_i = 8'b00000100;
	rt_i = 8'b00001000;
	op_i = SUB;

	//Sub Zero
	#100ns
	rs_i = 8'b00011100;
	rt_i = 8'b00011100;
	op_i = SUB;
    
    
  end

initial #5000ns $stop;
endmodule