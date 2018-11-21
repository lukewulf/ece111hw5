// Instruction Decode (D) module
import definitions::*;

module D(
    input wire        clk,
    input Signal      reset,
    input Signal      write,
    input Register    rd_i,
    input Instruction instr,

    output Register   rs_o,
    output Register   rt_o
);

RegAddr rs, rt, rd;

RType instr_r;
assign instr_r = RType'(instr);

IType instr_i;
assign instr_i = IType'(instr);

JType instr_j;
assign instr_j = JType'(instr);

OpCode [5:0] opcode;
assign opcode = OpCode'(instr[31:26]);

RegisterFile RF(
    .clk(clk),
    .reset(reset),

    .write(write),
    .rd_i(rd_i),

    .rs(rs),
    .rt(rt),
    .rd(rd),

    .rs_o(rs_o),
    .rt_o(rt_o)
);

always_comb begin
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