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

logic [XLEN-1:0] rf [0:NUM_REGS-1]; // Create unpacked array of 32 regs each 32 bits wide

assign read_data1 = (rs1 == '0) ? '0 : rf[rs1]; // Bypass x0 to always be GND ('0)
assign read_data2 = (rs2 == '0) ? '0 : rf[rs2];

always_ff @(posedge clk or negedge rst_n) begin // Full Asynchronous Reset
    if (!rst_n) begin // On falling edge, Reset all registers to '0
        // rf <= '{default: '0}; // Verilator/iverilog does not like this syntax
        for (int i = 0; i < NUM_REGS; i++) begin
            rf[i] <= '0; // Reset every individual register to zeroes
        end
    end else if (reg_write && rd != '0) begin // Rising edge reg_write and bypassing x0
        rf[rd] <= write_data;
    end
end

endmodule
