module cpu_sva
    import rv32i_pkg::*;
(
    // inputs
    input logic clk,
    input logic rst_n,
    input logic [XLEN-1:0] imem_addr,
    input logic [XLEN-1:0] x0_val, // u_rf.rd[0]
    input logic dmem_we,
    input logic dmem_re,
    input logic [3:0] dmem_wmask
);

// Assertion 1: x0 must always be 0 (on posedge clk unless reset active)
a_x0_is_zero: assert property (@(posedge clk) disable iff (!rst_n) (x0_val == '0))
    else $error("[SVA FAIL] x0 is not 0! | PC: 0x%08h | x0: 0x%08h", imem_addr, x0_val);

// Assertion 2: PC must always be word-aligned (on posedge clk unless reset active)
a_PC_word_aligned: assert property (@(posedge clk) disable iff (!rst_n) imem_addr[1:0] == 2'b00) 
    else $error("[SVA FAIL] PC is not 4-byte aligned! | PC: 0x%08h", imem_addr);

// Assertion 3: Dmem read and write mutually exclusive, cannot happen on same clk edge
a_read_write_mutex: assert property (@(posedge clk) disable iff (!rst_n) !(dmem_re && dmem_we)) 
    else $error("[SVA FAIL] Read and write on same clk edge! | PC: 0x%08h | MemRead: %b | MemWrite: %b", imem_addr, dmem_re, dmem_we);

a_we_turns_wmask_off: assert property (@(posedge clk) disable iff (!rst_n) !dmem_we |-> (dmem_wmask == '0))    
    else $error("[SVA FAIL] MemWrite disable failed to turn writeback byte mask off! | PC: 0x%08h | MemWrite: %b | MemWriteMask: %b", imem_addr, dmem_we, dmem_wmask);

endmodule
