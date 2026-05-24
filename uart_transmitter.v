`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 05/24/2026
// Module Name: uart_transmitter
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: UART transmitter that sends "HELLO" over serial
//              at 9600 baud. Readable on a PC terminal over USB.
//////////////////////////////////////////////////////////////////////////////////


module uart_transmitter(
    input clk,
    input btn,
    output reg tx,
    output reg led
);

parameter CLKS_PER_BIT = 10417;

localparam IDLE  = 3'd0;
localparam START = 3'd1;
localparam DATA  = 3'd2;
localparam STOP  = 3'd3;

reg [2:0]  state = IDLE;
reg [13:0] baud_counter = 0;
reg [2:0]  bit_index = 0;
reg [7:0]  tx_data = 0;
reg [2:0]  char_index = 0;
reg        btn_prev = 0;
reg        busy = 0;

reg [7:0] msg [0:4];
initial begin
    msg[0] = 8'h48;
    msg[1] = 8'h45;
    msg[2] = 8'h4C;
    msg[3] = 8'h4C;
    msg[4] = 8'h4F;
end

always @(posedge clk) begin
    btn_prev <= btn;

    case(state)
        IDLE: begin
            tx <= 1;
            baud_counter <= 0;
            bit_index <= 0;
            if (btn && !btn_prev && !busy) begin
                tx_data <= msg[0];
                char_index <= 0;
                state <= START;
                busy <= 1;
            end
        end

        START: begin
            tx <= 0;
            if (baud_counter < CLKS_PER_BIT - 1)
                baud_counter <= baud_counter + 1;
            else begin
                baud_counter <= 0;
                state <= DATA;
            end
        end

        DATA: begin
            tx <= tx_data[bit_index];
            if (baud_counter < CLKS_PER_BIT - 1)
                baud_counter <= baud_counter + 1;
            else begin
                baud_counter <= 0;
                if (bit_index < 7)
                    bit_index <= bit_index + 1;
                else begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end

        STOP: begin
            tx <= 1;
            if (baud_counter < CLKS_PER_BIT - 1)
                baud_counter <= baud_counter + 1;
            else begin
                baud_counter <= 0;
                if (char_index < 4) begin
                    char_index <= char_index + 1;
                    tx_data <= msg[char_index + 1];
                    state <= START;
                end else begin
                    busy <= 0;
                    led <= ~led;
                    state <= IDLE;
                end
            end
        end

        default: state <= IDLE;
    endcase
end

endmodule