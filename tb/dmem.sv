module dmem
    import rv32i_pkg::*; 
(
    input logic clk,

    input logic [XLEN-1:0] dmem_addr,
    input logic [XLEN-1:0] dmem_wdata,

    input logic dmem_we, 
    input logic dmem_re,

    output logic [XLEN-1:0] dmem_rdata
);


// Associative Array to model sparse entries // iverilog does not support associative arrays
/*
logic [XLEN-1:0] mem [logic [XLEN-1:0]]; // 32-bit data mapped to 32-bit address keys
logic [XLEN-1:0] aligned_addr;

assign aligned_addr = {dmem_addr[XLEN-1:2], 2'b00}; // Mask 2 lowest bits to enforce Word Alignment

always_ff @(posedge clk) begin
    if (dmem_we) begin // Do not need .exists() here because it will just be created
        mem[aligned_addr] <= dmem_wdata;
    end
    if (dmem_re) begin
        if (mem.exists(aligned_addr)) begin
            dmem_rdata <= mem[aligned_addr];
        end else begin                
            dmem_rdata <= '0; // Default read '0 for empty address
        end 
    end else begin
        dmem_rdata <= '0; // Deasserted read is '0
    end
end
*/

// Fixed-sized unpacked array
localparam int MEM_DEPTH = 1024;
logic [XLEN-1:0] mem [0:MEM_DEPTH-1];    
wire [XLEN-1:0] word_idx = dmem_addr >> 2;  // Convert byte address to word index (divide by 4)

always_ff @(posedge clk) begin
    // Synchronous Write
    if (dmem_we) begin
        if (word_idx < MEM_DEPTH) begin
            mem[word_idx] <= dmem_wdata;
        end
    end

        
end

always_comb begin
    // Asynchronous Read (replace .exists with boundary check)
    if (dmem_re) begin
        if (word_idx < MEM_DEPTH) begin
            dmem_rdata = mem[word_idx];
        end else begin
            dmem_rdata = '0;
        end
    end else begin
        dmem_rdata = '0;
    end
end

endmodule
