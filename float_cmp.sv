import definitions::*;

module float_cmp(
    input  Float32   a, b,
    output Float32   gt, lt,
    output Exponent  e_dif,
    output           flip
);

wire e_cmp;
assign e_cmp = (a.exp > b.exp);

assign e_dif = (e_cmp) ? (a.exp - b.exp) : (b.exp - a.exp);

wire m_cmp;
assign m_cmp = (a.mnt > b.mnt);

wire m_priority;
assign m_priority = (e_dif == 0) & m_cmp;

assign flip = ~(e_cmp | m_priority);

assign gt = (flip) ? b : a;
assign lt = (flip) ? a : b;

endmodule