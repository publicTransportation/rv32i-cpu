module alu
    import rv32i_pkg::*;
(
    input logic [XLEN-1:0] A,
    input logic [XLEN-1:0] B,
    input alu_ctrl_e ctrl,

    output logic zero,
    output logic [XLEN-1:0] result 
);

always_comb begin
    case (ctrl)
        ALU_ADD: result = A + B;
        ALU_SUB: result = A - B;
        ALU_SLL: 
        ALU_SLT: // Set of Less Than (Signed)
        ALU_SLTU: // (Unsigned)
        ALU_SRL:
        ALU_SRA:
        ALU_OR:
        ALU_AND:
        ALU_PASS: result = B; // Pass-through (operand B)



    endcase

    zero = (result == '0); // Zero flag assertion, '0 is unbased and unsized
end

endmodule
