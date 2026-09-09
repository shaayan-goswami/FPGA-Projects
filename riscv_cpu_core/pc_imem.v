`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: pc_imem
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Program counter and instruction memory. Advances by 4
//              each cycle unless redirected by branch/jump.
//////////////////////////////////////////////////////////////////////////////////
module pc_imem(
    input         clk,
    input         rst,
    input         pc_src,      // 1 = take branch/jump target
    input  [31:0] pc_target,   // branch/jump destination address
    output reg [31:0] pc,
    output     [31:0] instr
);

// 256 words = 1KB instruction memory, plenty for test programs
reg [31:0] imem [0:255];

// Load program from a hex file at synthesis/simulation time
initial begin
    $readmemh("program.mem", imem);
end

always @(posedge clk) begin
    if (rst)
        pc <= 32'b0;
    else if (pc_src)
        pc <= pc_target;
    else
        pc <= pc + 4;
end

// Word-aligned instruction fetch (pc[31:2] gives the word index)
assign instr = imem[pc[31:2]];

endmodule
