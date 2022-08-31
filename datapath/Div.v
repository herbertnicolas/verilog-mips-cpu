module Div (
    input wire clock,
    input wire reset,
    input wire div_start,
    input wire [31:0] dividend,
    input wire [31:0] divisor,
    output wire div_zero,
    output wire finished,
    output wire [31:0] quotient,
    output wire [31:0] remainder
);

reg [63:0] shift_right, subtract, aux;
reg [31:0] shift_left;
wire [31:0] abs_divisor, abs_dividend;

assign div_zero = divisor == 0;
assign abs_divisor = divisor[31] ? -divisor : divisor;
assign abs_dividend = dividend[31] ? -dividend : dividend;
assign finished = subtract < abs_divisor;
assign quotient = (divisor[31] ^ dividend[31]) ? -shift_left : shift_left;
assign remainder = dividend[31] ? -subtract : subtract;

always @(posedge clock) begin
    if (reset) begin
        shift_right <= 0;
        shift_left <= 0;
        subtract <= 0;
        aux <= 0;
    end else if (div_start) begin
        shift_right <= abs_divisor << 32;
        shift_left <= 0;
        subtract <= {32'b0, abs_dividend};
        aux <= {32'b0, abs_dividend};
    end else begin
        subtract <= aux;
        shift_right <= shift_right >> 1;
    end
end

always @(negedge clock) begin
    if (~(finished | div_zero)) begin
        if (subtract >= shift_right) begin
            shift_left <= (shift_left << 1) + 1;
            aux <= subtract - shift_right;
        end else begin
            shift_left <= shift_left << 1;
            aux <= subtract;
        end
    end
end

endmodule