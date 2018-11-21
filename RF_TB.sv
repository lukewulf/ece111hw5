import definitions::*;
module RF_TB;

logic clk;
Signal reset;

Signal write;
Register rd_i;

RegAddr rs, rt, rd;

Register rs_o, rt_o;

RegisterFile RF(
    .clk(clk),
    .reset(reset),

    .write(write),
    .rd_i(rd_i),

    .rs(rs),
    .rt(rt),
    .rd(rd),

    .rs_o(rs_o),
    .rt_o(rt_o)
);

initial begin
  reset = ENABLE;
  write = DISABLE;
  rd_i  = Register'{32'hAAAAAAAA};

  rs = RegAddr'{0};
  rt = RegAddr'{0};
  rd = RegAddr'{0};
  
  #10; reset = DISABLE; write = ENABLE;
  
  #10;
  assert (rs_o == rd_i) else $error("expected rs_o == %h", rd_i);
  assert (rt_o == rd_i) else $error("expected rt_o == %h", rd_i);

  write = DISABLE;
  rd    = RegAddr'{5'h03};
  rs    = rd;
  
  #10;
  assert (rs_o == Register'{0}) else $error("expected rs_o == %h", 0);
  assert (rt_o == rd_i) else $error("expected rt_o == %h", rd_i);

  write = ENABLE;
  rt    = RegAddr'{5'h04};

  #10;
  assert (rs_o == rd_i) else $error("expected rs_o == %h", rd_i);
  assert (rt_o == Register'{0}) else $error("expected rt_o == %h", 0);

end

always begin
  clk = 0;
  #5ns;
  clk = 1;
  #5ns;
end

endmodule