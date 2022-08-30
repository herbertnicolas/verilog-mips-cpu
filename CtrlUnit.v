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
    output reg       alu_src_a,
    output reg [1:0] alu_src_b,
    output reg [2:0] pc_source,
    output reg       shift_src_ctrl,
    output reg       shift_amt_ctrl,
    output reg       div_or_mult,
    output reg [1:0] exception,
    output reg       stack_pointer_ctrl
);

reg [6:0] state;

// states
parameter STATE_FETCH = 7'd0;
parameter STATE_IR_PC = 7'd1;
parameter STATE_DECODE = 7'd2;
parameter STATE_OVERFLOW_RD = 7'd3;
parameter STATE_AND = 7'd4;
parameter STATE_RD_WRITE_ALU_OUT = 7'd5;
parameter STATE_ADD = 7'd6;
parameter STATE_SUB = 7'd7;
parameter STATE_EPC_WRITE = 7'd8;
parameter STATE_PC_EXCEPTION = 7'd9;
parameter STATE_ADDIU = 7'd10;
parameter STATE_RT_WRITE_ALU_OUT = 7'd11;
parameter STATE_ADDI = 7'd12;
parameter STATE_OVERFLOW_RT = 7'd13;
parameter STATE_BREAK = 7'd14;
parameter STATE_RTE = 7'd15;
parameter STATE_JR = 7'd16;
parameter STATE_SLT = 7'd17;
parameter STATE_SLTI = 7'd18;
parameter STATE_LUI = 7'd19;
parameter STATE_BRANCH_COMPARISON = 7'd20;
parameter STATE_BEQ = 7'd21;
parameter STATE_BNE = 7'd22;
parameter STATE_BLE = 7'd23;
parameter STATE_BGT = 7'd24;
parameter STATE_BRANCH_PC = 7'd25;
parameter STATE_J = 7'd26;
parameter STATE_ALU_PC = 7'd27;
parameter STATE_JAL = 7'd28;
parameter STATE_SLL = 7'd29;
parameter STATE_SRL = 7'd30;
parameter STATE_SRA = 7'd31;
parameter STATE_SLLV = 7'd31;
parameter STATE_SRAV = 7'd32;
parameter STATE_SHIFT_TO_REG = 7'd33;
parameter STATE_LOAD_ALU_RESULT = 7'd34;
parameter STATE_LOAD_SIZE = 7'd35;
parameter STATE_STORE_ADDRESS_ALU_OUT = 7'd36;
parameter STATE_LOAD_ALU_OUT = 7'd37;
parameter STATE_STORE_SIZE = 7'd38;

// opcodes
parameter OPCODE_R = 6'h0;
parameter OPCODE_ADDI = 6'h8;
parameter OPCODE_ADDIU = 6'h9;
parameter OPCODE_SLTI = 6'ha;
parameter OPCODE_LUI = 6'hf;
parameter OPCODE_BEQ = 6'h4;
parameter OPCODE_BNE = 6'h5;
parameter OPCODE_BLE = 6'h6;
parameter OPCODE_BGT = 6'h7;
parameter OPCODE_J = 6'h2;
parameter OPCODE_JAL = 6'h3;
parameter OPCODE_LW = 6'h23;
parameter OPCODE_LB = 6'h20;
parameter OPCODE_LH = 6'h21;
parameter OPCODE_SW = 6'h2b;
parameter OPCODE_SB = 6'h28;
parameter OPCODE_SH = 6'h29;

// functs
parameter FUNCT_AND = 6'h24;
parameter FUNCT_ADD = 6'h20;
parameter FUNCT_SUB = 6'h22;
parameter FUNCT_BREAK = 6'hd;
parameter FUNCT_RTE = 6'h13;
parameter FUNCT_JR = 6'h8;
parameter FUNCT_SLT = 6'h2a;
parameter FUNCT_SLL = 6'h0;
parameter FUNCT_SLLV = 6'h4;
parameter FUNCT_SRA = 6'h3;
parameter FUNCT_SRAV = 6'h7;
parameter FUNCT_SRL = 6'h2;

// alu_ctrl
parameter ALU_LOAD_A = 3'b000;
parameter ALU_ADD    = 3'b001;
parameter ALU_SUB    = 3'b010;
parameter ALU_AND    = 3'b011;
parameter ALU_LOAD_B = 3'b111;

