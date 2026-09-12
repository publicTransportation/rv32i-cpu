module load_formatter
    import rv32i_pkg::*;
(
    input logic [2:0] funct3,
    input logic [1:0] byte_offset,
    input logic [XLEN-1:0] dmem_rdata,

    output logic [XLEN-1:0] load_data
);
logic [7:0] load_byte;
logic [15:0] load_hw;

always_comb begin
    load_byte = 8'(dmem_rdata >> (byte_offset * 8)); // Explicit size cast (8 bits), Shift trick to slice
    load_hw = 16'(dmem_rdata >> (byte_offset[1] * 16)); // Disallow byte shifts for hw slicing
    case (funct3)
        3'b000: load_data = {{24{load_byte[7]}}, load_byte}; //LB
        3'b001: load_data = {{16{load_hw[15]}}, load_hw};    //LH 
        3'b010: load_data = dmem_rdata;                      //LW
        3'b100: load_data = {24'b0, load_byte};              //LBU
        3'b101: load_data = {16'b0, load_hw};                //LHU
        default: load_data = dmem_rdata; // Default to LW (no exception implementation yet)
    endcase
end

endmodule
