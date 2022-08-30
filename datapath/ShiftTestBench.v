`timescale 1ns/1ps
`include "Shift.v"

module ShiftTestBench;

reg [1:0] shift_ctrl;
reg [4:0] shamt;
reg clock, reset;
reg signed [31:0] shift_src;
wire signed [31:0] shift_out;

Shift Shift_ (
    clock,
    reset,
    shift_ctrl,
    shamt,
    shift_src,
    shift_out
);

initial clock = 1'b0;
always #5 clock = ~clock;

parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;

initial begin
    $dumpfile("Shift.vcd");
    $dumpvars(0, ShiftTestBench);

    reset = 1;
    #6;
    reset = 0;

    #4;

    shift_src = 32'd10;
    shift_ctrl = SLL;
    shamt = 5'd1;
    #10;
    shamt = 5'd2;
    #10;
    shamt = 5'd3;
    #10;
    shift_ctrl = SRL;
    shift_src = -32'd17;
    shamt = 5'd1;
    #10;
    shamt = 5'd10;
    #10;
    shamt = 5'd31;
    #10;
    shift_ctrl = SRA;
    shamt = 5'd1;
    #10;
    shamt = 5'd10;
    #10;
    shamt = 5'd31;
    #10;
    $finish;
end

endmodule