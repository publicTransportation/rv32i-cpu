`timescale 1ns / 1 ps // Compilation order matters with conflicting timescale directives

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

    //output logic dmem_we,
    output logic [3:0] dmem_wmask, // Byte-enable mask
    output logic dmem_re, 

    input logic [XLEN-1:0] dmem_rdata
);

// --- Wires and Buses ---
logic [ILEN-1:0] instr;
logic [XLEN-1:0] pc;
logic [XLEN-1:0] pc_plus_4, pc_target, pc_JALR;
logic [XLEN-1:0] pc_next; 

logic [XLEN-1:0] rs1_data, rs2_data;
logic [XLEN-1:0] alu_rslt;
logic branch_taken;
//logic zero;
logic branch, mem_read, alu_src, reg_write;
logic [3:0] dmem_wmask;
alu_ctrl_e alu_ctrl;
wb_src_e wb_src;
pc_src_e pc_src;
logic [XLEN-1:0] alu_src_b; // Feeds either rs2 or imm_ext (MUX output)
logic [1:0] alu_op;
logic [XLEN-1:0] imm_ext; // Output of imm_gen
logic [XLEN-1:0] load_data; // Output of load_formatter
logic [XLEN-1:0] wbdata;

// --- Branch Comparator ---
branch_comparator u_br_comp (
    .*, // rs1_data, rs2_data, branch_taken
    .funct3 (instr[14:12])
);

// --- Program Counter Logic, Instruction Memory --- 
assign pc_plus_4 = pc + 32'd4;   // Dedicated +4 adder
assign pc_target = pc + imm_ext; // Dedicated branch target adder
assign pc_JALR = (rs1_data + imm_ext) & ~1; // Dedicated adder with grounding LSB

always_comb begin // PC source MUX
    case (pc_src)
        PC_SRC_BR_TAR: pc_next = (branch && branch_taken) ? pc_target : pc_plus_4;
        PC_SRC_JAL:    pc_next = pc_target;
        PC_SRC_JALR:   pc_next = pc_JALR;
        default:       pc_next = pc_plus_4; // Defaults to next instruction (sequentially 4 bytes later)
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin // Clocked PC module (with reset logic)
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
    .opcode     (opcode_e'(instr[6:0])), // Cast explicitly
    .* // branch, mem_read, wb_src, alu_op, mem_write, alu_src, reg_write, pc_src
);

alu_control u_alu_ctrl (
    .*, // alu_op, alu_ctrl
    .funct7     (instr[31:25]),
    .funct3     (instr[14:12]),
);

// --- Register File ---
reg_file u_rf (
    .*, // clk, rst_n, reg_write
    .rs1        (instr[19:15]),
    .rs2        (instr[24:20]),
    .rd         (instr[11:7]),
    .write_data (wbdata),
    .read_data1 (rs1_data),
    .read_data2 (rs2_data)
);

// --- ALU, Immediate Generator ---
alu u_alu (
    .a      (rs1_data),
    .b      (alu_src_b),
    .ctrl   (alu_ctrl),
    //.zero   (zero),
    .result (alu_rslt)
);

assign alu_src_b = (alu_src) ? imm_ext : rs2_data; // alu_src MUX

imm_gen u_imm_gen (
    .instr       (instr),
    .signext_imm (imm_ext)
);

// --- Data Memory & Load Formatter & Writeback MUX ---
load_formatter u_load_formatter (
    .funct3      (instr[14:12]),
    .byte_offset (alu_rslt[1:0]),
    .dmem_rdata  (dmem_rdata),
    .load_data   (load_data)
);



assign dmem_addr = {alu_rslt[XLEN-1:2], 2'b00}; // Word alignment
assign dmem_wdata = rs2_data;
//assign dmem_wmask = dmem_wmask // Don't need this because they are named the same signal already?
//assign dmem_we = mem_write; // CHANGE IF BYTE-MASK ENABLED, Single bit insufficient
assign dmem_re = mem_read;

//assign wbdata = (mem_to_reg) ? dmem_rdata : alu_rslt;
assign utype_data = instr[5] ? imm_ext : pc_target; // Opcode single bit diff between LUI and AUIPC, respectively

always_comb begin // Writeback source MUX
    case (wb_src)
        WB_SRC_ALU:    wbdata = alu_rslt;
        WB_SRC_MEM:    wbdata = load_data;
        WB_SRC_PCNEXT: wbdata = pc_plus_4;
        WB_SRC_UTYPE:  wbdata = utype_data;
        default:       wbdata = alu_rslt; 
    endcase
end

endmodule
