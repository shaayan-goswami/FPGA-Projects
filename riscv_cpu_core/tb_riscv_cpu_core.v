`timescale 1ns / 1ps
module tb_riscv_cpu_core();

reg clk = 0;
reg rst = 1;
wire [31:0] debug_x3;
wire [31:0] debug_x4;

riscv_cpu_core uut(
    .clk(clk),
    .rst(rst),
    .debug_x3(debug_x3),
    .debug_x4(debug_x4)
);

// 100MHz clock
always #5 clk = ~clk;

initial begin
    rst = 1;
    #20;
    rst = 0;

    // Let 6 instructions execute (5 in program + 1 extra cycle margin)
    #100;

    $display("x3 = %d (expected 15)", debug_x3);
    $display("x4 = %d (expected 5)", debug_x4);

    if (debug_x3 == 15 && debug_x4 == 5)
        $display("PASS: CPU executed program.mem correctly");
    else
        $display("FAIL: register values do not match expected results");

    $finish;
end

endmodule
