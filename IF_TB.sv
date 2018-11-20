module IF_TB();
parameter PCW=8;		//PC Width
logic branch; 	
logic signed [PCW-1:0] branch_adr;
logic Reset;
logic Halt;
logic CLK;
wire[PCW-1:0] PC;     


IF IF1(
  .branch       (branch),      // branch to "offset"
  .branch_adr   (branch_adr  ),
  .Reset        (Reset   ),
  .Halt         (Halt    ),
  .CLK          (CLK     ),
  .PC           (PC      )      // pointer to insr. mem
  );

initial begin
  Halt = 0;
  branch = 0;
  branch_adr = 8'h40;
  #10ns Reset = 1;
  #10ns Reset = 0;
  #100ns branch = 1;
  #10ns branch = 0;
  branch_adr = 8'h00;
  #100ns
  #10ns branch = 1;
  #50ns
  #20ns $stop;
end

always begin
  CLK = 0;
  #5ns CLK = 1;
  #5ns;
end


endmodule