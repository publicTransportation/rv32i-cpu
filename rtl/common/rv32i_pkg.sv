package rv32i_pkg;
    parameter int XLEN = 32; // 32-bit archiecture
    parameter int ILEN = 32; // Instruction length RISC-V
    parameter int NUM_REGS = 32;
    parameter int REG_ADDR_LEN = 5;
    typedef logic [REG_ADDR_LEN-1:0] reg_addr_t;

    typedef enum logic [6:0] { // RISC-V is Little-endian
        OPCODE_LOAD =   7'b0000011, // Load
        OPCODE_STORE =  7'b0100011,
        OPCODE_BRANCH = 7'b1100011,
        OPCODE_JAL =    7'b1101111, // Jump
        OPCODE_JALR =   7'b1100111, // Jump and Link Register
        OPCODE_OP_IMM = 7'b0010011, // I-type (operation with immediate)
        OPCODE_OP =     7'b0110011, // R-type
        OPCODE_LUI =    7'b0110111, // Load upper immediate
        OPCODE_AUIPC =  7'b0010111, // Add upper immediate to PC
        OPCODE_FENCE =  7'b0001111,
        OPCODE_CSR =    7'b1110011
    } opcode_e; // Enumeration type

    typedef enum logic [3:0] {
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_SLL  = 4'b0010,
        ALU_SLT  = 4'b0011,
        ALU_SLTU = 4'b0100,
        ALU_XOR  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_SRA  = 4'b0111,
        ALU_OR   = 4'b1000,
        ALU_AND  = 4'b1001,
        ALU_PASS = 4'b1010
    } alu_ctrl_e; // Second-level decoding after the Main Control Unit

    typedef enum logic [1:0] {
        ALU_OP_MEM    = 2'b00, // Loads / Stores (add)
        ALU_OP_BRANCH = 2'b01, // Branches (sub/compare)
        ALU_OP_RTYPE  = 2'b10, // R-type / I-type (decode funct3/funct7)
        ALU_OP_OTHER  = 2'b11
    } alu_op_e;

    typedef enum logic [1:0] {
        WB_SRC_ALU    = 2'b00,
        WB_SRC_MEM    = 2'b01, 
        WB_SRC_PCNEXT = 2'b10, // PC + 4 (JAL and JALR save return address to rd)
        WB_SRC_UTYPE  = 2'b11  // Immediate value for LUI or PC+Imm for AUIPC
    } wb_src_e;

    typedef enum logic [1:0] {
        PC_SRC_NEXT   = 2'b00, // PC + 4 (Default next instruction)
        PC_SRC_BR_TAR = 2'b01,  // Branch target
        PC_SRC_JAL    = 2'b10,  // Same as Branch target but jump is unconditionally taken
        PC_SRC_JALR   = 2'b11 // JALR target
    } pc_src_e;

endpackage
