import definitions::*;
module D_TB;

logic clk;
Signal reset;

Register rd_i;
Instruction instr;

Register rs_o, rt_o;

Signal write;

D decode(
  .clk(clk),
  .reset(reset),
  .write(write),

  .rd_i(rd_i),
  .instr(instr),

  .rs_o(rs_o),
  .rt_o(rt_o)
);

initial begin
  reset = ENABLE;
  write = DISABLE;
  rd_i  = Register'(32'hAAAAAAAA);
  instr = { J, 26'b0 };

  #10;
  assert (rs_o == 0) else $error("expected rs_o == %h", 0);
  assert (rt_o == 0) else $error("expected rt_o == %h", 0);
  reset = DISABLE;
  write = ENABLE;
  instr = { RTYPE, 5'h00, 5'h00, 5'h00, 5'h00, ADD };

  #10;
  assert (rs_o == rd_i) else $error("expected rd_i == %h", rd_i);
  assert (rt_o == rd_i) else $error("expected rd_i == %h", rd_i);
  instr = { RTYPE, 5'h05, 5'h07, 5'h03, 5'h00, ADD };

  #10;
  assert (rs_o == 0) else $error("expected rs_o == %h", 0);
  assert (rt_o == 0) else $error("expected rt_o == %h", 0);
  instr = { RTYPE, 5'h03, 5'h01, 5'h03, 5'h00, ADD };

  #10;
  assert (rs_o == rd_i) else $error("expected rs_o == %h", rd_i);
  assert (rt_o == 0) else $error("expected rt_o == %h", 0);
  write = DISABLE;
  instr = { BEQ, 5'h03, 5'h00, 16'b0 };

  #10;
  assert (rs_o == rd_i) else $error("expected rs_o == %h", rd_i);
  assert (rt_o == rd_i) else $error("expected rt_o == %h", rd_i);
  write = ENABLE;
  instr = { LW, 5'h04, 5'h04, 16'b0 };

  #10;
  assert (rs_o == rd_i) else $error("expected rs_o == %h", rd_i);
  write = DISABLE;
  instr = { SW, 5'h09, 5'h04, 16'b0 };

  #10;
  assert (rs_o == 0) else $error("expected rs_o == %h", 0);
  assert (rt_o == rd_i) else $error("expected rt_o == %h", rd_i);

end

always begin
  clk = 0;
  #5ns;
  clk = 1;
  #5ns;
end

endmodule