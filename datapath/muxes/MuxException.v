module MuxException (
  input  wire [1:0]  Exception,
  output wire [31:0] result
);

  wire [31:0] aux;

  assign aux    = Exception[0] ? 32'd254 : 32'd253;
  assign result = Exception[1] ? 32'd255 : aux;

endmodule