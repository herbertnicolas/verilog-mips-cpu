module MuxPCSource (
  input wire [2:0]  pc_source,
  input wire [31:0] alu_result,
  input wire [31:0] alu_out_output,
  input wire [31:0] jump_address,
  input wire [31:0] epc_output,
  input wire [31:0] exception_address,
  output reg [31:0] mux_pc_source_output
);

always @(*) begin
  case (pc_source)
    0: mux_pc_source_output = alu_result;
    1: mux_pc_source_output = alu_out_output;
    2: mux_pc_source_output = jump_address;
    3: mux_pc_source_output = epc_output;
    4: mux_pc_source_output = exception_address;
  endcase
end

endmodule