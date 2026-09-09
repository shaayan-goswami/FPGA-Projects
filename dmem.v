`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: dmem
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Data memory for load/store instructions. 256 words.
//////////////////////////////////////////////////////////////////////////////////
module dmem(
    input         clk,
    input  [31:0] addr,
    input  [31:0] write_data,
    input         mem_write,
    input         mem_read,
    output [31:0] read_data
);

reg [31:0] ram [0:255];

assign read_data = mem_read ? ram[addr[31:2]] : 32'b0;

always @(posedge clk) begin
    if (mem_write)
        ram[addr[31:2]] <= write_data;
end

endmodule