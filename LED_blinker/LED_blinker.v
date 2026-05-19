`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// 
// Create Date: 05/18/2026
// Module Name: LED_blinker
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Clock divider that blinks an LED at ~1Hz using a 
//              27-bit counter on a 100MHz clock.
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
