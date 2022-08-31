`timescale 1ns/1ps
`include "Mult.v"

module MultTestBench;

reg clock, reset;
reg mult_start;
reg [31:0] multiplicand, multiplier;
wire finished;
wire [31:0] hi, lo;

Mult Mult_ (
    clock,
    reset,
    mult_start,
    multiplicand,
    multiplier,
    finished,
    hi,
    lo
);

initial clock = 1'b0;
always #5 clock = ~clock;

initial begin
    $dumpfile("Mult.vcd");
    $dumpvars(0, MultTestBench);

    reset = 1;
    #6;
    reset = 0;

    #4;

    multiplicand = 32'd5;
    multiplier = 32'd3;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    multiplicand = 32'd3;
    multiplier = -32'd2;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    multiplicand = -32'd8;
    multiplier = -32'd7;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    multiplicand = 32'd1000000003;
    multiplier = 32'd2000000002;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    multiplicand = -32'd1500000001;
    multiplier = 32'd2000000007;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    multiplicand = 32'd1500000009;
    multiplier = -32'd1500000004;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    multiplicand = -32'd1000000002;
    multiplier = -32'd1000000006;
    mult_start = 1;
    #10;
    mult_start = 0;
    #5;
    while (~finished) begin
        #10;
    end
    #5;

    $finish;
end

endmodule