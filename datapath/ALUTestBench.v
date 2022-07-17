`timescale 1ns/1ps

module ALUTestBench;

    reg [31:0] a, b;
    reg [2:0] alu_ctrl;
    wire [31:0] alu_out;
    wire zero, negative, overflow, equal_to, less_than, greater_than;

    parameter LOAD_A = 3'b000;
    parameter ADD    = 3'b001;
    parameter SUB    = 3'b010;
    parameter AND    = 3'b011;
    parameter INCREM = 3'b100;
    parameter NOT_A  = 3'b101;
    parameter XOR    = 3'b110;
    parameter LOAD_B = 3'b111;

    ALU ALU_ (
        a,
        b,
        alu_ctrl,
        alu_out,
        zero,
        negative,
        overflow,
        equal_to,
        less_than,
        greater_than
    );

    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALUTestBench);

        alu_ctrl = ADD;

        // positive, positive
        a = 32'd10;  b = 32'd15; #10; // + + < +
        a = 32'd12;  b = 32'd12; #10; // + + = +
        a = 32'd100; b = 32'd5;  #10; // + + > +
        a = 32'd2000003300;  b = 32'd1000000007; #10; // + + ^

        // positive, negative
        a = 32'd99; b = -32'd3;  #10; // + - > +
        a = 32'd10; b = -32'd10; #10; // + - > 0
        a = 32'd1;  b = -32'd20; #10; // + - > -

        // negative, positive
        a = -32'd9;  b = 32'd13; #10; // - + < +
        a = -32'd8;  b = 32'd8;  #10; // - + < 0
        a = -32'd1;  b = 32'd20; #10; // - + < -

        // negative, negative
        a = -32'd50; b = -32'd44; #10; // - - < -
        a = -32'd21; b = -32'd21; #10; // - - = -
        a = -32'd1;  b = -32'd2;  #10; // - - > -
        a = -32'd1700009900; b = -32'd1800000009; #10; // - - ^

        alu_ctrl = SUB;
        
        // positive, positive
        a = 32'd50;   b = 32'd11;   #10; // + + > +
        a = 32'd1970; b = 32'd1970; #10; // + + = 0
        a = 32'd1;    b = 32'd200;  #10; // + + < -
        
        // negative, positive
        a = -32'd506;        b = 32'd99;         #10; // - + < -
        a = -32'd2000000070; b = 32'd1800000003; #10; // - + < - ^
        
        // positive, negative
        a = 32'd7000;       b = -32'd2;          #10; // + - > +
        a = 32'd2147483647; b = -32'd1;          #10; // + - > + ^
        a = 32'd0;          b = -32'd2147483648; #10; // + - > + ^
        
        // negative, negative
        a = -32'd33;   b = -32'd100;        #10; // - - > +
        a = -32'd1;    b = -32'd2147483648; #10; // - - > + ^
        a = -32'd966;  b = -32'd966;        #10; // - - = 0
        a = -32'd1000; b = -32'd8;          #10; // - - < -

        alu_ctrl = AND;

        a = 32'd4;  b = 32'd7;  #10;
        a = -32'd1; b = -32'd9; #10;
        a = -32'd500700891; b = 32'd1008555192; #10;
        
        $finish;
    end

endmodule
