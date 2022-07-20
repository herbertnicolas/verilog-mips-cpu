module MuxIorD (
  input wire [1:0]  i_or_d,
  input wire [31:0] pc_output,
  input wire [31:0] alu_out_output,
  input wire [31:0] alu_result,
  output reg [7:0] result
);

always @(*) begin
    case (i_or_d)
      0: result = pc_output[7:0];
      1: result = alu_out_output[7:0];
      2: result = 8'd252;
      3: result = alu_result[7:0];
    endcase
end

endmodule