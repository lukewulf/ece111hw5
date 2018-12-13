import definitions::*;
module M(
  input  wire     clk,
  input  M_input  in,
  output M_output out
);

Register mem [2**MemAddrWidth];

initial begin
	$display("TEST");
	$readmemh("prog2_mem.hex", mem);
end

wire [MemAddrWidth-1:0] _addr;
assign _addr = in.addr[MemAddrWidth-1+2:0+2];

always_comb begin
    if (in.read == ENABLE) out.val = mem[_addr];
    else                   out.val = Register'(32'bZ);
end

always_ff @ (posedge clk) begin
    if (in.write == ENABLE) mem[_addr] = in.val;
end

endmodule