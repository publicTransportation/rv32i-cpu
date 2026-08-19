module control_unit
(
    input logic [6:0] opcode_e,

    output logic branch,
    output logic mem_read,
    output logic mem_to_reg,
    output logic [1:0] alu_op,
    output logic mem_write,
    output logic alu_src,
    output logic reg_write,
    
);

always_comb begin
    case (opcode_e)
        OPCODE_OP: branch = 0, mem_read = 0, mem_to_reg = 0, alu_op = {1,0}, mem_write = 0, alu_src = 0, reg_write = 1;

    endcase
end

endmodule

