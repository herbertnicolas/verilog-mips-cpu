`timescale 1ns/1ps
`include "CPU.v"

module CPUTestBench;

reg clock, reset;

CPU CPU_(clock, reset);

initial clock = 1'b1;
always #5 clock = ~clock;

initial begin
    $dumpfile("CPU.vcd");
    $dumpvars(0, CPUTestBench);

    reset = 1;
    #11;
    reset = 0;

    #1000;
    $finish;
end

endmodule