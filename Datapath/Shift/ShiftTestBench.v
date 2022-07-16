`timescale 1ns/1ps

module ShiftTestBench;

reg [1:0] shift_ctrl;
reg [4:0] shamt;
reg signed [31:0] shift_in;
wire signed [31:0] shift_out;

Shift Shift_ (
    shift_ctrl,
    shamt,
    shift_in,
    shift_out
);

parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;

initial begin
    $dumpfile("Shift.vcd");
    $dumpvars(0, ShiftTestBench);
    shift_in = 32'd10;
    shift_ctrl = SLL;
    shamt = 5'd1;
    #10;
    shamt = 5'd2;
    #10;
    shamt = 5'd3;
    #10;
    shift_ctrl = SRL;
    shift_in = -32'd17;
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