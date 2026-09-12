module load_formatter
    import rv32i_pkg::*;
(
    input logic [2:0] funct3,
    input logic [1:0] byte_offset,
    input logic [XLEN-1:0] dmem_rdata,

    output logic [XLEN-1:0] load_data
);
case (funct3)
    3'b000: load_data = (dmem_rdata >> (byte_offset * 8)) & 8'hFF; //LB
    3'b001: load_data = //LH 
    3'b010: load_data = dmem_rdata; //LW
    3'b100: load_data = //LBU
    3'b101: load_data = //LHU
    default: load_data = dmem_rdata; // Default to LW (no exception implementation yet)
endcase

endmodule
