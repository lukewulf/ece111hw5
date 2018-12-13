import definitions::*;
module fp_13 # (parameter cw = 1) (
    input            clk, rst,
    input  [cw-1:0]  flag_i,
    input            op,
    input  Float32   a, b,
    output Float32   c,
    output [cw-1:0]  flag_o
);

logic [cw-1:0] flag_cmp, flag_op, flag_align;

///////////////////////////////////////////////////////////////////////////////
Compare_in cmp_in;
always_comb begin
    cmp_in.a  = a;
    cmp_in.b  = b;
    cmp_in.op = op;
    flag_cmp  = flag_i; 
end
Operate_in cmp_out;
///////////////////////////////////////////////////////////////////////////////

// compare the operands and determine which is bigger
FP_C compare(
    .in (cmp_in ),
    .out(cmp_out)
);

///////////////////////////////////////////////////////////////////////////////
Operate_in op_in;
always_ff @ (posedge clk) begin
    op_in   <= cmp_out;
    flag_op <= flag_cmp;
end
Align_in   op_out;
///////////////////////////////////////////////////////////////////////////////

FP_O operate(
    .in (op_in ),
    .out(op_out)
);

///////////////////////////////////////////////////////////////////////////////
Align_in align_in;
always_ff @ (posedge clk) begin
    align_in   <= op_out;
    flag_align <= flag_op;
end
Float32 align_out;
///////////////////////////////////////////////////////////////////////////////

FP_A align(
    .in (align_in ),
    .out(align_out)
);

///////////////////////////////////////////////////////////////////////////////
assign c      = align_out;
assign flag_o = flag_align;
///////////////////////////////////////////////////////////////////////////////

endmodule
