import definitions::*;
module DM_TB;

logic clk;
Register addr;
Signal read;
Signal write;
Register mem_in;
Register mem_out;

DataMemory DM(
    .clk(clk),

    .addr(addr),
    .read(read),
    .write(write),

    .mem_in(mem_in),
    .mem_out(mem_out)
);

initial begin
    addr   = Register'(0);
    read   = ENABLE;
    write  = DISABLE;
    mem_in = Register'(32'hAAAAAAAA);

    #10;
    assert (mem_out == 0) else $error("expected mem_out == %h", 0);
    read   = DISABLE;
    write  = ENABLE;
    
    #10;
    assert (mem_out === 32'bz) else $error("expected mem_out == ZZZ");
    write  = DISABLE;
    read   = ENABLE;

    #10;
    assert (mem_out == mem_in) else $error("expected mem_out == %h", mem_in);
    addr   = Register'(32'h0F);

    #10;
    assert (mem_out == 32'hF) else $error("expected mem_out == %h", 32'hF);
    read   = DISABLE;
    write  = ENABLE;
    
    #10;
    assert (mem_out === 32'bz) else $error("expected mem_out == ZZZ");
    write  = DISABLE;
    read   = ENABLE;

    #10;
    assert (mem_out == mem_in) else $error("expected mem_out == %h", mem_in);


end

always begin
  clk = 0;
  #5ns;
  clk = 1;
  #5ns;
end

endmodule