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
    @(negedge clk);
    rst_n = 1'b1; // Avoid race conditions (rst_n is maximally delayed from posedge clk)
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

// Monitor (Instruction Execution Log)
always @(posedge clk) begin
    if (rst_n) begin
        // Print retired instruction information here
        $display("[TIME %0t ns] PC: 0x%08h | Instr: 0x%08h | RegWrite: %b (x%0d <= 0x%08h) | MemWrite: %b ([0x%08h] <= 0x%08h)",
            $time,
            imem_addr,      // PC
            imem_instr,
            DUT.reg_write,
            DUT.u_rf.rd,    // Destination register
            DUT.wbdata,
            dmem_we,
            dmem_addr,      // Write addr
            dmem_wdata      // Write data
        );
    end
end
// End of Test Detection
always @(posedge clk) begin
    if (rst_n) begin
        if(imem_instr == 32'h00000000) begin // UNIMP (Unimplemented Instruction, imem hits empty memory) // (WIP) add imem_instr == 32'h0000006f (exit() inf loop) once J-type instr are supported
            $display("\n[TB INFO] End-of-Test instruction detected at PC = 0x%08h", imem_addr);
            @(posedge clk); 
            #1;
            check_results(); // Scoreboard verification task called after one cycle (drain DUT, one cycle for final writeback)
        end
    end
end

// --- SCOREBOARD ---

/*
// Golden Reference // (WIP) (Co-simulation in lockstep) // (WIP) (Spike ISS DPI-C)
logic [XLEN-1:0] ref_rf [XLEN];         // Reference Architectural State (Pure Behavioral Storage) (Pure unpacked array, NOT RTL module)
int mismatch_count = 0;

initial begin
    for (int i = 0; i < 32; i++) begin
        ref_rf[i] = 32'b0;              // Initialize Reference Register File
    end
end
*/

// Hardcoded Golden Reference
logic [XLEN-1:0] ref_rf [NUM_REGS];         // Reference Architectural State
initial begin
    for (int i = 0; i < 32; i++) begin
        ref_rf[i] = 32'b0;              // Initialize Reference Register File
    end
    // --- HARDCODE register expected values ---
    ref_rf[1]  = 256; // x1
    ref_rf[2]  = 15;  // x2 (and so on)
    ref_rf[3]  = 7;
    ref_rf[4]  = 15;
    ref_rf[5]  = 22;
    ref_rf[6]  = 15;
    ref_rf[7]  = 6;
    ref_rf[8]  = 31;
    ref_rf[9]  = 1;
    ref_rf[10] = 0;   // Skipped
    ref_rf[11] = 11;
    ref_rf[12] = 42;  // x12
end
// Equality checker (Only checks final state equality at EOT)
task automatic check_results();
    int mismatch_count = 0;
    $display("\n==============================================");
    $display("           SCOREBOARD: FINAL CHECK            ");
    $display("==============================================");
    for (int i = 0; i < 32; i++) begin
        if (DUT.u_rf.rf[i] !== ref_rf[i]) begin
            $display("[FAIL] Reg x%-2d = 0x%08h (Expected: 0x%08h)", i, DUT.u_rf.rf[i], ref_rf[i]);
            mismatch_count++;
        end 
    end
    if (mismatch_count == 0) begin
        $display("[TEST PASSED] All 32 registers matched expected state.");
    end else begin
        $display("[TEST FAILED] Total mismatches: %0d", mismatch_count);
    end
    $display("==============================================\n");
    $finish;
endtask

endmodule
