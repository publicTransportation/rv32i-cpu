module control_unit
    import rv32i_pkg::*;
(
    input rv32i_pkg::opcode_e opcode,

    output logic branch,
    output logic mem_read,
    output logic mem_to_reg,
    output logic [1:0] alu_op,
    // output rv32i_pkg::alu_op_e alu_op,
    output logic mem_write,
    output logic alu_src,
    output logic reg_write
);

always_comb begin
    case (opcode) // Lookup Table (likely synthesizes decoders); control unit can also use logic from a minimized truth table 
        OPCODE_OP:     {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b0_0_0_10_0_0_1;
        OPCODE_LOAD:   {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b0_1_1_00_0_1_1;
        OPCODE_STORE:  {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b0_0_0_00_1_1_0; // Note mem_to_reg is a don't care
        OPCODE_BRANCH: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b1_0_0_01_0_0_0; // Note mem_to_reg is a don't care
        OPCODE_OP_IMM: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b0_0_0_10_0_1_1;
        default:       {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b0_0_0_00_0_0_0;
    endcase
end

endmodule
