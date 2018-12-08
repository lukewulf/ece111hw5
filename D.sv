// Instruction Decode (D) module
import definitions::*;

module D(
    input wire        clk,
    input Signal      reset,

    input  D_control  ctrl,
    input  D_input    in,
    output D_output   out
);

RegAddr rs, rt, rd;

assign out.rs_a = rs;
assign out.rt_a = rt;
assign out.rd_a = rd;

RType instr_r;
assign instr_r = RType'(in.instr);

IType instr_i;
assign instr_i = IType'(in.instr);

JType instr_j;
assign instr_j = JType'(in.instr);

OpCode [5:0] opcode;
assign opcode = OpCode'(in.instr[31:26]);

RegisterFile RF(
    .clk(clk),
    .reset(reset),

    .write(ctrl.write),
    .rd_i(in.rd),

    .rs(rs),
    .rt(rt),
    .rd(in.dst),

    .rs_o(out.rs),
    .rt_o(out.rt)
);

always_comb begin
    out.pc_jmp <= ProgramCounter'({ in.pc[31:27], in.instr[25:0], 2'b0 });
    case(opcode)
        RTYPE: begin  //  R[rd] = R[rs] + R[rt] 
            rs    = instr_r.rs;
            rt    = instr_r.rt;
            rd    = instr_r.rd;
        end

        ADDI: begin  //  R[rt] = R[rs] + SignExtImm 
            rs    = instr_i.rs;
            rt    = RegAddr'(0);  // dont care
            rd    = instr_i.rt; // use rt as the write register
        end

        BEQ: begin  // if(R[rs]==R[rt]) PC=PC+4+BranchAddr
                    // expose rs and rt
            rs    = instr_i.rs;
            rt    = instr_i.rt;
            rd    = RegAddr'(0);  // dont care
        end

        LW: begin  // R[rt] = M[R[rs]+SignExtImm]
            rs    = instr_i.rs;
            rt    = RegAddr'(0);  // dont care
            rd    = instr_i.rt;
        end

        SW: begin  //  M[R[rs]+SignExtImm] = R[rt]
            rs    = instr_i.rs;
            rt    = instr_i.rt;
            rd    = RegAddr'(0);  // dont care
        end

        default: begin // J
            // nothing even matters
            rs    = RegAddr'(0);
            rt    = RegAddr'(0);
            rd    = RegAddr'(0);
        end
    endcase
end

endmodule