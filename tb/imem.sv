module imem
    import rv32i_pkg::*; // Out of scope?
#(
    parameter MEM_DEPTH = 512,
    parameter HEX_PATH = "" // Compiled machine code filepath  
)(
    input logic [XLEN-1:0] imem_addr,
    output logic [ILEN-1:0] imem_instr
);
logic [ILEN-1:0] mem [0:MEM_DEPTH-1]; // Unpacked array modeling Read-Only Memory (ROM)
initial begin
    $readmemh(HEX_PATH, mem);
end

endmodule
