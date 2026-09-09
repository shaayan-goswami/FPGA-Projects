`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: regfile
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: 32x32-bit register file for RV32I core. x0 hardwired to zero.
//////////////////////////////////////////////////////////////////////////////////
module regfile(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wd,
    input we,
    output [31:0] rd1,
    output [31:0] rd2
);

reg [31:0] regs [0:31];

assign rd1 = (rs1 == 0) ? 32'b0 : regs[rs1];
assign rd2 = (rs2 == 0) ? 32'b0 : regs[rs2];

always @(posedge clk) begin
    if (we && rd != 0)
        regs[rd] <= wd;
end

endmodule
