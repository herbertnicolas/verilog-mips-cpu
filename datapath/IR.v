module IR (
    input wire clock,
    input wire reset,
    input wire ir_write,
    input wire [31:0] write_data,
    output wire [5:0] opcode,
    output wire [4:0] rs,
    output wire [4:0] rt,
    output wire [15:0] address_immediate
);

reg [31:0] instruction;

assign opcode            = instruction[31:26];
assign rs                = instruction[25:21];
assign rt                = instruction[20:16];
assign address_immediate = instruction[15:0];

always @(posedge clock) begin
    if (reset) begin
        instruction <= 0;
    end else if (ir_write) begin
        instruction <= write_data;
    end
end

endmodule