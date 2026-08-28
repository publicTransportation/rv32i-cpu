module imem
    import rv32i_pkg::*;
#(
    parameter MEM_DEPTH = 512,
    parameter HEX_PATH = "test.hex" // Compiled machine code filepath  
)(
    input logic [XLEN-1:0] imem_addr,
    output logic [ILEN-1:0] imem_instr
);
logic [ILEN-1:0] mem [0:MEM_DEPTH-1]; // Unpacked array modelling Read-Only Memory (ROM)

initial begin
    $readmemh(HEX_PATH, mem);
end

assign imem_instr = mem[imem_addr[XLEN-1:2]]; // Dropped last 2 LSB's to divide by 4 (Byte-Addressed, Instructions are words)
endmodule
