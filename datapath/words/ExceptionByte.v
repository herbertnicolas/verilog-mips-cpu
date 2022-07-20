module ExceptionByte (
    input wire [1:0]  exception,
    input wire [31:0] mem_data,
    output reg [31:0] exception_address
);

always @(*) begin
    case (exception)
        0: exception_address = {{24{1'b0}}, mem_data[23:16]}; 
        1: exception_address = {{24{1'b0}}, mem_data[15:8]};
        2: exception_address = {{24{1'b0}}, mem_data[7:0]};
    endcase
end

endmodule