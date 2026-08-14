module imm_gen (
    input logic [31:0] instr,
    output logic [31:0] signext_imm
);
// Decode instr[6:0] locally to avoid control unit path dependency
case (instr[6:2])
    case1 :
    default:

endcase

// Extract 12 imm bits

// Sign extend to 32 bits (rv32i)


endmodule