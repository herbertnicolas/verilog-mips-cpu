module MuxALUSrcB (
  input wire [2:0]  alu_src_b,
  input wire [31:0] b_output,
  input wire [31:0] sign_extend,
  input wire [31:0] address,
  input wire [31:0] mdr_output,
  output reg [31:0] mux_alu_src_b_output
);

always @(*) begin
  case (alu_src_b)
    0: mux_alu_src_b_output = b_output;
    1: mux_alu_src_b_output = 32'd4;
    2: mux_alu_src_b_output = sign_extend;
    3: mux_alu_src_b_output = address;
    4: mux_alu_src_b_output = mdr_output;
  endcase
end

endmodule