import definitions::*;
module RegisterFile(
    input wire      clk,
    input Signal    reset, // set all registers to zero
    
    // write data to the register file
    input Signal    write,
    input Register  rd_i,

    // up to three registers can be interacted with
    input RegAddr   rs,
    input RegAddr   rt,
    input RegAddr   rd,

    output Register rs_o,
    output Register rt_o
);

parameter bus_size = RegAddrWidth**2;

Register regs [(bus_size - 1):0];

assign rs_o = regs[rs];
assign rt_o = regs[rt];

integer i;
always_ff @ (posedge clk) begin
    // I can't tell if this style is good or bad...
    if (reset == ENABLE) for (i=0; i<bus_size; i=i+1)
                              regs[i]  <= 0;
    else if (write == ENABLE) regs[rd] <= rd_i;
    else                      regs[rd] <= regs[rd];
end

endmodule