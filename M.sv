import definitions::*;
module M(
  input  wire     clk,
  input  M_input  in,
  output M_output out
);

reg [7:0] mem [2**(MemAddrWidth+2)];

initial begin
	$display("TEST");
	// $readmemh("prog3_mem.hex", mem);
	$readmemh("test_data.hex", mem);
end

wire [MemAddrWidth-1:0] _addr;
assign _addr = in.addr[MemAddrWidth-1+2:0+2];

always_comb begin
    if (in.read == ENABLE) begin
        out.val = Register'({
            mem[{_addr, 2'b00}],
            mem[{_addr, 2'b01}],
            mem[{_addr, 2'b10}],
            mem[{_addr, 2'b11}]
    });
    end
    else                   out.val = Register'(32'bZ);
end

wire [7:0] val_00, val_01, val_10, val_11;

assign val_00 = in.val[7:0];
assign val_01 = in.val[15:8];
assign val_10 = in.val[23:16];
assign val_11 = in.val[31:24];

always_ff @ (posedge clk) begin
    if (in.write == ENABLE) begin
        mem[{_addr, 2'b00}] = val_11;
        mem[{_addr, 2'b01}] = val_10;
        mem[{_addr, 2'b10}] = val_01;
        mem[{_addr, 2'b11}] = val_00;
    end
end

endmodule