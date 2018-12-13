import definitions::*;

module FPU(
    input           clk, rst,

    input  Signal   start,
    input  RegAddr  fs_addr,
    input  RegAddr  ft_addr,
    input  RegAddr  fd_addr,

    input  RegAddr  m_addr,
    input  Register m_data,
    input  Signal   m_write,

    output Signal   working,
    output FPU_output out
);

Register rf_data_i;
RegAddr  rf_addr_i;

Register fpu_data;
RegAddr  fpu_addr;

wire   fpu_done;
assign rf_data_i = (fpu_done) ? fpu_data : m_data;
assign rf_addr_i = (fpu_done) ? fpu_addr : m_addr;

Signal rf_write;
assign rf_write = Signal'(fpu_done | m_write);

wire always_add; assign always_add = 1;

Register fs, ft;
Register fs_o, ft_o;
assign out.ft = ft;

RegAddr out_dst;
assign out.dst = out_dst;

Signal flag_i;

always_ff @ (posedge clk) begin
    fs <= fs_o;
    ft <= ft_o;
    out_dst <= fd_addr;

    if ( working ) fpu_addr <= fpu_addr;
    else           fpu_addr <=  fd_addr;

    if      ( fpu_done ) begin
        flag_i  <= ENABLE;
        working <= DISABLE;
    end
    else if ( working  ) begin
        flag_i  <= DISABLE;
        working <= ENABLE;
    end
    else if ( start    ) begin
        flag_i  <= ENABLE;
        working <= ENABLE;
    end
    else begin
        flag_i  <= DISABLE;
        working <= DISABLE;
    end
end

fp_13 fpu_internal(
    .clk(clk), .rst(rst),

    .flag_i(flag_i),

    .op(always_add),
    .a(fs), .b(ft),
    .c(fpu_data),

    .flag_o(fpu_done)
);

RegisterFile RF(
    .clk(clk),
    .reset(Signal'(rst)),

    .write(rf_write),
    .rd_i(rf_data_i),

    .rs(fs_addr),
    .rt(ft_addr),
    .rd(rf_addr_i),

    .rs_o(fs_o),
    .rt_o(ft_o)
);

endmodule
