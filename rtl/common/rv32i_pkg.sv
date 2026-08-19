package rv32i_pkg;
    parameter int XLEN = 32;
    parameter int NUM_REGS = 32;
    parameter int REG_ADDR_LEN = 5;
    typedef logic [REG_ADDR_LEN-1:0] reg_addr_t;

    typedef enum logic [6:0] { // RISC-V is Little-endian
        OPCODE_LOAD =  7'b0000011, // Load
        OPCODE_STORE =  7'b0100011,
        OPCODE_FENCE = 7'b0001111,
        OPCODE_BRANCH = 7'b1100011,
        OPCODE_JAL = 7'b1101111, // Jump
        OPCODE_JALR = 7'b1100111, // Jump and Link Register
        OPCODE_OP_IMM = 7'b0010011, // I-type (operation with immediate)
        OPCODE_OP = 7'b0110011, // R-type
        OPCODE_LUI = 7'b0110111, // Load upper immediate
        OPCODE_AUIPC = 7'b0010111, // Add upper immediate to PC
        OPCODE_CSR = 7'b1110011
    } opcode_e; // Enumeration type
    /*
    typedef enum logic [1:0] {
        ALU_OP_MEM    = 2'b00, // Loads / Stores (add)
        ALU_OP_BRANCH = 2'b01, // Branches (sub/compare)
        ALU_OP_RTYPE  = 2'b10, // R-type / I-type (decode funct3/funct7)
        ALU_OP_OTHER  = 2'b11
    } alu_op_e;
    */

endpackage
