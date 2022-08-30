module Shift (
    input  wire clock,
    input  wire reset,
    input  wire         [1:0]  shift_ctrl,
    input  wire         [4:0]  shamt,
    input  wire signed [31:0]  shift_src,
    output wire signed [31:0]  shift_out
);

parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;

reg [31:0] data;

assign shift_out = data;

always @(posedge clock) begin
    if (reset) begin
        data <= 0;
    end else begin
        case (shift_ctrl)
            SLL: data <= shift_src << shamt; 
            SRL: data <= shift_src >> shamt;
            SRA: data <= shift_src >>> shamt;
            default: data <= shift_src;
        endcase
    end
end

endmodule