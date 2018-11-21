import definitions::*;
module IF(
  input wire            clk,
  input Signal          reset,  // reset the pc to zero
  input Signal          stall,  // prevent pc changes
  input wire            branch,
  input wire            alu_zero,
  input ProgramCounter  pc_ext, // external pc source (branch, stall)
  
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
  else if (pc_src == 1'b1)
    _pc <= pc_ext;
  else
    _pc <= pc + 1;
end

endmodule
