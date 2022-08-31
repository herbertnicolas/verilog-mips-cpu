module Mult (
    input wire clock,
    input wire reset,
    input wire mult_start,
    input wire [31:0] multiplicand,
    input wire [31:0] multiplier,
    output wire finished,
    output wire [31:0] hi,
    output wire [31:0] lo
);

reg [63:0] product, shift_left;
reg [31:0] shift_right;
reg sign;
wire [63:0] abs;

assign abs = (sign ? -product : product);
assign hi = abs[63:32];
assign lo = abs[31:0];
assign finished = shift_right == 0;

// finished and mult_start are triggered on posedge
always @(posedge clock) begin
    if (reset) begin
        product <= 0;
        shift_left <= 0;
        shift_right <= 0;
    end else if (mult_start) begin
        product <= 0;
        shift_left[31:0] <= multiplicand[31] ? -multiplicand : multiplicand;
        shift_left[63:32] <= 32'b0;
        shift_right <= multiplier[31] ? -multiplier : multiplier;
        sign <= multiplicand[31] ^ multiplier[31];
    end else begin
        shift_left <= shift_left << 1;
        shift_right <= shift_right >> 1;
    end
end

always @(negedge clock) begin
    product <= product + (shift_right[0] ? shift_left : 0);
end

endmodule