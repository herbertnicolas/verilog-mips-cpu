// Author: Gustavo Farani de Farias
// E-mail: gff@cin.ufpe.br
// Date: 16/07/2022

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
    end else if (reg_write) begin
        bank[write_register] <= write_data;
    end
end

endmodule