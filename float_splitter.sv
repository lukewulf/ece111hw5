module float_splitter(
    input  [31:0] f,
    output        s,
    output [7:0]  e,
    output [22:0] m
);

assign s = f[31];
assign e = f[30:23];
assign m = f[22:0];

endmodule