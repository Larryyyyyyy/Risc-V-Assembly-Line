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
        input [4:0] ALUoperation,
        input signed [31:0] A, B,
        output signed [31:0] ALUresult,
        output Zero, Negative, Overflow, Carry
    );
    wire [32:0] op1_ext;
    wire [32:0] op2_ext;
    assign op1_ext = (ALUoperation == 5'b01000 || ALUoperation == 5'b01001 || ALUoperation == 5'b01011) ? {A[31], A} : {1'b0, A};
    assign op2_ext = (ALUoperation == 5'b01000 || ALUoperation == 5'b01001) ? {B[31], B} : {1'b0, B};
    wire [65:0] full_result = $signed(op1_ext) * $signed(op2_ext);
    reg signed [31:0] res;
    always @* begin
        res = 32'b0;
        case(ALUoperation)
            5'b00000: res = A + B;
            5'b00001: res = A - B;
            5'b00010: res = A & B;
            5'b00011: res = A | B;
            5'b00100: res = A ^ B;
            5'b00101: res = A << B;
            5'b00110: res = A >> B;
            5'b00111: res = A >>> B;
            5'b01000: res = full_result[31:0];
            5'b01001: res = full_result[63:32];
            5'b01010: res = full_result[63:32];
            5'b01011: res = full_result[63:32];
            5'b01100: res = A / B;
            5'b01101: res = {1'b0, A} / {1'b0, B};
            5'b01110: res = A % B;
            5'b01111: res = {1'b0, A} % {1'b0, B};
            5'b10000: res = A - B;
            5'b10001: res = A - B;
            default: res = 0;
        endcase
    end
    assign Zero = (res == 32'b0) ? 1'b1 : 1'b0;
    assign Negative = res[31];
    assign Overflow = ((ALUoperation == 5'b00000) && (A[31] == B[31]) && (res[31] != A[31])) ? 1'b1 :
                      ((ALUoperation == 5'b00001) && (A[31] != B[31]) && (res[31] != A[31])) ? 1'b1 : 1'b0;
    assign Carry = ((ALUoperation == 5'b00000) && (res < A)) ? 1'b1 :
                   ((ALUoperation == 5'b00001) && {1'b0, A} < {1'b0, B}) ? 1'b1 : 1'b0;
    assign ALUresult = (ALUoperation == 5'b10000) ? (Negative ^ Overflow) :
                       (ALUoperation == 5'b10001) ? Carry : res;
endmodule
