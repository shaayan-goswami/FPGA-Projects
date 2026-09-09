`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shaayan Goswami
// Create Date: 09/08/2026
// Module Name: control_unit
// Project Name: FPGA Projects - RISC-V Capstone
// Target Devices: Basys 3 Artix-7 (xc7a35tcpg236-1)
// Description: Instruction decoder for RV32I. Reads opcode/funct3/funct7
//              and generates control signals for the datapath.
//////////////////////////////////////////////////////////////////////////////////
module control_unit(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_op,
    output reg       alu_src,     // 0 = use rs2, 1 = use immediate
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,  // 0 = ALU result to rd, 1 = memory data to rd
    output reg       branch,
    output reg       jump,
    output reg [2:0] imm_type     // selects immediate decode format
);

// Opcodes
localparam OP_RTYPE  = 7'b0110011;
localparam OP_ITYPE  = 7'b0010011; // arithmetic immediate
localparam OP_LOAD   = 7'b0000011;
localparam OP_STORE  = 7'b0100011;
localparam OP_BRANCH = 7'b1100011;
localparam OP_JAL    = 7'b1101111;
localparam OP_JALR   = 7'b1100111;
localparam OP_LUI    = 7'b0110111;
localparam OP_AUIPC  = 7'b0010111;

// imm_type encoding
localparam IMM_I = 3'b000;
localparam IMM_S = 3'b001;
localparam IMM_B = 3'b010;
localparam IMM_U = 3'b011;
localparam IMM_J = 3'b100;

// alu_op encoding (matches alu32.v)
localparam ALU_ADD  = 4'b0000;
localparam ALU_SUB  = 4'b0001;
localparam ALU_AND  = 4'b0010;
localparam ALU_OR   = 4'b0011;
localparam ALU_XOR  = 4'b0100;
localparam ALU_SLL  = 4'b0101;
localparam ALU_SRL  = 4'b0110;
localparam ALU_SRA  = 4'b0111;
localparam ALU_SLT  = 4'b1000;
localparam ALU_SLTU = 4'b1001;

always @(*) begin
    // Safe defaults every cycle - prevents latches, prevents
    // accidental writes on unrecognized opcodes
    alu_op     = ALU_ADD;
    alu_src    = 0;
    reg_write  = 0;
    mem_read   = 0;
    mem_write  = 0;
    mem_to_reg = 0;
    branch     = 0;
    jump       = 0;
    imm_type   = IMM_I;

    case(opcode)

        OP_RTYPE: begin
            alu_src   = 0;
            reg_write = 1;
            case(funct3)
                3'b000: alu_op = (funct7 == 7'b0100000) ? ALU_SUB : ALU_ADD;
                3'b001: alu_op = ALU_SLL;
                3'b010: alu_op = ALU_SLT;
                3'b011: alu_op = ALU_SLTU;
                3'b100: alu_op = ALU_XOR;
                3'b101: alu_op = (funct7 == 7'b0100000) ? ALU_SRA : ALU_SRL;
                3'b110: alu_op = ALU_OR;
                3'b111: alu_op = ALU_AND;
            endcase
        end

        OP_ITYPE: begin
            alu_src   = 1;
            reg_write = 1;
            imm_type  = IMM_I;
            case(funct3)
                3'b000: alu_op = ALU_ADD;               // ADDI
                3'b010: alu_op = ALU_SLT;                // SLTI
                3'b011: alu_op = ALU_SLTU;               // SLTIU
                3'b100: alu_op = ALU_XOR;                // XORI
                3'b110: alu_op = ALU_OR;                 // ORI
                3'b111: alu_op = ALU_AND;                // ANDI
                3'b001: alu_op = ALU_SLL;                // SLLI
                3'b101: alu_op = (funct7 == 7'b0100000) ? ALU_SRA : ALU_SRL; // SRLI/SRAI
            endcase
        end

        OP_LOAD: begin
            alu_src    = 1;
            alu_op     = ALU_ADD;   // address = rs1 + imm
            reg_write  = 1;
            mem_read   = 1;
            mem_to_reg = 1;
            imm_type   = IMM_I;
        end

        OP_STORE: begin
            alu_src   = 1;
            alu_op    = ALU_ADD;    // address = rs1 + imm
            mem_write = 1;
            imm_type  = IMM_S;
        end

        OP_BRANCH: begin
            alu_src  = 0;
            branch   = 1;
            imm_type = IMM_B;
            case(funct3)
                3'b000: alu_op = ALU_SUB;  // BEQ  - check zero flag
                3'b001: alu_op = ALU_SUB;  // BNE  - check !zero flag
                3'b100: alu_op = ALU_SLT;  // BLT
                3'b101: alu_op = ALU_SLT;  // BGE  - check !result
                3'b110: alu_op = ALU_SLTU; // BLTU
                3'b111: alu_op = ALU_SLTU; // BGEU - check !result
            endcase
        end

        OP_JAL: begin
            jump      = 1;
            reg_write = 1;
            imm_type  = IMM_J;
        end

        OP_JALR: begin
            jump      = 1;
            reg_write = 1;
            alu_src   = 1;
            alu_op    = ALU_ADD;
            imm_type  = IMM_I;
        end

        OP_LUI: begin
            reg_write = 1;
            imm_type  = IMM_U;
        end

        OP_AUIPC: begin
            reg_write = 1;
            imm_type  = IMM_U;
        end

    endcase
end

endmodule
