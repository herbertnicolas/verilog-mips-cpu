module MuxMultOrDiv(
  input  wire        MultOrDiv,
  input  wire [31:0] input0,
  input  wire [31:0] input1,
  
  output wire [31:0] result
);

  assign result = MultOrDiv ? input1 : input0;

endmodule