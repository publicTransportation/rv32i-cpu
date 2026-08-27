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


endmodule
