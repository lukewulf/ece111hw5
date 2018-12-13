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
RegAddr fs, ft, fd;

assign out.rs_a = rs;
assign out.rt_a = rt;
assign out.rd_a = rd;

assign out.fs_a = fs;
assign out.ft_a = ft;
assign out.fd_a = fd;

Register rf_rs, rf_rt;

assign out.rs   = (in.dst == rs && ctrl.write   ) ? in.rd : rf_rs;
assign out.rt   = (in.dst == rt && ctrl.write   ) ? in.rd : rf_rt;

RType instr_r;
assign instr_r = RType'(in.instr);

IType instr_i;
assign instr_i = IType'(in.instr);

JType instr_j;
assign instr_j = JType'(in.instr);

FRType instr_fr;
assign instr_fr = FRType'(in.instr);

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

    .rs_o(rf_rs),
    .rt_o(rf_rt)
);

always_comb begin
    out.pc_jmp <= ProgramCounter'(in.instr[7:0]);
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
    case( opcode )  // floating point unit info
        LWC1: begin
            fs = instr_fr.fs;
            ft = RegAddr'(0);
            fd = instr_fr.fd;
        end
        SWC1: begin
            fs = instr_fr.fs;
            ft = instr_fr.ft;
            fd = RegAddr'(0);
        end
        ADDS: begin
            fs = instr_fr.fs;
            ft = instr_fr.ft;
            fd = instr_fr.fd;
        end
        default begin
            fs = RegAddr'(0);
            ft = RegAddr'(0);
            fd = RegAddr'(0);
        end
    endcase
end

endmodule