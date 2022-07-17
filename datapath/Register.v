module Register (
    input  wire clock,
    input  wire reset,
    input  wire load,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

reg [31:0] data;

assign read_data = data;

always @(posedge clock) begin
    if (reset) begin
        data <= 0;
    end else begin
        data <= write_data;
    end
end

endmodule