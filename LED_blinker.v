`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 03:51:59 PM
// Design Name: 
// Module Name: LED_blinker
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LED_blinker(
    input clk,
    output reg led
);

reg [26:0] counter;

always @(posedge clk) begin
    counter <= counter + 1;
    led <= counter[26];
end
endmodule
