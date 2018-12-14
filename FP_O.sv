import definitions::*;

module FP_O(
    input  Operate_in in,
    output Align_in   out
);

Mantissa_ext gt_m_ext, lt_m_ext;

operand_align align(
    .gt(in.gt),
    .lt(in.lt),
    .e_dif(in.e_dif),

    .gt_m_ext(gt_m_ext),
    .lt_m_ext(lt_m_ext)
);

// ALU op determination
wire action;
assign action = in.gt.sign ^ in.lt.sign ^ in.op;

// operate on the aligned mantissas
assign out.op   = in.op;
assign out.flip = in.flip;
assign out.dst  = in.dst;

assign out.sign = in.gt.sign;
assign out.exp  = in.gt.exp;
assign out.mnt  = (action) ? (gt_m_ext - lt_m_ext) : (gt_m_ext + lt_m_ext);

endmodule
