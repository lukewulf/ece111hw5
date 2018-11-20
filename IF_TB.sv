import definitions::*;

module IF_TB;

logic clk;
Signal pc_src; 	
ProgramCounter pc_ext;
Signal reset;
Signal stall;

ProgramCounter pc;

Instruction instr;


IF IF1(
  .clk(clk),
  .reset(reset),
  .stall(stall),
  .pc_src(pc_src),
  .pc_ext(pc_ext),

  .pc(pc)
);

InstROM#(4) i_mem(
  .addr(pc),
  .instr(instr)
);

initial begin
  reset  = ENABLE;
  stall  = DISABLE;
  pc_src = DISABLE;
  pc_ext = 8'hAA;

  #10; reset  = DISABLE;
  #20; reset  = ENABLE;
  #10; reset  = DISABLE;
  #20; stall  = ENABLE;
  #20; stall  = DISABLE;
  #10; pc_src = ENABLE;
  #20;
end

always begin
  clk = 0;
  #5ns;
  clk = 1;
  #5ns;
end


endmodule