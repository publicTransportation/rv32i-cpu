`timescale 1ns / 1 ps
//`include "../common/rv32i_pkg.sv" // Temp until Makefile so Verilator stops complaining
//`include "../common/" // Temporary until Makefile

module core_single // Top level wrapper
    import rv32i_pkg::*;
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
    //output logic [3:0] dmem_wmask, // Byte-mask
    output logic dmem_re, 

    input logic [XLEN-1:0] dmem_rdata
);

// --- Wires and Buses ---
logic [ILEN-1:0] instr;
logic [XLEN-1:0] pc;
logic [XLEN-1:0] pc_plus_4;
logic [XLEN-1:0] pc_target; 
logic [XLEN-1:0] pc_next; 

logic [XLEN-1:0] rs1_data, rs2_data;
logic [XLEN-1:0] alu_rslt;
logic zero;
logic branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write; // Distinct dmem read & write enables
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
assign imem_addr = pc;

// --- Control Units ---
control_unit u_ctrl (
    .opcode     (instr[6:0]),

    .branch     (branch),
    .mem_read   (mem_read),
    .mem_to_reg (mem_to_reg),
    .mem_write  (mem_write),
    .alu_src    (alu_src),
    .reg_write  (reg_write),
    .alu_op     (alu_op)
);

alu_control u_alu_ctrl (
    .alu_op     (alu_op),
    .funct7     (instr[31:25]),
    .funct3     (instr[14:12]),

    .alu_ctrl   (alu_ctrl) 
);

// --- Register File ---
reg_file u_rf (
    // Inputs
    .clk        (clk),
    .rst_n      (rst_n),
    .reg_write  (reg_write),

    .rs1        (instr[19:15]),
    .rs2        (instr[24:20]),
    .rd         (instr[11:7]),

    .write_data (wbdata),
    // Outputs
    .read_data1 (rs1_data),
    .read_data2 (rs2_data)
);

// --- ALU, Immediate Generator ---
alu u_alu (
    .a      (rs1_data),
    .b      (alu_src_b),
    .ctrl   (alu_ctrl),

    .zero   (zero),
    .result (alu_rslt)
);

assign alu_src_b = (alu_src) ? imm_ext : rs2_data; // alu_src MUX

imm_gen u_imm_gen (
    .instr       (instr),
    .signext_imm (imm_ext)
);

// --- Data Memory & Writeback MUX ---
assign dmem_addr = alu_rslt;
assign dmem_wdata = rs2_data;
assign dmem_we = mem_write; // CHANGE IF BYTE-MASK ENABLED, Single bit insufficient
assign dmem_re = mem_read;

assign wbdata = (mem_to_reg) ? dmem_rdata : alu_rslt;

endmodule
