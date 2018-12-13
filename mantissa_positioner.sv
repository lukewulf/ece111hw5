module mantissa_positioner(
    input  [24:0] m,
    output [22:0] r,
    output [4:0]  e
);

wire [24:0] layers [5:0];
assign layers[5] = m;

genvar i;
for (i = 4; i >= 0; i--) begin
    parameter width  = 24 - 2**i;
    assign e[i]      = ~(|layers[i+1][24:(width + 1)]);
    assign layers[i] = (e[i]) ? {layers[i+1][width:0], {(2**i){1'b0}}} : layers[i+1] ;
end

assign r = layers[0][23:1];

endmodule