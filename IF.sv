import definitions::*;
module IF(
  input  wire      clk,
  input  Signal    reset,  // reset the pc to zero
  
  input  IF_input  in,
  output IF_output out
);

wire pc_src;
assign pc_src = in.branch & in.alu_zero;

ProgramCounter _pc;
assign out.pc = _pc;

always_ff@(posedge clk) begin
  if(reset == ENABLE)
    _pc <= 0;
  else if (in.stall == ENABLE)
    _pc <= _pc;
  else if (in.jmp == ENABLE)
    _pc <= in.pc_jmp;
  else if (pc_src == 1'b1)
    _pc <= in.pc_branch;
  else
    _pc <= out.pc + 1;
end

endmodule
