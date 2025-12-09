`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/21 21:56:02
// Design Name: Define most of the control signals
// Module Name: control
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


module control(
        input [6:0] opcode,
        input Control_Flush,
        output reg RegWrite, ALUsrc, MemWrite, MemtoReg, MemRead, Branch, JumpJal, JumpJalr, RegDest, ALUsrcLui, ALUsrcAuipc,
        output reg [1:0] ALUOp
    );
    always @* begin
        if (Control_Flush) begin
            RegWrite = 0;
            ALUsrc = 0;
            MemWrite = 0;
            MemtoReg = 0;
            MemRead = 0;
            Branch = 0;
            JumpJal = 0;
            JumpJalr = 0;
            RegDest = 0;
            ALUsrcLui = 0;
            ALUsrcAuipc = 0;
            ALUOp = 2'b00;
        end
        else case(opcode[6:0])
            7'b0000000: begin
                RegWrite = 0;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b00;
            end
            7'b0110011: begin // R
                RegWrite = 1;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b10;
            end
            7'b0000011: begin // I_1
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 1;
                MemRead = 1;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b00;
            end
            7'b0010011: begin // I_2
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b11;
            end
            7'b0100011: begin // S
                RegWrite = 0;
                ALUsrc = 1;
                MemWrite = 1;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b00;
            end
            7'b1100011: begin // B
                RegWrite = 0;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 1;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b01;
            end
            7'b1100111: begin // jalr
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 1;
                RegDest = 1;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b00;
            end
            7'b1101111: begin // jal
                RegWrite = 1;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 1;
                JumpJalr = 0;
                RegDest = 1;
                ALUsrcLui = 0;
                ALUsrcAuipc = 0;
                ALUOp = 2'b00;
            end
            7'b0110111: begin // lui
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 1;
                ALUsrcAuipc = 0;
                ALUOp = 2'b00;
            end
            7'b0010111: begin // auipc
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                JumpJal = 0;
                JumpJalr = 0;
                RegDest = 0;
                ALUsrcLui = 0;
                ALUsrcAuipc = 1;
                ALUOp = 2'b00;
            end
        endcase
    end
endmodule
