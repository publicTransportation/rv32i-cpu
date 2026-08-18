module control_unit
(
    input logic [6:0] opcode,

    output logic branch,
    output logic mem_read,
    output logic mem_to_reg,
    output logic [1:0] alu_op,
    output logic mem_write,
    output logic alu_src,
    output logic reg_write,
    
);

always_comb begin
    assign branch = (opcode == OPCODE_BRANCH);
    assign 
end

endmodule

