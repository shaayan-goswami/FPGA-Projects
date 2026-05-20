`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 05/20/2026
// Module Name: seven_seg_counter
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Sequential counter that displays 0-9 on the 
//              7-segment display, incrementing roughly once per second
//              using a 27-bit clock divider on the 100MHz clock.
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_counter(
    input clk,
    output reg [6:0] seg,
    output reg [3:0] an
);

reg [26:0] counter;
reg [3:0] digit;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 27'h7FFFFFF)
        digit <= (digit == 4'd9) ? 4'd0 : digit + 4'd1;
end

always @(*) begin
    an = 4'b1110;
    case(digit)
        4'd0: seg = 7'b0000001;
        4'd1: seg = 7'b1001111;
        4'd2: seg = 7'b0010010;
        4'd3: seg = 7'b0000110;
        4'd4: seg = 7'b1001100;
        4'd5: seg = 7'b0100100;
        4'd6: seg = 7'b0100000;
        4'd7: seg = 7'b0001111;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0000100;
        default: seg = 7'b1111111;
    endcase
end

endmodule
