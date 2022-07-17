module MuxIorD (
  input wire [1:0]  i_or_d,
  input wire [31:0] input_0,
  input wire [31:0] input_1,
  input wire [31:0] input_2,
  input wire [31:0] input_3,
  output reg [7:0] result
);

reg [31:0] aux;

always @(*) begin
    case (i_or_d)
      0: aux = input_0;
      1: aux = input_1;
      2: aux = input_2;
      3: aux = input_3;
    endcase
    result = aux[7:0];
end

endmodule