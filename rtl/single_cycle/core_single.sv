`timescale 1ns / 1 ps
`include "../common/rv32i_pkg.sv" // Temp until Makefile so Verilator stops crying
`include "../common/" // Temp until Makefile

module core_single // Top level wrapper
    import rv32i_pkg::*; // need Filepath, err: import pkg not found
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

// --- Wires and Buses ---
logic [ILEN-1:0] instr;
logic [XLEN-1:0] pc;
logic [XLEN-1:0] pc_plus_4;
logic [XLEN-1:0] pc_target; 
logic [XLEN-1:0] pc_next; 

logic [XLEN-1:0] rs1, rs2;
logic [XLEN-1:0] alu_rslt;
logic zero;
logic branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
alu_ctrl_e alu_ctrl;
logic [XLEN-1:0] alu_src_b; // Feeds either rs2 or imm_ext (MUX output)
logic [1:0] alu_op;
logic [XLEN-1:0] imm_ext; // Output of imm_gen
logic [XLEN-1:0] wbdata;

// --- Program Counter Logic, Instruction Memory --- 
assign pc_plus_4 = pc + 32'd4;
assign pc_target = pc + imm_ext;
assign pc_next = (branch && zero) ? pc_target : pc_plus_4;

always_ff @(posedge clk or negedge rst_n) begin // Reset logic
    if (!rst_n)
        pc <= 32'b0;
    else
        pc <= pc_next;
end
// Interface with imem
assign instr = imem_instr; 
assign imem_addr = pc_next;

// --- Control Units ---
control_unit u_ctrl (

);

alu_control u_alu_ctrl (

);

// --- Register File ---
reg_file u_rf (

);

// --- ALU, Immediate Generator ---
alu u_alu (

);

imm_gen u_imm_gen (

);

// --- Data Memory & Writeback MUX ---

endmodule
