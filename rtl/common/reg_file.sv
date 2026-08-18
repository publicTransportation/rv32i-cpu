module reg_file 
    import rv32i_pkg::*;
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

logic [XLEN-1:0] rf [0:NUM_REGS-1]; // Create 32 unpacked arrays (regs) each 32 bits wide

assign read_data1 = (rs1 == '0) ? '0 : rf[rs1]; // Bypass x0 to always be GND ('0)
assign read_data2 = (rs2 == '0) ? '0 : rf[rs2];

always @(reg_write) begin
    rf[rd] = write_data;
end

endmodule
