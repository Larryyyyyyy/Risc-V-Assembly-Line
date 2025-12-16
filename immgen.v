`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/21 22:36:21
// Design Name: Generate imm
// Module Name: immgen
// Project Name: Digital-Design-Lab
// Target Devices: Nexys A7
// Tool Versions: vivado 2023.2
// Description: A simple RISC-V CPU
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module immgen(
        input [31:0] instruction,
        output reg signed [31:0] imm
    );
    always @* begin
        case(instruction[6:0])
            7'b0110011: begin // R
                imm = 32'b0;
            end
            7'b0000011: begin // I_1
                imm = (instruction[31] == 0) ? {20'b0, instruction[31:20]} : {20'hFFFFF, instruction[31:20]};
            end
            7'b0010011: begin // I_2
                if (instruction[14:12] == 3'b001 || instruction[14:12] == 3'b101) imm = {25'b0, instruction[26:20]};
                else imm = (instruction[31] == 0) ? {20'b0, instruction[31:20]} : {20'hFFFFF, instruction[31:20]};
            end
            7'b1100111: begin // jalr
                imm = (instruction[31] == 0) ? {20'b0, instruction[31:20]} : {20'hFFFFF, instruction[31:20]};
            end
            7'b0100011: begin // S
                imm = (instruction[31] == 0) ? {20'b0, instruction[31:25], instruction[11:7]} : {20'hFFFFF, instruction[31:25], instruction[11:7]};
            end
            7'b1100011: begin // SB
                imm = (instruction[31] == 0) ? {19'b0, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0} : {19'h7FFFF, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            7'b1101111: begin // UJ
                imm = (instruction[31] == 0) ? {11'b0, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0} : {11'h7FF, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            7'b0110111: begin // lui
                imm = {instruction[31:12], 12'b0};
            end
            7'b0010111: begin // auipc
                imm = (instruction[31] == 0) ? {instruction[31:12], 12'b0} : {instruction[31:12], 12'hFFF};
            end
            default: begin
                imm = 32'b0;
            end
        endcase
    end
endmodule
