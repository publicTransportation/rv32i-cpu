module alu_control 
    import rv32i_pkg::*;
(
    //input rv32i_pkg::opcode_e opcode,
    input logic [1:0] alu_op,
    input logic bit30,       // Instruction indices [30]
    input logic [2:0] funct3, // Instruction indices [14:12]
    input logic is_rtype,

    output rv32i_pkg::alu_ctrl_e alu_ctrl
);

always_comb begin // ALUOp mapping (ALUOp = 1X, X1, 00)
    alu_ctrl = ALU_ADD;

    if (alu_op[1]) begin
        case (funct3)
            3'b000:  alu_ctrl = alu_ctrl_e'((bit30 && is_rtype) ? ALU_SUB : ALU_ADD); // SUB only for R-type (I-type instructions do NOT have a funct7)
            3'b001:  alu_ctrl = ALU_SLL;
            3'b010:  alu_ctrl = ALU_SLT;   // Handles SLT and SLTI
            3'b011:  alu_ctrl = ALU_SLTU;  // Handles SLTU and SLTIU
            3'b100:  alu_ctrl = ALU_XOR;
            3'b101:  alu_ctrl = alu_ctrl_e'(bit30 ? ALU_SRA : ALU_SRL); // SRAI / SRA use bit 30 of instr
            3'b110:  alu_ctrl = ALU_OR;
            3'b111:  alu_ctrl = ALU_AND;
            default: alu_ctrl = ALU_ADD;
        endcase
    end else if (alu_op[0]) begin
        alu_ctrl = ALU_SUB;
    end else begin
        alu_ctrl = ALU_ADD;
    end
end

endmodule
