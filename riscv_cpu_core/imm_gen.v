`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: imm_gen
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Extracts and sign-extends immediates from I/S/B/U/J
//              formats per RV32I spec. imm_type selects the format.
//////////////////////////////////////////////////////////////////////////////////
module imm_gen(
    input  [31:0] instr,
    input  [2:0]  imm_type,
    output reg [31:0] imm_out
);

localparam IMM_I = 3'b000;
localparam IMM_S = 3'b001;
localparam IMM_B = 3'b010;
localparam IMM_U = 3'b011;
localparam IMM_J = 3'b100;

always @(*) begin
    case(imm_type)
        // I-type: bits [31:20], sign-extended
        IMM_I: imm_out = {{20{instr[31]}}, instr[31:20]};

        // S-type: bits [31:25] and [11:7], sign-extended
        IMM_S: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        // B-type: bit[31]=sign, [7]=bit11, [30:25]=bits[10:5], [11:8]=bits[4:1], bit0 forced 0
        IMM_B: imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

        // U-type: bits [31:12] placed in upper 20 bits, lower 12 bits zero
        IMM_U: imm_out = {instr[31:12], 12'b0};

        // J-type: bit[31]=sign, [19:12]=bits[19:12], [20]=bit11, [30:21]=bits[10:1], bit0 forced 0
        IMM_J: imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

        default: imm_out = 32'b0;
    endcase
end

endmodule
