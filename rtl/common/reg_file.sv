module reg_file 
    import rv32i_pkg::*; // needed?
(
    input logic clk,
    input logic rst_n,
    input logic reg_write,

    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    
    input logic [31:0] write_data,
    
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

logic [31:0] rf [0:31];

always_comb begin
    read_data1 = rf[rs1];
    read_data2 = rf[rs2];
end

always @() begin
    
end

endmodule
