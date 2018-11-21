import definitions::*;
module M(
  input  wire     clk,
  input  Register addr,
  input  Signal   read,
  input  Signal   write,
  input  Register mem_in,
  output Register mem_out
);

Register mem [2**MemAddrWidth];

initial begin
	$display("TEST");
	$readmemb("newest16.bin", mem);
end

wire [MemAddrWidth-1:0] _addr;
assign _addr = addr[MemAddrWidth-1:0];

always_comb begin
    if (read == ENABLE) mem_out = mem[_addr];
    else                mem_out = Register'(32'bZ);
end

always_ff @ (posedge clk) begin
    if (write == ENABLE) mem[_addr] = mem_in;
end

endmodule