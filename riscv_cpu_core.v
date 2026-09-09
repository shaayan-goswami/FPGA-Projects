`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: riscv_cpu_core
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Top-level RV32I single-cycle CPU. Wires together
//              register file, ALU, control unit, immediate generator,
//              program counter/instruction memory, and data memory.
//              x3/x4 exposed on LEDs via switch-selected 16-bit slices.
//////////////////////////////////////////////////////////////////////////////////
module riscv_cpu_core(
    input clk,
    input rst,
    input sel_reg,        // 0 = view x3, 1 = view x4
    input sel_half,       // 0 = lower 16 bits, 1 = upper 16 bits
    output [15:0] led_out
);

wire [31:0] pc, instr;
wire [31:0] pc_target;
wire pc_src;
wire [6:0] opcode = instr[6:0];
wire [4:0] rd     = instr[11:7];
wire [2:0] funct3 = instr[14:12];
wire [4:0] rs1    = instr[19:15];
wire [4:0] rs2    = instr[24:20];
wire [6:0] funct7 = instr[31:25];
wire [3:0] alu_op;
wire alu_src, reg_write, mem_read, mem_write, mem_to_reg, branch, jump;
wire [2:0] imm_type;
wire [31:0] imm;
wire [31:0] reg_data1, reg_data2;
wire [31:0] alu_b;
wire [31:0] alu_result;
wire zero;
wire [31:0] mem_read_data;
wire [31:0] write_back_data;
wire [31:0] debug_x3;
wire [31:0] debug_x4;

// Instruction fetch
pc_imem u_pc_imem(
    .clk(clk), .rst(rst),
    .pc_src(pc_src), .pc_target(pc_target),
    .pc(pc), .instr(instr)
);

// Decode
control_unit u_control(
    .opcode(opcode), .funct3(funct3), .funct7(funct7),
    .alu_op(alu_op), .alu_src(alu_src), .reg_write(reg_write),
    .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg),
    .branch(branch), .jump(jump), .imm_type(imm_type)
);

imm_gen u_imm_gen(
    .instr(instr), .imm_type(imm_type), .imm_out(imm)
);

regfile u_regfile(
    .clk(clk),
    .rs1(rs1), .rs2(rs2), .rd(rd),
    .wd(write_back_data), .we(reg_write),
    .rd1(reg_data1), .rd2(reg_data2)
);

// Execute
assign alu_b = alu_src ? imm : reg_data2;

alu32 u_alu(
    .a(reg_data1), .b(alu_b), .alu_op(alu_op),
    .result(alu_result), .zero(zero)
);

// Memory
dmem u_dmem(
    .clk(clk),
    .addr(alu_result), .write_data(reg_data2),
    .mem_write(mem_write), .mem_read(mem_read),
    .read_data(mem_read_data)
);

// Write-back
assign write_back_data = mem_to_reg ? mem_read_data : alu_result;

// Branch/jump target resolution
wire branch_taken;
assign branch_taken =
    (funct3 == 3'b000) ? (branch & zero)  :               // BEQ
    (funct3 == 3'b001) ? (branch & ~zero) :               // BNE
    (funct3 == 3'b100) ? (branch & alu_result[0]) :       // BLT (SLT result)
    (funct3 == 3'b101) ? (branch & ~alu_result[0]) :      // BGE
    (funct3 == 3'b110) ? (branch & alu_result[0]) :       // BLTU
    (funct3 == 3'b111) ? (branch & ~alu_result[0]) :      // BGEU
    1'b0;

assign pc_src = branch_taken | jump;
assign pc_target = pc + imm;   // branch/JAL target = pc + offset

// Debug outputs - reach into register file for x3/x4
assign debug_x3 = u_regfile.regs[3];
assign debug_x4 = u_regfile.regs[4];

// Display mux - route selected register/half onto LEDs
wire [31:0] debug_reg = sel_reg ? debug_x4 : debug_x3;
assign led_out = sel_half ? debug_reg[31:16] : debug_reg[15:0];

endmodule