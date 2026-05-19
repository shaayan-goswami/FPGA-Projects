`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 05/19/2026
// Module Name: four_bit_adder
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Combinational 4-bit adder. Takes two 4-bit inputs
//              from onboard switches and displays the sum on LEDs.
//////////////////////////////////////////////////////////////////////////////////


module four_bit_adder(
    input [3:0] a,
    input [3:0] b,
    output [4:0] sum
);
    assign sum = a + b;
endmodule
