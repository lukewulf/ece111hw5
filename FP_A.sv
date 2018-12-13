import definitions::*;

module FP_A(
    input  Align_in in,
    output Float32  out
);

// reposition the result
wire [4:0]  sh_amt;
mantissa_positioner m_pos(
    .m(in.mnt),

    .r(out.mnt),
    .e(sh_amt)
);

wire is_not_zero;
assign is_not_zero = |in.mnt;

// adjust the greater-than exponent by the amount adjusted
// add 1 to account for overflow-expanded bus
assign out.exp = (is_not_zero) ? (in.exp - sh_amt + 1) : 8'b0;

// set the appropriate sign
assign out.sign = in.sign ^ (in.flip & in.op);

endmodule
