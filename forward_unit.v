`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/12/03 21:49:30
// Design Name: Define forward signals
// Module Name: forward_unit
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


module forward_unit(
    input [4:0] ID_EX_Read_register1, ID_EX_Read_register2,
    input [4:0] EX_MEM_Write_register, MEM_WB_Write_register,
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    input ID_EX_ALUsrc, // 如果它为 1 则忽略 ID_EX_Read_register2 (你妈的怎么 S 型指令是既使用 imm 又使用 rs2 的啊)
    output reg [1:0] ForwardA, ForwardB
);
    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        if (EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0) && (EX_MEM_Write_register == ID_EX_Read_register1))
            ForwardA = 2'b10;
        else if (MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0) && (MEM_WB_Write_register == ID_EX_Read_register1))
            ForwardA = 2'b01;
        if (!ID_EX_ALUsrc && EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0) && (EX_MEM_Write_register == ID_EX_Read_register2))
            ForwardB = 2'b10;
        else if (!ID_EX_ALUsrc && MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0) && (MEM_WB_Write_register == ID_EX_Read_register2))
            ForwardB = 2'b01;
    end
endmodule