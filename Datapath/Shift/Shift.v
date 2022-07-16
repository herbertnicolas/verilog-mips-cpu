module Shift (
    input  wire         [1:0]  shift_ctrl,
    input  wire         [4:0]  shamt,
    input  wire signed [31:0]  shift_in,
    output wire signed [31:0]  shift_out
);

parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;

assign shift_out =
    (shift_ctrl == SLL) ? shift_in <<  shamt :
    (shift_ctrl == SRL) ? shift_in >>  shamt :
    (shift_ctrl == SRA) ? shift_in >>> shamt : shift_in;

endmodule