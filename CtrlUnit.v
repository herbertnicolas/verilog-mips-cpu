module CtrlUnit (
    input wire       clock,
    input wire       reset,
    input wire [5:0] opcode,
    input wire [5:0] funct,
    input wire       greater_than,
    input wire       equal_to,
    input wire       overflow,
    input wire       div_zero,
    output reg [2:0] alu_ctrl,
    output reg       mem_read,
    output reg       mem_write,
    output reg       ir_write,
    output reg       reg_write,
    output reg [1:0] shift_ctrl,
    output reg       pc_write,
    output reg       epc_write,
    output reg       write_a,
    output reg       write_b,
    output reg       alu_out_write,
    output reg       mdr_write,
    output reg       write_aux_a,
    output reg       hi_write,
    output reg       lo_write,
    output reg       mult_start,
    output reg       div_start,
    output reg [1:0] load_size_ctrl,
    output reg [1:0] store_size_ctrl,
    output reg [1:0] i_or_d,
    output reg [1:0] reg_dst,
    output reg [2:0] mem_to_reg,
    output reg [1:0] alu_src_a,
    output reg [2:0] alu_src_b,
    output reg [2:0] pc_source,
    output reg       shift_src_ctrl,
    output reg [1:0] shift_amt_ctrl,
    output reg       mult_or_div,
    output reg [1:0] exception
);

reg [6:0] state;
reg [2:0] counter;

// states
parameter STATE_FETCH = 7'd0;
parameter STATE_IR_PC = 7'd1;
parameter STATE_DECODE = 7'd2;
parameter STATE_INVALID = 7'd3;
parameter STATE_AND = 7'd4;
parameter STATE_RD_WRITE_ALU_OUT_OVERFLOW_OFF = 7'd5;
parameter STATE_ADD = 7'd6;
parameter STATE_SUB = 7'd7;
parameter STATE_RD_WRITE_ALU_OUT_OVERFLOW_ON = 7'd8;
parameter STATE_EXCEPTION = 7'd9;
parameter STATE_ADDIU = 7'd10;

// opcodes
parameter OPCODE_R = 6'h0;
parameter OPCODE_ADDIU = 6'h9;

// functs
parameter FUNCT_AND = 6'h24;
parameter FUNCT_ADD = 6'h20;
parameter FUNCT_SUB = 6'h20;

// alu_ctrl
parameter ALU_LOAD_A = 3'b000;
parameter ALU_ADD    = 3'b001;
parameter ALU_SUB    = 3'b010;
parameter ALU_AND    = 3'b011;
parameter ALU_LOAD_B = 3'b111;

// exceptions
parameter EXCEPTION_INVALID = 2'd0;
parameter EXCEPTION_OVERFLOW = 2'd1;
parameter EXCEPTION_DIV_ZERO = 2'd2;


/*
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
*/

