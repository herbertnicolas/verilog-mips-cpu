`include "CtrlUnit.v"
`include "datapath/ALU.v"
`include "datapath/Memory.v"
`include "datapath/IR.v"
`include "datapath/Registers.v"
`include "datapath/Shift.v"
`include "datapath/Register.v"
`include "datapath/Mult.v"
`include "datapath/Div.v"
`include "datapath/words/LoadSize.v"
`include "datapath/words/StoreSize.v"
`include "datapath/words/ExceptionByte.v"
`include "datapath/muxes/MuxIorD.v"
`include "datapath/muxes/MuxRegDst.v"
`include "datapath/muxes/MuxMemToReg.v"
`include "datapath/muxes/MuxPCSource.v"
`include "datapath/muxes/MuxALUSrcA.v"
`include "datapath/muxes/MuxALUSrcB.v"
`include "datapath/muxes/MuxShiftSrc.v"
`include "datapath/muxes/MuxShiftAmt.v"
`include "datapath/muxes/MuxDivOrMult.v"
`include "datapath/muxes/MuxStackPointer.v"

module CPU (
    input wire clock,
    input wire reset
);

/* OUTPUTS */

    /* CTRL UNIT */

        wire [2:0] alu_ctrl;

        // Memory
        wire       mem_read;
        wire       mem_write;
        // IR
        wire       ir_write;
        // Registers
        wire       reg_write;
        // ShiftReg
        wire [1:0] shift_ctrl;
        // PC
        wire       pc_write;
        // EPC
        wire       epc_write;
        // A, B
        wire       write_a;
        wire       write_b;
        // ALUOut
        wire       alu_out_write;
        // MDR
        wire       mdr_write;
        // HI, LO
        wire       hi_write;
        wire       lo_write;
        // Mult, Div
        wire       mult_start;
        wire       div_start;
        wire       mult_finished;
        wire       div_finished;
        // Sizes
        wire [1:0] load_size_ctrl;
        wire [1:0] store_size_ctrl;
        // Muxes
        wire [1:0] i_or_d;
        wire [1:0] reg_dst;
        wire [2:0] mem_to_reg;
        wire       alu_src_a;
        wire [1:0] alu_src_b;
        wire [2:0] pc_source;
        wire       shift_src_ctrl;
        wire       shift_amt_ctrl;
        wire       div_or_mult;
        wire [1:0] exception;
        wire       stack_pointer_ctrl;

    /* ALU */
    wire [31:0] alu_result;
    wire greater_than;
    wire equal_to;
    wire overflow;
    
    wire negative; // irrelevante pra unidade de controle
    wire zero;     // irrelevante pra unidade de controle
    wire less_than;       // irrelevante pra unidade de controle

    /* Memory */
    wire [31:0] mem_data;

    /* IR */
    wire  [5:0]  opcode;
    wire  [4:0]  rs;
    wire  [4:0]  rt;
    wire [15:0] address_immediate;

    wire  [4:0] rd;
    wire  [4:0] shamt;
    wire  [5:0] funct;
    wire [25:0] offset;
    assign rd = address_immediate[15:11];
    assign shamt = address_immediate[10:6];
    assign funct = address_immediate[5:0];
    assign offset = {rs, rt, address_immediate};

    /* Banco de Registeres */
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;

    /* ShiftReg */
    wire [31:0] shift_out;

    /* Registers */
    wire [31:0] pc_output;
    wire [31:0] epc_output;
    wire [31:0] a_output;
    wire [31:0] b_output;
    wire [31:0] alu_out_output;
    wire [31:0] mdr_output;
    wire [31:0] hi_output;
    wire [31:0] lo_output;

    /* Mult, Div */
    wire [31:0] mult_hi;
    wire [31:0] mult_lo;
    wire [31:0] div_hi;
    wire [31:0] div_lo;

    wire        div_zero;
    
    /* Words */
    wire [31:0] store_size_output;
    wire [31:0] load_size_output;
    wire [31:0] exception_address;

    /* MUXS */
    wire [7:0] mux_i_or_d_output;
    wire [4:0]  mux_reg_dst_output;
    wire [31:0] mux_mem_to_reg_output;
    wire [31:0] mux_alu_src_a_output;
    wire [31:0] mux_alu_src_b_output;
    wire [31:0] mux_pc_source_output;
    wire [31:0] mux_shift_src_output;
    wire [4:0]  mux_shift_amt_output;
    wire [31:0] mux_hi_output;
    wire [31:0] mux_lo_output;
    wire [31:0] mux_exception_output;
    wire [4:0]  mux_stack_pointer_output;
    
    /* Extends */
    wire [31:0] bit_extend;
    assign bit_extend = {31'b0, less_than};

    wire [31:0] sign_extend;
    assign sign_extend = {{16{address_immediate[15]}}, address_immediate};

    /* Shifts */
    wire [31:0] shift_left_16;
    assign shift_left_16 = address_immediate << 16;
    
    wire [31:0] address;
    assign address = {sign_extend[29:0], 2'b0};
    
    wire [31:0] jump_address;
    assign jump_address = {pc_output[31:28], offset << 2};

/* CTRL UNIT */

    CtrlUnit CtrlUnit_ (
        clock,
        reset,
        opcode,
        funct,
        greater_than,
        equal_to,
        overflow,
        mult_finished,
        div_finished,
        div_zero,
        alu_ctrl,
        mem_read,
        mem_write,
        ir_write,
        reg_write,
        shift_ctrl,
        pc_write,
        epc_write,
        write_a,
        write_b,
        alu_out_write,
        mdr_write,
        write_aux_a,
        hi_write,
        lo_write,
        mult_start,
        div_start,
        load_size_ctrl,
        store_size_ctrl,
        i_or_d,
        reg_dst,
        mem_to_reg,
        alu_src_a,
        alu_src_b,
        pc_source,
        shift_src_ctrl,
        shift_amt_ctrl,
        div_or_mult,
        exception,
        stack_pointer_ctrl
    );

/* PARTS GIVEN */

    ALU ALU_ (
        mux_alu_src_a_output,
        mux_alu_src_b_output,
        alu_ctrl,
        alu_result,
        zero,
        negative,
        overflow,
        equal_to,
        less_than,
        greater_than
    );

    Memory Memory_ (
        clock,
        mem_read,
        mem_write,
        mux_i_or_d_output,  // TODO mux iord output 8 bits
        store_size_output,
        mem_data
    );

    IR IR_ (
        clock,
        reset,
        ir_write,
        mem_data,
        opcode,
        rs,
        rt,
        address_immediate
    );

    Registers Registers_ (
        clock,
        reset,
        reg_write,
        mux_stack_pointer_output,
        rt,
        mux_reg_dst_output,
        mux_mem_to_reg_output,
        read_data_1,
        read_data_2
    );

    Shift Shift_ (
        clock,
        reset,
        shift_ctrl,
        mux_shift_amt_output,
        mux_shift_src_output,
        shift_out
    );

/* REGISTERS */

    Register PC_ (
        clock,
        reset,
        pc_write,
        mux_pc_source_output,
        pc_output
    );

    Register EPC_ (
        clock,
        reset,
        epc_write,
        alu_result,
        epc_output
    );

    Register A_ (
        clock,
        reset,
        write_a,
        read_data_1,
        a_output
    );

    Register B_ (
        clock,
        reset,
        write_b,
        read_data_2,
        b_output
    );

    Register ALUOut_ (
        clock,
        reset,
        alu_out_write,
        alu_result,
        alu_out_output
    );

    Register MDR_ (
        clock,
        reset,
        mdr_write,
        mem_data,
        mdr_output
    );

    Register HI_ (
        clock,
        reset,
        hi_write,
        mux_hi_output,
        hi_output
    );

    Register LO_(
        clock,
        reset,
        lo_write,
        mux_lo_output,
        lo_output
    );

/* MULT, DIV */

    Mult Mult_ (
        clock,
        reset,
        mult_start,
        a_output,
        b_output,
        mult_finished,
        mult_hi,
        mult_lo
    );

    Div Div_ (
        clock,
        reset,
        div_start,
        a_output,
        b_output,
        div_zero,
        div_finished,
        div_lo,
        div_hi
    );

/* WORDS */

    LoadSize LoadSize_ (
        load_size_ctrl,
        mdr_output,
        load_size_output
    );

    StoreSize StoreSize_ (
        store_size_ctrl,
        b_output,
        mdr_output,
        store_size_output
    );

    ExceptionByte ExceptionByte_ (
        exception,
        mem_data,
        exception_address
    );

/* MUXES */
    
    MuxIorD MuxIorD_ (
        i_or_d,
        pc_output,
        alu_out_output,
        alu_result,
        mux_i_or_d_output
    );

    MuxRegDst MuxRegDst_ (
        reg_dst,
        rt,
        rd,
        mux_reg_dst_output
    );

    MuxMemToReg MuxMemToReg_ (
        mem_to_reg,
        alu_out_output,
        load_size_output,
        hi_output,
        lo_output,
        shift_left_16,
        bit_extend,
        shift_out,
        mux_mem_to_reg_output
    );

    MuxPCSource MuxPCSource_ (
        pc_source,
        alu_result,
        alu_out_output,
        jump_address, 
        epc_output,
        exception_address,
        mux_pc_source_output
    );
    
    MuxALUSrcA MuxALUSrcA_ (
        alu_src_a,
        pc_output,
        a_output,
        mux_alu_src_a_output
    );

    MuxALUSrcB MuxALUSrcB_ (
        alu_src_b,
        b_output,
        sign_extend,
        address,
        mux_alu_src_b_output
    );

    MuxShiftSrc MuxShiftSrc_ (
        shift_src_ctrl,
        b_output,
        a_output,
        mux_shift_src_output
    );

    MuxShiftAmt MuxShiftAmt_ (
        shift_amt_ctrl,
        shamt,
        b_output,
        mux_shift_amt_output
    );

    MuxDivOrMult MuxHI_ (
        div_or_mult,
        div_hi,
        mult_hi,
        mux_hi_output
    );

    MuxDivOrMult MuxLO_ (
        div_or_mult,
        div_lo,
        mult_lo,
        mux_lo_output
    );

    MuxStackPointer MuxStackPointer_ (
        stack_pointer_ctrl,
        rs,
        mux_stack_pointer_output
    );

endmodule