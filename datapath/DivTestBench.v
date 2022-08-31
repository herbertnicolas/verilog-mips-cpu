`timescale 1ns/1ps
`include "Div.v"

module DivTestBench;

reg clock, reset;
reg div_start;
reg [31:0] dividend, divisor;
wire finished, div_zero;
wire [31:0] quotient, remainder;

Div Div_ (
    clock,
    reset,
    div_start,
    dividend,
    divisor,
    div_zero,
    finished,
    quotient,
    remainder
);

initial clock = 1'b0;
always #5 clock = ~clock;

initial begin
    $dumpfile("Div.vcd");
    $dumpvars(0, DivTestBench);

    reset = 1;
    #6;
    reset = 0;

    #4;

    dividend = 32'd7;
    divisor = 32'd2;
    div_start = 1;
    #10;
    div_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    dividend = 32'd15;
    divisor = -32'd4;
    div_start = 1;
    #10;
    div_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;
    dividend = -32'd10;
    divisor = 32'd3;
    div_start = 1;
    #10;
    div_start = 0;
    #5;
    while (!finished) begin
        #10;
    end
    #5;
    dividend = -32'd12;
    divisor = -32'd4;
    div_start = 1;
    #10;
    div_start = 0;
    #5;
    while (!finished) begin
        #10;
    end
    #5;
    dividend = 32'd1;
    divisor = 32'd0;
    div_start = 1;
    #10;
    div_start = 0;
    #5;
    #20;
    dividend = 32'd5;
    divisor = 32'd70;
    div_start = 1;
    #10;
    div_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;
    $finish;
end

endmodule