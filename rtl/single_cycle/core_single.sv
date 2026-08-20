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
// need funct7 funct3 buses? dont think so since parsed inside alu_control.sv

// MUXes can be taken care of with assign ? :

// --- Program Counter Logic, Instruction Memory --- 
assign pc_plus_4 = pc + (XLEN)'d4; // can i just go pc + 4?
assign pc_target = pc + imm_ext;
assign pc_next = (branch && zero) ? pc_target : pc_plus_4

// --- Control Units ---


// --- ALU, Immediate Generator,  ---


// --- Data Memory & Writeback MUX ---

endmodule
