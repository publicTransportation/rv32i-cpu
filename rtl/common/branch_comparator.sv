module branch_comparator 
    import rv32i_pkg::*;
(
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [2:0]  funct3,
    output logic        branch_taken
);
    // Comparator flags
    logic eq;
    logic lt_signed;
    logic lt_unsigned;

    assign eq          = (rs1_data == rs2_data);
    assign lt_signed   = ($signed(rs1_data) < $signed(rs2_data));
    assign lt_unsigned = (rs1_data < rs2_data);

    // funct3 encoding
    always_comb begin
        case (funct3)
            3'b000:  branch_taken = eq;            // BEQ
            3'b001:  branch_taken = !eq;           // BNE
            3'b100:  branch_taken = lt_signed;     // BLT
            3'b101:  branch_taken = !lt_signed;    // BGE
            3'b110:  branch_taken = lt_unsigned;   // BLTU
            3'b111:  branch_taken = !lt_unsigned;  // BGEU
            default: branch_taken = 1'b0;
        endcase
    end

endmodule
