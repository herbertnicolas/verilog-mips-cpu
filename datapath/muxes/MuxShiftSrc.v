module MuxShiftSrc (
  input  wire        ShiftSrc,
  input  wire [31:0] input0,
  input  wire [31:0] input1,

  output wire [31:0] result
);

  assign result = ShiftSrc ? input1 : input0;

endmodule 