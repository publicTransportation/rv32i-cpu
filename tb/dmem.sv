module dmem
    import rv32i_pkg::*; // Will work once Makefile determines compilation order
#(

)(
    input clk,

    input logic [XLEN-1:0] dmem_addr,
    input logic [XLEN-1:0] dmem_wdata,

    input logic dmem_we, 
    input logic dmem_re,

    output logic [XLEN-1:0] dmem_rdata
);

// Associative Array to model sparse entries
logic [XLEN-1:0] mem [logic [XLEN-1:0]]; // 32-bit data mapped to 32-bit address keys

always_ff @(posedge clk && dmem_we) begin
    mem[dmem_addr] <= dmem_wdata;
end
always_ff @(posedge clk && dmem_re) begin
    dmem_rdata <= mem[dmem_addr];
end

endmodule
