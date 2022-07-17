module MuxALUSrcA (
  input  wire [1:0]  ALUSrcA,
  input  wire [31:0] input0,
  input  wire [31:0] input1,
  input  wire [31:0] input2,
  input  wire [31:0] input3,
  output wire [31:0] result
);

  wire [31:0] aux0, aux1;
  assign aux0 = ALUSrcA[0] ? input1 : input0;
  assign aux1 = ALUSrcA[0] ? input3 : input2;
  assign result = ALUSrcA[1] ? aux1 : aux0;
endmodule