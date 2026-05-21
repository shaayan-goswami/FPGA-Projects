`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 05/21/2026
// Module Name: button_debouncer
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Debounce circuit that filters noisy button signals
//              using a shift register and counter. Toggles an LED
//              on each clean button press.
//////////////////////////////////////////////////////////////////////////////////


module button_debouncer(
    input clk,
    input btn,
    output reg led
);

reg [19:0] counter;
reg btn_sync_0, btn_sync_1;
reg btn_stable;
reg btn_prev;

always @(posedge clk) begin
    btn_sync_0 <= btn;
    btn_sync_1 <= btn_sync_0;
end

always @(posedge clk) begin
    if (btn_sync_1 == btn_stable) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 20'hFFFFF) begin
            btn_stable <= btn_sync_1;
        end
    end
end

always @(posedge clk) begin
    btn_prev <= btn_stable;
    if (btn_stable && !btn_prev)
        led <= ~led;
end

endmodule
