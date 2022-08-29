module MuxStackPointer (
  input  wire       stack_pointer_ctrl,
  input  wire [4:0] rs,
  output wire [4:0] mux_stack_pointer_output
);

  assign mux_stack_pointer_output = stack_pointer_ctrl ? 5'd29 : rs;

endmodule