always @(negedge clock) begin
    if (reset) begin
        state           <= 0;
        counter         <= 0;
        mem_read        <= 0;
        mem_write       <= 0;
        ir_write        <= 0;
        reg_write       <= 0;
        pc_write        <= 0;
        epc_write       <= 0;
        write_a         <= 0;
        write_b         <= 0;
        alu_out_write   <= 0;
        mdr_write       <= 0;
        write_aux_a     <= 0;
        hi_write        <= 0;
        lo_write        <= 0;
        mult_start      <= 0;
        div_start       <= 0;
        shift_ctrl      <= 0;
        load_size_ctrl  <= 0;
        store_size_ctrl <= 0;
        i_or_d          <= 0;
        reg_dst         <= 0;
        mem_to_reg      <= 0;
        alu_src_a       <= 0;
        alu_src_b       <= 0;
        pc_source       <= 0;
        shift_src_ctrl  <= 0;
        shift_amt_ctrl  <= 0;
        mult_or_div     <= 0;
        exception       <= 0;
    end else begin
        case (state)
            STATE_FETCH: begin
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                mem_read <= 1;
                //-----------------//
                // TODO asynchronous control signals
                i_or_d <= 0;
                //-----------------//
                state <= STATE_IR_PC;
            end
            STATE_IR_PC: begin
                mem_read        <= 0;
                mem_write       <= 0;
                
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                ir_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                pc_source <= 3;
                alu_src_a <= 0;
                alu_src_b <= 1;
                alu_ctrl <= ALU_ADD;
                //-----------------//
                state <= STATE_DECODE;
            end
            STATE_DECODE: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                

                
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                write_a <= 1;
                write_b <= 1;
                alu_out_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 0;
                alu_src_b <= 3;
                alu_ctrl <= ALU_ADD;
                //-----------------//
                case (opcode)
                    OPCODE_R: begin
                        case (funct)
                            FUNCT_AND: begin
                                state <= STATE_AND;
                            end
                            FUNCT_ADD: begin
                                state <= STATE_ADD;
                            end
                            FUNCT_SUB: begin
                                state <= STATE_SUB;
                            end
                            default: begin
                                state <= STATE_INVALID;
                            end
                        endcase
                    end
                    OPCODE_ADDIU: begin
                        state <= STATE_ADDIU;
                    end
                    default: begin
                        state <= STATE_INVALID;
                    end
                endcase
            end
            STATE_AND: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                alu_src_b <= 0;
                alu_ctrl <= ALU_AND;
                alu_out_write <= 1;
                //-----------------//
                state <= STATE_RD_WRITE_ALU_OUT_OVERFLOW_OFF;
            end
            STATE_ADDIU: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                alu_src_b <= 2;
                alu_ctrl <= ALU_ADD;
                alu_out_write <= 1;
                //-----------------//
                state <= STATE_RD_WRITE_ALU_OUT_OVERFLOW_OFF;
            end
            STATE_RD_WRITE_ALU_OUT_OVERFLOW_OFF: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                reg_write       <= 1;
                //-----------------//
                // TODO asynchronous control signals
                mem_to_reg <= 0;
                reg_dst <= 1;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_ADD: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                alu_src_b <= 0;
                alu_ctrl <= ALU_ADD;
                alu_out_write <= 1;
                //-----------------//
                state <= STATE_RD_WRITE_ALU_OUT_OVERFLOW_ON;
            end
            STATE_SUB: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                alu_src_b <= 0;
                alu_ctrl <= ALU_SUB;
                alu_out_write <= 1;
                //-----------------//
                state <= STATE_RD_WRITE_ALU_OUT_OVERFLOW_ON;
            end
            STATE_RD_WRITE_ALU_OUT_OVERFLOW_ON: begin
                if (overflow) begin
                    
                    mem_write       <= 0;
                    ir_write        <= 0;
                    reg_write       <= 0;
                    pc_write        <= 0;
                    
                    write_a         <= 0;
                    write_b         <= 0;
                    alu_out_write   <= 0;
                    mdr_write       <= 0;
                    write_aux_a     <= 0;
                    hi_write        <= 0;
                    lo_write        <= 0;
                    mult_start      <= 0;
                    div_start       <= 0;
                    //-----------------//
                    // TODO synchronous control signals
                    mem_read        <= 1;
                    epc_write       <= 1;
                    //-----------------//
                    // TODO asynchronous control signals
                    i_or_d <= 2;
                    alu_ctrl <= ALU_SUB;
                    alu_src_a <= 0;
                    alu_src_b <= 1;
                    exception <= EXCEPTION_OVERFLOW;
                    //-----------------//
                    state <= STATE_EXCEPTION;
                end else begin
                    mem_read        <= 0;
                    mem_write       <= 0;
                    ir_write        <= 0;
                    
                    pc_write        <= 0;
                    epc_write       <= 0;
                    write_a         <= 0;
                    write_b         <= 0;
                    alu_out_write   <= 0;
                    mdr_write       <= 0;
                    write_aux_a     <= 0;
                    hi_write        <= 0;
                    lo_write        <= 0;
                    mult_start      <= 0;
                    div_start       <= 0;
                    //-----------------//
                    // TODO synchronous control signals
                    reg_write       <= 1;
                    //-----------------//
                    // TODO asynchronous control signals
                    mem_to_reg <= 0;
                    reg_dst <= 1;
                    //-----------------//
                    state <= STATE_FETCH;
                end
            end
            STATE_INVALID: begin
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                mem_read        <= 1;
                epc_write       <= 1;
                //-----------------//
                // TODO asynchronous control signals
                i_or_d <= 2;
                alu_ctrl <= ALU_SUB;
                alu_src_a <= 0;
                alu_src_b <= 1;
                exception <= EXCEPTION_INVALID;
                //-----------------//
                state <= STATE_EXCEPTION;
            end
            STATE_EXCEPTION: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                write_aux_a     <= 0;
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                pc_source <= 4;
                //-----------------//
                state <= STATE_FETCH;
            end
        endcase
    end
end

endmodule