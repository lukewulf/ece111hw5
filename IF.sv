import definitions::*;
module IF(
  input wire            clk,
  input Signal          reset,  // reset the pc to zero
  input Signal          stall,  // prevent pc changes
  input wire            branch,
  input wire            alu_zero,
  input wire            jmp,
  input ProgramCounter  pc_branch, // external pc source (branch, stall) 
  input ProgramCounter  pc_jmp,

  output ProgramCounter pc
);

wire pc_src;
assign pc_src = branch & alu_zero;

ProgramCounter _pc;
assign pc = _pc;

always_ff@(posedge clk) begin
  if(reset == ENABLE)
    _pc <= 0;
  else if (stall == ENABLE)
    _pc <= _pc;
  else if (jmp == 1'b1)
    _pc <= pc_jmp;
  else if (pc_src == 1'b1)
    _pc <= pc_branch;
  else
    _pc <= pc + 1;
end

endmodule
