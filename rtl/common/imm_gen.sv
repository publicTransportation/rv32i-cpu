// Supports I, S, B, U, J type instructions
module imm_gen 
    import rv32i_pkg::*;
(
    input logic [XLEN-1:0] instr,
    output logic [XLEN-1:0] signext_imm
);
// Decode instr[6:0] locally to avoid control unit path dependency
// Extract 12 imm bits
// Sign extend to 32 bits (rv32i)
always_comb begin // Models combinational logic
    case (instr[6:0])
        OPCODE_OP_IMM, 
        OPCODE_JALR,
        OPCODE_LOAD: signext_imm = {{20{instr[31]}}, instr[31:20]}; // I-type

        OPCODE_STORE: signext_imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type

        OPCODE_BRANCH: signext_imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type, grounded LSB 
        
        OPCODE_JAL:    signext_imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type

        OPCODE_LUI,
        OPCODE_AUIPC:  signext_imm = {instr[31:12], 12'b0}; // U-type

        default: signext_imm = 32'b0;
    endcase
end

endmodule
