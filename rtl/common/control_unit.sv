module control_unit
    import rv32i_pkg::*;
(
    input rv32i_pkg::opcode_e opcode,

    output logic branch,
    output logic mem_read,
    output wb_src_e wb_src,
    output alu_op_e alu_op,
    // output rv32i_pkg::alu_op_e alu_op,
    output logic mem_write,
    output logic alu_src,
    output logic reg_write,
    output pc_src_e pc_src
);

always_comb begin
    case (opcode) // Lookup Table (likely synthesizes decoders); control unit can also use logic from a minimized truth table
        OPCODE_OP:     {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = {1'b0, 1'b0, 1'b0, ALU_OP_RTYPE,  1'b0, 1'b0, 1'b1};
        OPCODE_LOAD:   {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = {1'b0, 1'b1, 1'b1, ALU_OP_MEM,    1'b0, 1'b1, 1'b1};
        OPCODE_STORE:  {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = {1'b0, 1'b0, 1'b0, ALU_OP_MEM,    1'b1, 1'b1, 1'b0}; // Note mem_to_reg is a don't care
        OPCODE_BRANCH: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = {1'b1, 1'b0, 1'b0, ALU_OP_BRANCH, 1'b0, 1'b0, 1'b0}; // Note mem_to_reg is a don't care
        OPCODE_OP_IMM: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = {1'b0, 1'b0, 1'b0, ALU_OP_RTYPE,  1'b0, 1'b1, 1'b1};
        //OPCODE_JAL:    {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b1_0_0_10_0_1_1; // wip // likely MORE control signals needed to support JAL, JALR, AUIPC, LUI
        default:       {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = {1'b0, 1'b0, 1'b0, ALU_OP_MEM,    1'b0, 1'b0, 1'b0}; 
    endcase
end

endmodule
