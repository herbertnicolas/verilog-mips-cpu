module MuxALUSrcA (
  input  wire        alu_src_a,
  input  wire [31:0] pc_output,
  input  wire [31:0] a_output,
  output wire [31:0] mux_alu_src_a_output
);

assign mux_alu_src_a_output = alu_src_a ? a_output : pc_output;

endmodule