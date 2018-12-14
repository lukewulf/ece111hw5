import definitions::*;

module FP_C(
    input  Compare_in in,
    output Operate_in out
);

assign out.op  = in.op;
assign out.dst = in.dst;

float_cmp f_cmp(
    .a(in.a),   .b(in.b),
    .gt(out.gt), .lt(out.lt),
    .e_dif(out.e_dif),
    .flip(out.flip)
);

endmodule
