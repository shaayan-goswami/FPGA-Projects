`timescale 1ns / 1ps
// Engineer: Shaayan Goswami
// Create Date: 07/2026
// Module Name: vga_generator
// Project Name: FPGA Projects
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: VGA signal generator producing 640x480 @ 60Hz timing
//              with a colored test pattern.


module vga_generator(
    input clk,
    output hsync,
    output vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
);

// 100MHz -> 25MHz pixel clock (divide by 4)
reg [1:0] clk_div;
reg pixel_clk;
always @(posedge clk) begin
    clk_div <= clk_div + 1;
    if (clk_div == 3)
        pixel_clk <= ~pixel_clk;
end

// 640x480 @ 60Hz timing constants
localparam H_VISIBLE = 640;
localparam H_FRONT   = 16;
localparam H_SYNC    = 96;
localparam H_BACK    = 48;
localparam H_TOTAL   = 800;

localparam V_VISIBLE = 480;
localparam V_FRONT   = 10;
localparam V_SYNC    = 2;
localparam V_BACK    = 33;
localparam V_TOTAL   = 525;

reg [9:0] h_count;
reg [9:0] v_count;

always @(posedge pixel_clk) begin
    if (h_count == H_TOTAL - 1) begin
        h_count <= 0;
        if (v_count == V_TOTAL - 1)
            v_count <= 0;
        else
            v_count <= v_count + 1;
    end else begin
        h_count <= h_count + 1;
    end
end

assign hsync = ~(h_count >= H_VISIBLE + H_FRONT && h_count < H_VISIBLE + H_FRONT + H_SYNC);
assign vsync = ~(v_count >= V_VISIBLE + V_FRONT && v_count < V_VISIBLE + V_FRONT + V_SYNC);

wire visible = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);

// Test pattern: split screen into color bars
assign vgaRed   = visible ? (h_count[8] ? 4'hF : 4'h0) : 4'h0;
assign vgaGreen = visible ? (h_count[7] ? 4'hF : 4'h0) : 4'h0;
assign vgaBlue  = visible ? (v_count[7] ? 4'hF : 4'h0) : 4'h0;

endmodule
