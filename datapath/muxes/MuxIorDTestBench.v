`timescale 1ns/1ps
`include "MuxIorD.v"

module MuxIorDTestBench;
    reg [1:0] i_or_d;
    reg [31:0] input_0, input_1, input_2, input_3;
    wire [7:0] result;

    MuxIorD MuxIorD_ (
        i_or_d,
        input_0,
        input_1,
        input_2,
        input_3,
        result
    );

    initial begin
        $dumpfile("MuxIorD.vcd");
        $dumpvars(0, MuxIorDTestBench);

        input_0 = 32'd1;
        input_1 = 32'd3;
        input_2 = 32'd5;
        input_3 = 32'd7;

        i_or_d = 2'd0;
        #10;

        i_or_d = 2'd1;
        #10;

        i_or_d = 2'd2;
        #10;

        i_or_d = 2'd3;
        #10;

        input_3 = 32'd10;
        #10;

    end
endmodule