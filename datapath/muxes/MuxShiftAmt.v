module MuxShiftAmt (
  input  wire        shift_amt_ctrl,
  input  wire [4:0]  shamt,
  input  wire [31:0] b_output,
  output wire [4:0]  mux_shift_amt_output
);

  assign mux_shift_amt_output = shift_amt_ctrl ? b_output[4:0] : shamt;

endmodule