module MuxRegDst (
  input  wire [1:0]  RegDst,
  input  wire [4:0] input_rt,
  input  wire [4:0] input_rd,
  output wire [4:0] result
);

  wire [4:0] aux0, aux1;

  assign aux0 = RegDst[0] ? input_rd : input_rt;
  assign aux1 = RegDst[0] ? 5'd31 : 5'd29;
  assign result = RegDst[1] ? aux1 : aux0;

endmodule 
