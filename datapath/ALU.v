module ALU (
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0]  alu_ctrl,
    output [31:0] alu_out,
    output        zero,
    output        negative,
    output        overflow,
    output        equal_to,
    output        less_than,
    output        greater_than
);

parameter LOAD_A = 3'b000;
parameter ADD    = 3'b001;
parameter SUB    = 3'b010;
parameter AND    = 3'b011;
parameter INCREM = 3'b100;
parameter NOT_A  = 3'b101;
parameter XOR    = 3'b110;
parameter LOAD_B = 3'b111;

parameter SIGNED_MAX = {1'b0, {31{1'b1}}};
parameter SIGNED_MIN = {1'b1, {31{1'b0}}};

wire carry_out;
wire [31:0] nb;

// two's complement
assign {carry_out, nb} = ~b + 1;

assign {carry_out, alu_out} =
    (alu_ctrl == LOAD_A) ? a      :
    (alu_ctrl == ADD)    ? a + b  :
    (alu_ctrl == SUB)    ? a + nb :
    (alu_ctrl == AND)    ? a & b  :
    (alu_ctrl == INCREM) ? a + 1  :
    (alu_ctrl == NOT_A)  ? ~a     :
    (alu_ctrl == XOR)    ? a ^ b  : b;

// the carry_out bit doesn't matter when checking for signed integer overflow
// the carry_out bit would only matter if the integers were unsigned
assign overflow =
    // a and b are positive and their sum is negative or a and b are negative and their sum is positive
    (alu_ctrl == ADD)    ? (a[31] == b[31] && a[31] != alu_out[31])                        :
    // there is no binary representation for -b with only 32 bits (b is the lowest negative signed integer) or
    // a and -b are positive and their sum is negative or a and -b are negative and their sum is positive
    (alu_ctrl == SUB)    ? (b == SIGNED_MIN || (a[31] == nb[31] && a[31] != alu_out[31]) ) :
    // a is the highest positive signed integer
    (alu_ctrl == INCREM) ? (a == SIGNED_MAX)                                               : 0;

assign zero         = (alu_out == 0);
assign negative     = alu_out[31];
assign equal_to     = (a == b);
assign less_than    = (a[31] ^ b[31]) ? a[31] : (a < b);
assign greater_than = (a[31] ^ b[31]) ? b[31] : (a > b);

endmodule