// shift_ctrl
parameter SHIFT_SLL = 2'b00;
parameter SHIFT_SRL = 2'b01;
parameter SHIFT_SRA = 2'b10;

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
        div_or_mult     <= 0;
        exception       <= 0;
        stack_pointer_ctrl <= 0;
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
                pc_source <= 0;
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
                stack_pointer_ctrl <= 0;
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
                            FUNCT_BREAK: begin
                                state <= STATE_BREAK;
                            end
                            FUNCT_RTE: begin
                                state <= STATE_RTE;
                            end
                            FUNCT_JR: begin
                                state <= STATE_JR;
                            end
                            FUNCT_SLT: begin
                                state <= STATE_SLT;
                            end
                            FUNCT_SLL: begin
                                state <= STATE_SLL;
                            end
                            FUNCT_SLLV: begin
                                state <= STATE_SLLV;
                            end
                            FUNCT_SRA: begin
                                state <= STATE_SRA;
                            end
                            FUNCT_SRAV: begin
                                state <= STATE_SRAV;
                            end
                            FUNCT_SRL: begin
                                state <= STATE_SRL;
                            end
                            default: begin
                                state <= STATE_EPC_WRITE;
                                exception <= EXCEPTION_INVALID;
                            end
                        endcase
                    end
                    OPCODE_ADDIU: begin
                        state <= STATE_ADDIU;
                    end
                    OPCODE_ADDI: begin
                        state <= STATE_ADDI;
                    end
                    OPCODE_LUI: begin
                        state <= STATE_LUI;
                    end
                    OPCODE_SLTI: begin
                        state <= STATE_SLTI;
                    end
                    OPCODE_BEQ: begin
                        state <= STATE_BRANCH_COMPARISON;
                    end
                    OPCODE_BNE: begin
                        state <= STATE_BRANCH_COMPARISON;
                    end
                    OPCODE_BLE: begin
                        state <= STATE_BRANCH_COMPARISON;
                    end
                    OPCODE_BGT: begin
                        state <= STATE_BRANCH_COMPARISON;
                    end
                    OPCODE_J: begin
                        state <= STATE_J;
                    end
                    OPCODE_JAL: begin
                        state <= STATE_ALU_PC;
                    end
                    OPCODE_LW: begin
                        state <= STATE_LOAD_ALU_RESULT;
                    end
                    OPCODE_LB: begin
                        state <= STATE_LOAD_ALU_RESULT;
                    end
                    OPCODE_LH: begin
                        state <= STATE_LOAD_ALU_RESULT;
                    end
                    OPCODE_SW: begin
                        state <= STATE_STORE_ADDRESS_ALU_OUT;
                    end
                    OPCODE_SB: begin
                        state <= STATE_STORE_ADDRESS_ALU_OUT;
                    end
                    OPCODE_SH: begin
                        state <= STATE_STORE_ADDRESS_ALU_OUT;
                    end
                    default: begin
                        state <= STATE_EPC_WRITE;
                        exception <= EXCEPTION_INVALID;
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
                state <= STATE_RD_WRITE_ALU_OUT;
            end
            STATE_RD_WRITE_ALU_OUT: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
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
                state = STATE_OVERFLOW_RD;
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
                state <= STATE_OVERFLOW_RD;
            end
            STATE_OVERFLOW_RD: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
                if (overflow) begin
                    state <= STATE_EPC_WRITE;
                    exception <= EXCEPTION_OVERFLOW;
                end else begin
                    state <= STATE_RD_WRITE_ALU_OUT;
                end
            end
            STATE_EPC_WRITE: begin
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
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
                //-----------------//
                state <= STATE_PC_EXCEPTION;
            end
            STATE_PC_EXCEPTION: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
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
                state <= STATE_RT_WRITE_ALU_OUT;
            end
            STATE_RT_WRITE_ALU_OUT: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
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
                reg_dst <= 0;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_ADDI: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                
                mdr_write       <= 0;
                
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
                state <= STATE_OVERFLOW_RT;
            end
            STATE_OVERFLOW_RT: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
                if (overflow) begin
                    state <= STATE_EPC_WRITE;
                    exception <= EXCEPTION_OVERFLOW;
                end else begin
                    state <= STATE_RT_WRITE_ALU_OUT;
                end
            end
            STATE_BREAK: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 0;
                alu_src_b <= 1;
                pc_source <= 0;
                alu_ctrl <= ALU_SUB;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_RTE: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                pc_source <= 3;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_JR: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                pc_source <= 0;
                alu_ctrl <= ALU_LOAD_A;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_SLT: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                reg_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                mem_to_reg <= 5;
                alu_src_a <= 1;
                alu_src_b <= 0;
                reg_dst <= 1;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_SLTI: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                reg_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                mem_to_reg <= 5;
                alu_src_a <= 1;
                alu_src_b <= 2;
                reg_dst <= 0;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_LUI: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                reg_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                reg_dst <= 0;
                mem_to_reg <= 4;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_BRANCH_COMPARISON: begin
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
                //-----------------//
                case (opcode)
                    OPCODE_BEQ: begin
                        state <= STATE_BEQ;
                    end
                    OPCODE_BNE: begin
                        state <= STATE_BNE;
                    end
                    OPCODE_BLE: begin
                        state <= STATE_BLE;
                    end
                    OPCODE_BGT: begin
                        state <= STATE_BGT;
                    end
                endcase
            end
            STATE_BEQ: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
                if (equal_to) begin
                    state <= STATE_BRANCH_PC;
                end else begin
                    state <= STATE_FETCH;
                end
            end
            STATE_BNE: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
                if (equal_to) begin
                    state <= STATE_FETCH;
                end else begin
                    state <= STATE_BRANCH_PC;
                end
            end
            STATE_BLE: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
                if (greater_than) begin
                    state <= STATE_FETCH;
                end else begin
                    state <= STATE_BRANCH_PC;
                end
            end
            STATE_BGT: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                //-----------------//
                if (greater_than) begin
                    state <= STATE_BRANCH_PC;
                end else begin
                    state <= STATE_FETCH;
                end
            end
            STATE_BRANCH_PC: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                pc_source <= 1;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_J: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                pc_source <= 2;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_ALU_PC: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;

                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                alu_out_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 0;
                alu_ctrl <= ALU_LOAD_A;
                //-----------------//
                state <= STATE_JAL;
            end
            STATE_JAL: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                pc_write <= 1;
                reg_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                pc_source <= 2;
                mem_to_reg <= 0;
                reg_dst <= 3;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_SLL: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                shift_ctrl <= SHIFT_SLL;
                shift_amt_ctrl <= 0;
                shift_src_ctrl <= 0;
                //-----------------//
                state <= STATE_SHIFT_TO_REG;
            end
            STATE_SRA: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                shift_ctrl <= SHIFT_SRA;
                shift_amt_ctrl <= 0;
                shift_src_ctrl <= 0;
                //-----------------//
                state <= STATE_SHIFT_TO_REG;
            end
            STATE_SRL: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                shift_ctrl <= SHIFT_SRL;
                shift_amt_ctrl <= 0;
                shift_src_ctrl <= 0;
                //-----------------//
                state <= STATE_SHIFT_TO_REG;
            end
            STATE_SRAV: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                shift_ctrl <= SHIFT_SRA;
                shift_amt_ctrl <= 1;
                shift_src_ctrl <= 1;
                //-----------------//
                state <= STATE_SHIFT_TO_REG;
            end
            STATE_SLLV: begin
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
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                //-----------------//
                // TODO asynchronous control signals
                shift_ctrl <= SHIFT_SLL;
                shift_amt_ctrl <= 1;
                shift_src_ctrl <= 1;
                //-----------------//
                state <= STATE_SHIFT_TO_REG;
            end
            STATE_SHIFT_TO_REG: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                reg_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                reg_dst <= 1;
                mem_to_reg <= 6;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_LOAD_ALU_RESULT: begin

                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                mem_read <= 1;
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                alu_src_b <= 3;
                alu_ctrl <= ALU_ADD;
                i_or_d <= 3;
                case (OPCODE)
                    OPCODE_LW: begin
                        load_size_ctrl <= 0;
                    end
                    OPCODE_LB: begin
                        load_size_ctrl <= 1;
                    end
                    OPCODE_LH: begin
                        load_size_ctrl <= 2;
                    end
                endcase
                //-----------------//
                state <= STATE_LOAD_SIZE;
            end
            STATE_LOAD_SIZE: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                reg_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                mem_to_reg <= 1;
                reg_dst <= 0;
                //-----------------//
                state <= STATE_FETCH;
            end
            STATE_STORE_ADDRESS_ALU_OUT: begin
                mem_read        <= 0;
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                alu_out_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                alu_src_a <= 1;
                alu_src_b <= 3;
                alu_ctrl <= ALU_ADD;
                //-----------------//
                state <= STATE_LOAD_ALU_OUT;
            end
            STATE_LOAD_ALU_OUT: begin
                
                mem_write       <= 0;
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                mem_read <= 1;
                mdr_write <= 1;
                //-----------------//
                // TODO asynchronous control signals
                i_or_d <= 1;
                case (OPCODE)
                    OPCODE_SW: begin
                        store_size_ctrl <= 0;
                    end
                    OPCODE_SB: begin
                        store_size_ctrl <= 1;
                    end
                    OPCODE_SH: begin
                        store_size_ctrl <= 2;
                    end
                endcase
                //-----------------//
                state <= STATE_STORE_SIZE;
            end
            STATE_STORE_SIZE: begin
                mem_read        <= 0;
                
                ir_write        <= 0;
                reg_write       <= 0;
                pc_write        <= 0;
                epc_write       <= 0;
                write_a         <= 0;
                write_b         <= 0;
                alu_out_write   <= 0;
                mdr_write       <= 0;
                
                hi_write        <= 0;
                lo_write        <= 0;
                mult_start      <= 0;
                div_start       <= 0;
                //-----------------//
                // TODO synchronous control signals
                mem_write       <= 1;
                //-----------------//
                // TODO asynchronous control signals
                i_or_d <= 1;
                //-----------------//
                state <= STATE_FETCH;
            end
        endcase
    end
end

endmodule