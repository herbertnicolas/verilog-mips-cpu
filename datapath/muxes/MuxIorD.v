module MuxIorD (
  input wire [1:0]  i_or_d,
  input wire [31:0] pc_output,
  input wire [31:0] alu_out_output,
  input wire [31:0] alu_result,
  output reg [7:0] mux_i_or_d_output
);

always @(*) begin
    case (i_or_d)
      0: mux_i_or_d_output = pc_output[7:0];
      1: mux_i_or_d_output = alu_out_output[7:0];
      2: mux_i_or_d_output = 8'd252;
      3: mux_i_or_d_output = alu_result[7:0];
    endcase
end

endmodule