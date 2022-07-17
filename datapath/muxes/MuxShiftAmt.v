module MuxShiftAmt (
  input  wire [1:0]  shift_amt_ctrl,
  input  wire [31:0] b_output, // b_output[4:0]
  input  wire [4:0]  shamt, // shamt
  input  wire [31:0] mdr_output, // mdr_output[4:0]
  output reg [4:0] mux_shift_amt_output
);

always @(*) begin
  case (shift_amt_ctrl)
    0: mux_shift_amt_output = b_output[4:0];
    1: mux_shift_amt_output = shamt;
    2: mux_shift_amt_output = mdr_output[4:0];
  endcase
end

endmodule