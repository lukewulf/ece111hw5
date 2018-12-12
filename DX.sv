import definitions::*;

module DX(
  input  wire clk,
  input  wire rst,

  input  Signal stall,
  input  Signal bubble,

  input  DX_ctrl ctrl,
  input  DX_data data_i,

  output ProgramCounter pc_jmp,
  output XM_ctrl xm_ctrl,
  output X_input x_data
);

always_ff @(posedge clk) begin
  if(rst | bubble) begin
    pc_jmp  <= ProgramCounter'(0);
    xm_ctrl <= XM_ctrl'(0);
    x_data  <= X_input'(0);
  end
  else if (stall) begin
    pc_jmp  <= pc_jmp;
    xm_ctrl <= xm_ctrl;
    x_data  <= x_data;
  end
  else begin
    pc_jmp         <= data_i.pc_jmp;
    
    // Control signals
    xm_ctrl        <= ctrl.xm;
    x_data.ctrl    <= ctrl.x;
    x_data.pc      <= data_i.pc;
    x_data.rs      <= data_i.rs_d;
    x_data.rt      <= data_i.rt_d;
    x_data.rs_addr <= data_i.rs_a;
    x_data.rt_addr <= data_i.rt_a;
    x_data.rd_addr <= data_i.rd_a;
    x_data.imm     <= data_i.imm;
  end
end

endmodule
