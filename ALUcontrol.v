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
        output reg [3:0] ALUoperation
    );
    always @* begin
        case(ALUOp)
            2'b00: begin
                ALUoperation = 4'b0000;
            end
            2'b01: begin
                ALUoperation = 4'b0001;
            end
            2'b10: begin
                case(funct)
                    10'b0000000_000: ALUoperation = 4'b0000;
                    10'b0100000_000: ALUoperation = 4'b0001;
                    10'b0000000_001: ALUoperation = 4'b0101;
                    10'b0000000_100: ALUoperation = 4'b0100;
                    10'b0000000_101: ALUoperation = 4'b0110;
                    10'b0100000_101: ALUoperation = 4'b0111;
                    10'b0000000_110: ALUoperation = 4'b0011;
                    10'b0000000_111: ALUoperation = 4'b0010;
                    10'b0000001_000: ALUoperation = 4'b1000;
                    10'b0000001_001: ALUoperation = 4'b1001;
                    10'b0000001_011: ALUoperation = 4'b1010;
                    10'b0000001_010: ALUoperation = 4'b1011;
                    10'b0000001_100: ALUoperation = 4'b1100;
                    10'b0000001_101: ALUoperation = 4'b1101;
                    10'b0000001_110: ALUoperation = 4'b1110;
                    10'b0000001_111: ALUoperation = 4'b1111;
                    default: ALUoperation = 4'b0000;
                endcase
            end
            2'b11: begin
                case(funct[2:0])
                    3'b000: ALUoperation = 4'b0000;
                    3'b001: ALUoperation = 4'b0101;
                    3'b100: ALUoperation = 4'b0100;
                    3'b101: begin
                        if (funct[3] == 1'b0) ALUoperation = 4'b0110;
                        else ALUoperation = 4'b0111;
                    end
                    3'b110: ALUoperation = 4'b0011;
                    3'b111: ALUoperation = 4'b0010;
                    default: ALUoperation = 4'b0000;
                endcase
            end
            default: ALUoperation = 4'b0000;
        endcase
    end
endmodule
