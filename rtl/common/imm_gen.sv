// Supports I, S, B type instructions
// Missing: U, J type
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

        default: signext_imm = (XLEN)'b0;
    endcase
end

endmodule
