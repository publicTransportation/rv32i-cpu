`timescale 1ns / 1ps
// Procedural directed testbench
module directed_tb;
    import rv32i_pkg::*;

// --- SIGNAL DECLARATIONS ---
logic            clk;
logic            rst_n;
// Instruction memory interface
logic [XLEN-1:0] imem_addr;
logic [XLEN-1:0] imem_instr;
// Data memory interface
logic [XLEN-1:0] dmem_addr;
logic [XLEN-1:0] dmem_wdata;
logic            dmem_we;
logic            dmem_re;
logic [XLEN-1:0] dmem_rdata;

// Generate clock, active-low reset
initial clk = 1'b0; // Initalize clock to low
always #5 clk = ~clk; // Toggle clock every 5 units

initial begin
    rst_n = 1'b0; // Deassert reset at t=0
    #25; // Third clock rising edge since t=0
    rst_n = @(negedge clk) 1'b1; // Avoid race conditions (rst_n is maximally delayed from posedge clk)
end

// Instantiate DUT and surrounding blocks (imem, dmem)
imem u_imem (
    .imem_addr  (imem_addr),
    .imem_instr (imem_instr) // Only output
);

dmem u_dmem (
    .clk        (clk),
    .dmem_addr  (dmem_addr),
    .dmem_wdata (dmem_wdata),
    .dmem_we    (dmem_we),
    .dmem_re    (dmem_re),
    .dmem_rdata (dmem_rdata) // Only output
);

core_single DUT (
    // Inputs
    .clk        (clk),
    .rst_n      (rst_n),
    .imem_instr (imem_instr),
    .dmem_rdata (dmem_rdata),
    // Outputs
    .imem_addr  (imem_addr),
    .dmem_addr  (dmem_addr),
    .dmem_wdata (dmem_wdata),
    .dmem_we    (dmem_we),
    .dmem_re    (dmem_re)
);

// Waveform dumping
initial begin
    $dumpfile("directed_tb.vcd");
    $dumpvars(0, directed_tb); // Recursively dump hierarchical levels (top level is directed_tb)
    #50000; // Timeout watchdog
    $display("[TB ERROR] Simulation timeout reached!");
    $finish;
end

// Monitor


// Scoreboard

endmodule
