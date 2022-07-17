module MuxALUSrcB (
  input  wire [2:0]  ALUSrcB,
  input  wire [31:0] input0,
  input  wire [31:0] input2,
  input  wire [31:0] input3,
  input  wire [31:0] input4,

  output wire [31:0] result
);

  wire [31:0] aux0, aux1, aux2;

  assign aux0  = ALUSrcB[0] ? 32'd4 : input0;
  assign aux1  = ALUSrcB[0] ? input3 : input2;
  assign aux2  = ALUSrcB[1] ? aux1 : aux0;
  assign result = ALUSrcB[2] ? input4 : aux2;

endmodule