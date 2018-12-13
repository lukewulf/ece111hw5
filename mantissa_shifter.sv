module mantissa_shifter(
    input  [7:0]  e,
    input  [23:0] m,
    output [23:0] o
);

// barrel shifter
wire [23:0] layers [5:0];
assign layers[0] = e[0] ? {0, m[23:1]} : m;
genvar i;
for (i = 1; i < 5; i++) begin
    assign layers[i] = e[i] ? {0, layers[i-1][23:(2**i)]} : layers[i-1];
end

// any exponent too large will wipe out the whole thing
assign layers[5] = (|e[7:5]) ? 24'b0 : layers[4];

assign o = layers[5];

endmodule