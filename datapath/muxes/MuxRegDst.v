module MuxRegDst (
  input  wire [1:0] reg_dst,
  input  wire [4:0] rt,
  input  wire [4:0] rd,
  output  reg [4:0] mux_reg_dst_output
);

always @(*) begin
  case (reg_dst)
    0: mux_reg_dst_output = rt;
    1: mux_reg_dst_output = rd;
    2: mux_reg_dst_output = 5'd29;
    3: mux_reg_dst_output = 5'd31;
  endcase
end

endmodule
