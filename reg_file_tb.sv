module reg_file_tb;

   parameter NUM_REGS = 8,      // Number of registers.
             NUM_REGS_LOG = ($clog2(NUM_REGS)) - 1,  // Log_base_2 (number_of_registers).
             DATA_WIDTH = 8;   // The width of each register.

   logic                    clk;
   logic                    wen_i = 0;
   logic		    level = 0;
   logic [NUM_REGS_LOG-1:0] rs_addr_i = 0;
   logic [NUM_REGS_LOG-1:0] rt_addr_i = 0;
   logic [DATA_WIDTH-1:0]   write_data_i  = 0;

   wire [DATA_WIDTH-1:0]  rs_val_o;
   wire [DATA_WIDTH-1:0]  rt_val_o;

// instantiate reg file, overriding parameters if/as needed/desired
   reg_file reg_file(.clk(clk),
	 	.rs_addr_i(rs_addr_i),
		.rt_addr_i(rt_addr_i),
		.level(level),
		.wen_i(wen_i),
		.write_data_i(write_data_i),
		.rs_val_o(rs_val_o),
		.rt_val_o(rt_val_o)
	);

   always begin
     clk = 0;
	 #5ns clk = 1;
	 #5ns;
   end

   initial begin
	#200ns  wen_i = 1;	  // write for 20 clock periods
	write_data_i = 8'h00;
	rt_addr_i = 2'b01;
	level = 1'b0;		  // initialize all registers to 0
	#10ns 
	rs_addr_i = 2'b00;
	#10ns 
	rs_addr_i = 2'b01;
	#10ns 
	rs_addr_i = 2'b10;
	#10ns 
	rs_addr_i = 2'b11;
	level = 1'b1;
	#10ns
	rs_addr_i = 2'b00;
	#10ns 
	rs_addr_i = 2'b01;
	#10ns 
	rs_addr_i = 2'b10;
	#10ns 
	rs_addr_i = 2'b11;

	#10ns 
	rs_addr_i = 2'b01;	 // write reg(101) to FF
	rt_addr_i = 2'b00;
	write_data_i = 8'hFF;

	#10ns 
	wen_i = 0;
	rs_addr_i = 2'b01;	 // read reg(101) to verify write of FF
	rt_addr_i = 2'b00;
	write_data_i = 8'h00;

	#10ns 
	level = 0;
	wen_i = 0;
	rs_addr_i = 2'b01;	 // read reg(101) to verify write of FF
	rt_addr_i = 2'b00;
	write_data_i = 8'hF0;


   end

endmodule
