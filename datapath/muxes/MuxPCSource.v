module MuxPCSource (
  input  wire [2:0]  PCSource,
  input  wire [31:0] input0,
  input  wire [31:0] input1,
  input  wire [31:0] input2,
  input  wire [31:0] input3,
  input  wire [31:0] input4,

  output wire [31:0] result
);

  wire [31:0] aux00x, aux01x, aux0xx;

  assign aux00x = PCSource[0] ? input1 : input0;
  assign aux01x = PCSource[0] ? input3 : input2;

  assign aux0xx = PCSource[1] ? aux01x : aux00x;

  assign result = PCSource[2] ? input4 : aux0xx;

endmodule