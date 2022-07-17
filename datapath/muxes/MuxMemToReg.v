module MuxMemToReg (
  input  wire [2:0]  MemToReg,
  input  wire [31:0] input0,
  input  wire [31:0] input1,
  input  wire [31:0] input2,
  input  wire [31:0] input3,
  input  wire [31:0] input4,
  input  wire [31:0] input5,
  input  wire [31:0] input7,

  output wire [31:0] result
);

  wire [31:0] aux00x, aux01x, aux10x, aux11x, aux0xx, aux1xx;

  assign aux00x = MemToReg[0] ? input1 : input0;
  assign aux01x = MemToReg[0] ? input3 : input2;
  assign aux10x = MemToReg[0] ? input5 : input4;
  assign aux11x = MemToReg[0] ? input7 : 32'd227;

  assign aux0xx = MemToReg[1] ? aux01x : aux00x;
  assign aux1xx = MemToReg[1] ? aux11x : aux10x;

  assign result = MemToReg[2] ? aux1xx : aux0xx;

endmodule