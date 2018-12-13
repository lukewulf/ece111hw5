import definitions::*;

module operand_align(
    input  Float32      gt, lt,
    input  Exponent     e_dif,

    output Mantissa_ext gt_m_ext, lt_m_ext
);

// add the implicit leading 1
// handle edge case for 0.00
wire gt_lead, lt_lead;
assign gt_lead = |{gt.exp, gt.mnt};
assign lt_lead = |{lt.exp, lt.mnt};

Mantissa_ext lt_m_tmp;
assign gt_m_ext = {gt_lead, gt.mnt};
assign lt_m_tmp = {lt_lead, lt.mnt};

// shift the less-than mantissa to the appropriate position
mantissa_shifter shifter(
    .e(e_dif),
    .m(lt_m_tmp),
    .o(lt_m_ext)
);

endmodule
