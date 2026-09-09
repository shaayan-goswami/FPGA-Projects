`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: alu32
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: 32-bit ALU supporting all RV32I arithmetic/logic operations.
//////////////////////////////////////////////////////////////////////////////////
module alu32(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_op,
    output reg [31:0] result,
    output zero
);

localparam ALU_ADD  = 4'b0000;
localparam ALU_SUB  = 4'b0001;
localparam ALU_AND  = 4'b0010;
localparam ALU_OR   = 4'b0011;
localparam ALU_XOR  = 4'b0100;
localparam ALU_SLL  = 4'b0101; // shift left logical
localparam ALU_SRL  = 4'b0110; // shift right logical
localparam ALU_SRA  = 4'b0111; // shift right arithmetic
localparam ALU_SLT  = 4'b1000; // set less than (signed)
localparam ALU_SLTU = 4'b1001; // set less than (unsigned)

always @(*) begin
    case(alu_op)
        ALU_ADD:  result = a + b;
        ALU_SUB:  result = a - b;
        ALU_AND:  result = a & b;
        ALU_OR:   result = a | b;
        ALU_XOR:  result = a ^ b;
        ALU_SLL:  result = a << b[4:0];
        ALU_SRL:  result = a >> b[4:0];
        ALU_SRA:  result = $signed(a) >>> b[4:0];
        ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
        ALU_SLTU: result = (a < b) ? 32'b1 : 32'b0;
        default:  result = 32'b0;
    endcase
end

assign zero = (result == 32'b0);

endmodule
