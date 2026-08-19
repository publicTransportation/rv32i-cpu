module alu_control 
    import rv32i_pkg::*;
(
    input rv32i_pkg::opcode_e opcode,
    input logic [1:0] alu_op,

    input  logic [6:0] funct7, // Instruction indices [31:25]
    input  logic [2:0] funct3, // Instruction indices [14:12]

    output rv32i_pkg::alu_ctrl_e alu_ctrl
);

always_comb begin // Using P&H p.502 Figure 4.13
    if (alu_op[1]) begin
        case ({funct7, funct3})
            10'b0000000_000: alu_ctrl = ALU_SLL;
            10'b0100000_000: alu_ctrl = ALU_SRL;
            10'b0000000_111: alu_ctrl = ALU_ADD;
            10'b0000000_110: alu_ctrl = ALU_SUB;
        endcase
    end else if (alu_op[0]) begin
        alu_ctrl = ALU_SRL;
    end else begin
        alu_ctrl = ALU_SLL;
    end
end

endmodule
