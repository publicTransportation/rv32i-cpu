module control_unit
    import rv32i_pkg::*;
(
    input opcode_e opcode,

    output logic branch,
    output logic mem_read,
    output wb_src_e wb_src,
    output alu_op_e alu_op,
    // output rv32i_pkg::alu_op_e alu_op,
    output logic dmem_wmask,
    output logic alu_src,
    output logic reg_write,
    output pc_src_e pc_src
);

always_comb begin
    case (opcode) // Lookup Table (likely synthesizes decoders); control unit can also use logic from a minimized truth table
        OPCODE_OP:             {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_ALU,    ALU_OP_RTYPE,  1'b0,      1'b0,    1'b1,      PC_SRC_NEXT};

        OPCODE_OP_IMM:         {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_ALU,    ALU_OP_RTYPE,  1'b0,      1'b1,    1'b1,      PC_SRC_NEXT};

        OPCODE_LOAD:           {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b1,     WB_SRC_MEM,    ALU_OP_MEM,    1'b0,      1'b1,    1'b1,      PC_SRC_NEXT};

        OPCODE_STORE:          {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_ALU,    ALU_OP_MEM,    1'b1,      1'b1,    1'b0,      PC_SRC_NEXT};

        OPCODE_BRANCH:         {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b1,   1'b0,     WB_SRC_ALU,    ALU_OP_BRANCH, 1'b0,      1'b0,    1'b0,      PC_SRC_BR_TAR};

        OPCODE_JAL:            {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_PCNEXT, ALU_OP_MEM,    1'b0,      1'b0,    1'b1,      PC_SRC_JAL};

        OPCODE_JALR:           {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_PCNEXT, ALU_OP_MEM,    1'b0,      1'b1,    1'b1,      PC_SRC_JALR};

        OPCODE_LUI,
        OPCODE_AUIPC:          {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_UTYPE,  ALU_OP_MEM,    1'b0,      1'b0,    1'b1,      PC_SRC_NEXT};

        default:               {branch, mem_read, wb_src,        alu_op,        mem_write, alu_src, reg_write, pc_src} = 
                               {1'b0,   1'b0,     WB_SRC_ALU,    ALU_OP_MEM,    1'b0,      1'b0,    1'b0,      PC_SRC_NEXT};
    endcase
end

endmodule
