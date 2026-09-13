module cpu_sva
    import rv32i_pkg::*;
(
    // inputs
    input logic [XLEN-1:0] x0_val; // u_rf.rd[0]
);

// Assertion 1: x0 must always be 0 on posedge clk
a_x0_is_zero : assert property (@(posedge clk) disable iff (!rst_n) (x0_val == '0)) 

// Assertion 2:


endmodule