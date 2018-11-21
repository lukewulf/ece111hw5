module top;

logic clk;
logic rst;

wire y;

MIPS_13 processor(
    .clk(clk),
    .rst(rst),
    .y(y)
);

initial begin
    rst = 1;
    #10;
    rst = 0;
end

always begin
  clk = 0;
  #5ns;
  clk = 1;
  #5ns;
end

endmodule