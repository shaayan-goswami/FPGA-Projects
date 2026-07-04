`timescale 1ns / 1ps
// Engineer: Shaayan Goswami
// Create Date: 07/04/2026
// Module Name: alu_display
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: 4-bit ALU (add, sub, AND, OR, XOR, shift-left) with
//              result displayed on 7-segment display.


module alu_display(
    input clk,
    input [3:0] a,
    input [3:0] b,
    input [2:0] op,
    output [6:0] seg,
    output [3:0] an
);

reg [4:0] result;

always @(*) begin
    case(op)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = {1'b0, a} << 1;
        default: result = 5'b00000;
    endcase
end

// Split result into two hex digits: ones nibble and tens nibble
wire [3:0] digit0 = result[3:0];        // lower nibble
wire [3:0] digit1 = {3'b000, result[4]}; // upper bit (0 or 1)

// Refresh counter to multiplex between two digits
reg [16:0] refresh_counter;
always @(posedge clk)
    refresh_counter <= refresh_counter + 1;

wire display_select = refresh_counter[16];

reg [3:0] active_digit;
always @(*) begin
    if (display_select)
        active_digit = digit1;
    else
        active_digit = digit0;
end

reg [6:0] seg_pattern;
always @(*) begin
    case(active_digit)
        4'h0: seg_pattern = 7'b0000001;
        4'h1: seg_pattern = 7'b1001111;
        4'h2: seg_pattern = 7'b0010010;
        4'h3: seg_pattern = 7'b0000110;
        4'h4: seg_pattern = 7'b1001100;
        4'h5: seg_pattern = 7'b0100100;
        4'h6: seg_pattern = 7'b0100000;
        4'h7: seg_pattern = 7'b0001111;
        4'h8: seg_pattern = 7'b0000000;
        4'h9: seg_pattern = 7'b0000100;
        4'hA: seg_pattern = 7'b0001000;
        4'hB: seg_pattern = 7'b1100000;
        4'hC: seg_pattern = 7'b0110001;
        4'hD: seg_pattern = 7'b1000010;
        4'hE: seg_pattern = 7'b0110000;
        4'hF: seg_pattern = 7'b0111000;
        default: seg_pattern = 7'b1111111;
    endcase
end

assign seg = seg_pattern;
assign an = display_select ? 4'b1101 : 4'b1110;

endmodule
