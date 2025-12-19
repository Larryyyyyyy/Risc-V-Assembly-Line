`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/25 13:01:37
// Design Name: Define operator for alu
// Module Name: ALUcontrol
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


module ALUcontrol(
        input [9:0] funct,
        input [1:0] ALUOp,
        output reg [4:0] ALUoperation
    );
    always @* begin
        case(ALUOp)
            2'b00: begin
                ALUoperation = 5'b00000;
            end
            2'b01: begin
                ALUoperation = 5'b00001;
            end
            2'b10: begin
                case(funct)
                    10'b0000000_000: ALUoperation = 5'b00000;
                    10'b0100000_000: ALUoperation = 5'b00001;
                    10'b0000000_001: ALUoperation = 5'b00101;
                    10'b0000000_010: ALUoperation = 5'b10000; // 0 1 2 3 4 5 6 7
                    10'b0000000_011: ALUoperation = 5'b10001;
                    10'b0000000_100: ALUoperation = 5'b00100;
                    10'b0000000_101: ALUoperation = 5'b00110;
                    10'b0100000_101: ALUoperation = 5'b00111;
                    10'b0000000_110: ALUoperation = 5'b00011;
                    10'b0000000_111: ALUoperation = 5'b00010;
                    10'b0000001_000: ALUoperation = 5'b01000;
                    10'b0000001_001: ALUoperation = 5'b01001;
                    10'b0000001_010: ALUoperation = 5'b01010;
                    10'b0000001_011: ALUoperation = 5'b01011;
                    10'b0000001_100: ALUoperation = 5'b01100;
                    10'b0000001_101: ALUoperation = 5'b01101;
                    10'b0000001_110: ALUoperation = 5'b01110;
                    10'b0000001_111: ALUoperation = 5'b01111;
                    default: ALUoperation = 5'b00000;
                endcase
            end
            2'b11: begin
                case(funct[2:0])
                    3'b000: ALUoperation = 5'b00000;
                    3'b001: ALUoperation = 5'b00101;
                    3'b010: ALUoperation = 5'b10000;
                    3'b011: ALUoperation = 5'b10001;
                    3'b100: ALUoperation = 5'b00100;
                    3'b101: begin
                        if (funct[3] == 1'b0) ALUoperation = 5'b00110;
                        else ALUoperation = 5'b00111;
                    end
                    3'b110: ALUoperation = 5'b00011;
                    3'b111: ALUoperation = 5'b00010;
                    default: ALUoperation = 5'b00000;
                endcase
            end
            default: ALUoperation = 5'b00000;
        endcase
    end
endmodule
