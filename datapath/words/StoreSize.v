module StoreSize (
  input  wire [1:0]  StoreSizeCtrl,
  input  wire [31:0] data_in_0,  // MDR_out
  input  wire [31:0] data_in_1,  // B_out
  output wire [31:0] data_out
);
  wire [31:0] aux;

  assign aux      = StoreSizeCtrl[0] ? {data_in_0[31:8], data_in_1[7:0]}   : data_in_1;

  assign data_out = StoreSizeCtrl[1] ? {data_in_0[31:16], data_in_1[15:0]} : aux;

endmodule