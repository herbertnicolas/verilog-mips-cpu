module Shift (
    input  wire         [1:0]  shift_ctrl,
    input  wire         [4:0]  shamt,
    input  wire signed [31:0]  shift_src,
    output wire signed [31:0]  shift_out
);

parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;

assign shift_out =
    (shift_ctrl == SLL) ? shift_src <<  shamt :
    (shift_ctrl == SRL) ? shift_src >>  shamt :
    (shift_ctrl == SRA) ? shift_src >>> shamt : shift_src;

endmodule