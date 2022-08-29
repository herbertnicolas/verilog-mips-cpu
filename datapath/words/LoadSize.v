module LoadSize (
  input  wire [1:0]  load_size_ctrl,
  input  wire [31:0] mdr_output,
  output  reg [31:0] load_size_output
);

always @(*) begin
  case (load_size_ctrl)
    0: load_size_output = mdr_output;
    1: load_size_output = {24'b0, mdr_output[31:24]};
    2: load_size_output = {16'b0, mdr_output[31:16]};
  endcase
end

endmodule