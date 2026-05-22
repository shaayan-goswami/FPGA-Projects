`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 05/22/2026
// Module Name: traffic_light_FSM
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Moore FSM that cycles through red, green, yellow
//              traffic light states. A pedestrian button forces
//              an immediate transition to red.
//////////////////////////////////////////////////////////////////////////////////


module traffic_light_FSM(
    input clk,
    input btn_ped,
    output reg red,
    output reg yellow,
    output reg green
);

reg [26:0] counter;
reg tick;

localparam S_RED    = 2'b00;
localparam S_GREEN  = 2'b01;
localparam S_YELLOW = 2'b10;

reg [1:0] state;

always @(posedge clk) begin
    counter <= counter + 1;
    tick <= (counter == 27'h7FFFFFF);
end

always @(posedge clk) begin
    if (btn_ped) begin
        state <= S_RED;
    end else if (tick) begin
        case(state)
            S_RED:    state <= S_GREEN;
            S_GREEN:  state <= S_YELLOW;
            S_YELLOW: state <= S_RED;
            default:  state <= S_RED;
        endcase
    end
end

always @(*) begin
    red    = 0;
    yellow = 0;
    green  = 0;
    case(state)
        S_RED:    red    = 1;
        S_GREEN:  green  = 1;
        S_YELLOW: yellow = 1;
    endcase
end

endmodule
