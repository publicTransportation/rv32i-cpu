module alu
    import rv32i_pkg::*;
(
    input logic [XLEN-1:0] A,
    input logic [XLEN-1:0] B,
    input rv32i_pkg::alu_ctrl_e ctrl,

    output logic zero,
    output logic [XLEN-1:0] result 
);

always_comb begin
    case (ctrl)
        ALU_ADD : result = A + B;
        ALU_SUB : result = A - B;
        ALU_SLL : result = A << B[REG_ADDR_LEN-1:0];
        ALU_SLT : result = 32'($signed(A) < $signed(B));       // Set on Less Than (Signed)
        ALU_SLTU: result = 32'(A < B);                         // (Unsigned)
        ALU_SRL : result = A >> B[REG_ADDR_LEN-1:0];
        ALU_SRA : result = $signed(A) >>> B[REG_ADDR_LEN-1:0];
        ALU_OR  : result = A | B;                               // Bitwise OR
        ALU_AND : result = A & B;                               // Bitwise AND
        ALU_XOR : result = A ^ B;                               // Bitwise
        ALU_PASS: result = B;                                   // Pass-through (operand B)
        default : result = '0;
    endcase

    zero = (result == '0); // Zero flag assertion, '0 is unbased and unsized
end

endmodule
