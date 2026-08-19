module alu
(
    input logic A,
    input logic B,
    input logic control,
    output logic zero,
    output logic result 
);

always_comb begin
    case (control)
        //list cases here

    endcase

    zero = (result == '0); // Zero flag assertion, '0 is unbased and unsized
end

endmodule
