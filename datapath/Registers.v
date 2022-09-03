module Registers (
    input wire         clock,
    input wire         reset,
    input wire         reg_write,
    input wire  [4:0]  read_register_1,
    input wire  [4:0]  read_register_2,
    input wire  [4:0]  write_register,
    input wire  [31:0] write_data,
    output wire [31:0] read_data_1,
    output wire [31:0] read_data_2
);

reg [31:0] bank [0:31];
integer i;

// reading from registers asynchronously
assign read_data_1 = bank[read_register_1];
assign read_data_2 = bank[read_register_2];

always @(posedge clock) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            bank[i] <= 0;
        end
        bank[5'd0] <= 32'd0;
        bank[5'd29] <= 32'd227;
    end else if (reg_write) begin
        bank[write_register] <= write_data;
    end
end

// for simulation

wire [31:0] zero, at, v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7;

assign zero = bank[0];
assign at = bank[1];
assign v0 = bank[2];
assign v1 = bank[3];
assign a0 = bank[4];
assign a1 = bank[5];
assign a2 = bank[6];
assign a3 = bank[7];
assign t0 = bank[8];
assign t1 = bank[9];
assign t2 = bank[10];
assign t3 = bank[11];
assign t4 = bank[12];
assign t5 = bank[13];
assign t6 = bank[14];
assign t7 = bank[15];
assign s0 = bank[16];

wire [31:0] s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra;

assign s0 = bank[16];
assign s1 = bank[17];
assign s2 = bank[18];
assign s3 = bank[19];
assign s4 = bank[20];
assign s5 = bank[21];
assign s6 = bank[22];
assign s7 = bank[23];
assign t8 = bank[24];
assign t9 = bank[25];
assign k0 = bank[26];
assign k1 = bank[27];
assign gp = bank[28];
assign sp = bank[29];
assign fp = bank[30];
assign ra = bank[31];

endmodule