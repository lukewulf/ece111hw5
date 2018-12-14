import definitions::*;

module FPU(
    input           clk, rst,

    input  Signal   stall,

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

wire always_add; assign always_add = 0;

Register fs, ft;
Register fs_o, ft_o;
assign out.ft = ft;

RegAddr out_dst;
assign out.dst = out_dst;

Signal flag_i;

Register fs_i, ft_i;

assign fs_i = ( m_addr == fs_addr && m_write ) ? m_data : fs;
assign ft_i = ( m_addr == ft_addr && m_write ) ? m_data : ft;

always_ff @ (posedge clk) begin
	if( stall ) begin
		start_buf   <= start_buf;
		fs_addr_buf <= fs_addr_buf;
		ft_addr_buf <= ft_addr_buf;
		fd_addr_buf <= fd_addr_buf;
	end
	else begin
		start_buf   <= start;
		fs_addr_buf <= fs_addr;
		ft_addr_buf <= ft_addr;
		fd_addr_buf <= fd_addr;
	end
end

always_ff @ (posedge clk) begin
    fs      <= fs_o;
    ft      <= ft_o;

    if ( stall ) out_dst <= RegAddr'(0);
    else         out_dst <= fd_addr;

    if ( working | stall ) fpu_addr <= fpu_addr;
    else                   fpu_addr <=  fd_addr;

    if      ( fpu_done ) begin
        flag_i  <= DISABLE;
        working <= DISABLE;
    end
    else if ( working  ) begin
        flag_i  <= DISABLE;
        working <= ENABLE;
    end
    else if ( stall    ) begin
        flag_i  <= DISABLE;
        working <= DISABLE;
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
    .a(fs_i), .b(ft_i),
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
