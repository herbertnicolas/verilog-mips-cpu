`timescale 1ns/1ps

module RegistersTestBench;

reg clock, reset, reg_write;
reg [4:0] read_register_1, read_register_2, write_register;
reg [31:0] write_data;
wire [31:0] read_data_1, read_data_2;
integer i;

Registers Registers_ (
    clock,
    reset,
    reg_write,
    read_register_1,
    read_register_2,
    write_register,
    write_data,
    read_data_1,
    read_data_2
);

initial clock = 1'b0;
always #5 clock = ~clock;

initial begin
    $dumpfile("Registers.vcd");
    $dumpvars(0, RegistersTestBench);
    reg_write = 0;
    #1 reset = 1;
    #5 reset = 0;
end

initial begin
    #10
    for (i = 0; i < 32; i = i + 1) begin
        read_register_1 = (i + 31) % 32;
        read_register_2 = i;
        write_register = i;
        write_data = 3*i + 1;
        reg_write = 1;
        #10;
    end
    $finish;
end

endmodule