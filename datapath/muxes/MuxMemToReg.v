module MuxMemToReg (
  input  wire [2:0]  mem_to_reg,
  input  wire [31:0] alu_out_output,
  input  wire [31:0] load_size_output,
  input  wire [31:0] hi_output,
  input  wire [31:0] lo_output,
  input  wire [31:0] shift_left_16,
  input  wire [31:0] bit_extend,
  input  wire [31:0] shift_out,
  output  reg [31:0] mux_mem_to_reg_output
);

always @(*) begin
  case (mem_to_reg)
    0: mux_mem_to_reg_output = alu_out_output;
    1: mux_mem_to_reg_output = load_size_output;
    2: mux_mem_to_reg_output = hi_output;
    3: mux_mem_to_reg_output = lo_output;
    4: mux_mem_to_reg_output = shift_left_16;
    5: mux_mem_to_reg_output = bit_extend;
    6: mux_mem_to_reg_output = shift_out;
  endcase
end

endmodule