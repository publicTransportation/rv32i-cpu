`timescale 1ns / 1 ps
import rv32i_pkg::*; // need Filepath, err: import pkg not found

module core_single // Top level wrapper
(
    input logic clk,
    input logic rst_n,

    // Instruction memory interface
    output logic [XLEN-1:0] imem_addr,
    input logic [ILEN-1:0] imem_instr,
    
    // Data memory interface
    output logic [XLEN-1:0] dmem_addr,
    output logic [XLEN-1:0] dmem_wdata,

    output logic dmem_we, 
    output logic dmem_re, // do we need separate one-bit write and read enables?

    input logic [XLEN-1:0] dmem_rdata,
);

// Wires and Buses


endmodule
