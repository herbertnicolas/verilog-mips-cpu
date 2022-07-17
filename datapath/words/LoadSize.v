module LoadSize (
  input  wire [1:0] LoadSizeCtrl,
  input  wire [31:0] data_in,
  output wire [31:0] data_out
);

  wire [31:0] aux;
  assign aux = LoadSizeCtrl[0] ? {{24{1'b0}}, data_in[7:0]} : data_in;
  assign data_out = LoadSizeCtrl[1] ? {{16{1'b0}}, data_in[15:0]} : aux;

endmodule