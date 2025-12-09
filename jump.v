`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/25 13:42:24
// Design Name: If it satisfies the jump condition
// Module Name: jump
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


module jump(
        input Zero, Negative, Overflow, Carry,
        input [2:0] funct3,
        output reg jump_taken
    );
    always @* begin
        case (funct3)
            3'b000: jump_taken = Zero;
            3'b001: jump_taken = ~Zero;
            3'b100: jump_taken = Negative ^ Overflow;
            3'b101: jump_taken = ~Zero & ~(Negative ^ Overflow);
            3'b110: jump_taken = Carry;
            3'b111: jump_taken = ~Carry;
            default: jump_taken = 1'b0;
        endcase
    end
endmodule
