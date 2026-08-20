module alu
    import rv32i_pkg::*;
(
    input logic [XLEN-1:0] a,
    input logic [XLEN-1:0] b,
    input rv32i_pkg::alu_ctrl_e ctrl,

    output logic zero,
    output logic [XLEN-1:0] result 
);

always_comb begin
    case (ctrl)
        ALU_ADD : result = a + b;
        ALU_SUB : result = a - b;
        ALU_SLL : result = a << b[REG_ADDR_LEN-1:0];
        ALU_SLT : result = 32'($signed(a) < $signed(b));       // Set on Less Than (Signed)
        ALU_SLTU: result = 32'(a < b);                         // (Unsigned)
        ALU_SRL : result = a >> b[REG_ADDR_LEN-1:0];
        ALU_SRA : result = $signed(a) >>> b[REG_ADDR_LEN-1:0];
        ALU_OR  : result = a | b;                               // Bitwise OR
        ALU_AND : result = a & b;                               // Bitwise AND
        ALU_XOR : result = a ^ b;                               // Bitwise
        ALU_PASS: result = b;                                   // Pass-through (operand b)
        default : result = '0;
    endcase

    zero = (result == '0); // Zero flag assertion, '0 is unbased and unsized
end

endmodule
