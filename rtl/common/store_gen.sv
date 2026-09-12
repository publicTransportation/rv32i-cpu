module store_gen
    import rv32i_pkg::*;
(
    input logic [2:0] funct3,
    input  logic [1:0] byte_offset,
    input logic [XLEN-1:0] rs2_data,
    input logic mem_write,

    output logic [XLEN-1:0] dmem_wdata,
    output logic [3:0] dmem_wmask
);

    always_comb begin
        if (!mem_write) begin // Turn off mem_write
            dmem_wmask = 4'b0000; 
        end else begin
            case (funct3)
                3'b000: begin // SB
                    case (byte_offset)
                        2'b00:   dmem_wmask = 4'b0001;
                        2'b01:   dmem_wmask = 4'b0010;
                        2'b10:   dmem_wmask = 4'b0100;
                        2'b11:   dmem_wmask = 4'b1000;
                        default: dmem_wmask = 4'b0000;
                    endcase
                end
                3'b001:  dmem_wmask = byte_offset[1] ? 4'b1100 : 4'b0011; // SH
                3'b010:  dmem_wmask = 4'b1111; // SW
                default: dmem_wmask = 4'b0000;
            endcase
        end
    end

    // Replicate data across lanes (correct data regardless of how mask is applied)
    always_comb begin
        case (funct3)
            3'b000:  dmem_wdata = {4{rs2_data[7:0]}};   // SB: Replicate byte to all 4 lanes
            3'b001:  dmem_wdata = {2{rs2_data[15:0]}};  // SH: Replicate halfword to both halves
            3'b010:  dmem_wdata = rs2_data;             // SW
            default: dmem_wdata = rs2_data;
        endcase
    end
endmodule
