`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/21 21:22:27
// Design Name: Algorithm Logic Unit
// Module Name: alu
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


module alu(
        input [3:0] ALUoperation,
        input signed [31:0] A, B,
        output signed [31:0] ALUresult,
        output Zero, Negative, Overflow, Carry
    );
    reg signed [31:0] res;
    always @* begin
        res = 32'b0;
        case(ALUoperation)
            4'b0000: res = A + B;
            4'b0001: res = A - B;
            4'b0010: res = A & B;
            4'b0011: res = A | B;
            4'b0100: res = A ^ B;
            4'b0101: res = A << B;
            4'b0110: res = A >> B;
            4'b0111: res = A >>> B;
            4'b1000: res = A * B;
            4'b1001: res = A * B; // 暂略
            4'b1010: res = A * B; // 暂略
            4'b1011: res = A * B; // 暂略
            4'b1100: res = A / B;
            4'b1101: res = A / B; // 暂略
            4'b1110: res = A % B;
            4'b1111: res = A % B; // 暂略
            default: res = 0;
        endcase
    end
    assign ALUresult = res;
    assign Zero = (res == 32'b0) ? 1'b1 : 1'b0;
    assign Negative = res[31];
    assign Overflow = ((ALUoperation == 4'b0000) && (A[31] == B[31]) && (res[31] != A[31])) ? 1'b1 :
                      ((ALUoperation == 4'b0001) && (A[31] != B[31]) && (res[31] != A[31])) ? 1'b1 : 1'b0;
    assign Carry = ((ALUoperation == 4'b0000) && (res < A)) ? 1'b1 :
                   ((ALUoperation == 4'b0001) && {1'b0, A} < {1'b0, B}) ? 1'b1 : 1'b0;
endmodule
