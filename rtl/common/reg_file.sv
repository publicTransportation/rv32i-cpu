module reg_file 
    import rv32i_pkg::*; // needed?
(
    input logic clk,
    input logic rst_n,
    input logic reg_write,

    input logic [REG_ADDR_LEN-1:0] rs1,
    input logic [REG_ADDR_LEN-1:0] rs2,
    input logic [REG_ADDR_LEN-1:0] rd,
    
    input logic [XLEN-1:0] write_data,
    
    output logic [XLEN-1:0] read_data1,
    output logic [XLEN-1:0] read_data2
);

logic [XLEN-1:0] rf [0:XLEN-1];

always_comb begin
    read_data1 = rf[rs1];
    read_data2 = rf[rs2];
end

always @() begin
    
end

endmodule
