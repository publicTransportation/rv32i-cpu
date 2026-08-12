package rv32i_pkg;
    parameter int XLEN = 32;

    typedef enum logic [6:0] { // RISC-V is Little-endian
        OPCODE_LOAD =  7'b0000011, // Load
        OPCODE_STORE =  7'b0100011,
        OPCODE_FENCE = 7'b0001111,
        OPCODE_BRANCH = 7'b1100011,
        OPCODE_JAL = 7'b1101111, // Jump
        OPCODE_JALR = 7'b1100111, // Jump and Link Register
        OPCODE_OP_IMM = 7'b0010011, // Operation with Immediate, I-Type
        OPCODE_OP = 7'b0110011, // R-Type
        OPCODE_LUI = 7'b0110111, // Load upper immediate
        OPCODE_AUIPC = 7'b0010111, // Add upper immediate to PC
        OPCODE_CSR = 7'b1110011
    } opcode_e; // Enumeration type

endpackage
