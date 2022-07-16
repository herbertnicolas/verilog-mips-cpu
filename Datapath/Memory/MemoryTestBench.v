`timescale 1ns/1ps

module MemoryTestBench;

reg clk, mem_read, mem_write;
reg [7:0] address;
reg [31:0] data_in;
wire [31:0] data_out;
integer i;

Memory Memory_ (
    clk,
    mem_read,
    mem_write,
    address,
    data_in,
    data_out
);

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    $dumpfile("Memory.vcd");
    $dumpvars(0, MemoryTestBench);

    // Somente leitura
    mem_read = 1'b1;
    mem_write = 1'b0;
    for (i = 0; i < 20; i = i + 4) begin
        address = i;
        #10;
    end

    // Intercalando escrita e leitura
    for (i = 20; i < 40; i = i + 4) begin
        address = i;
        
        data_in = i*29 + 13;
        mem_read = 1'b0;
        mem_write = 1'b1;
        #10;

        mem_read = 1'b1;
        mem_write = 1'b0;
        #10;
    end

    $finish;
end

endmodule