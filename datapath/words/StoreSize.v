module StoreSize (
  input  wire [1:0]  store_size_ctrl,
  input  wire [31:0] b_output,
  input  wire [31:0] mdr_output,
  output  reg [31:0] store_size_output
);

always @(*) begin
  case (store_size_ctrl)
    0: store_size_output = b_output;
    1: store_size_output = {b_output[7:0], mdr_output[23:0]};
    2: store_size_output = {b_output[15:0], mdr_output[15:0]};
  endcase
end

endmodule