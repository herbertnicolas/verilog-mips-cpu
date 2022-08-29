module MuxShiftSrc (
  input  wire        shift_src_ctrl,
  input  wire [31:0] b_output,
  input  wire [31:0] a_output,
  output wire [31:0] mux_shift_src_output
);

  assign mux_shift_src_output = shift_src_ctrl ? a_output : b_output;

endmodule