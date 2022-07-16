// Author: Gustavo Farani de Farias
// E-mail: gff@cin.ufpe.br
// Date: 16/07/2022

module Memory (
    input wire        clk,
    input wire        mem_read,
    input wire        mem_write,
    input wire [7:0]  address,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);

reg [7:0] mem [255:0];
wire [7:0] address_1, address_2, address_3;

assign address_1 = address + 1;
assign address_2 = address_1 + 1;
assign address_3 = address_2 + 1;

initial begin
    // ASCII text file (not a binary file)
    // with 256 hex values (3F, not 0x3F)
    // separated by spaces or newlines
    // listing the contents of all the bytes stored in memory
    $readmemh("mem_init.hex", mem);
end

always @(posedge clk) begin
    if (mem_read && !mem_write) begin
        data_out <= {mem[address], mem[address_1], mem[address_2], mem[address_3]};
    end
end

always @(posedge clk) begin
    if (mem_write && !mem_read) begin
        mem[address]   <= data_in[31:24];
        mem[address_1] <= data_in[23:16];
        mem[address_2] <= data_in[15:8];
        mem[address_3] <= data_in[7:0];
    end
end

endmodule