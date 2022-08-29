module MuxDivOrMult (
  input  wire        div_or_mult,
  input  wire [31:0] div,
  input  wire [31:0] mult,
  output wire [31:0] result
);

  assign result = div_or_mult ? mult : div;

endmodule