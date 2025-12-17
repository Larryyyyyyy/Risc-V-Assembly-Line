`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/21 21:22:27
// Design Name: Activate predict unit
// Module Name: activate_predict_unit
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


module activate_predict_unit(
        input clk, rstn,
        input [29:0] IF_PC, // PC[31:2]
        input [29:0] EX_PC, // PC[31:2]
        input [31:0] ID_EX_imm,
        input Branch, // 确认是不是 B 型指令
        input jump_taken,
        output reg [31:0] IF_next_PC, EX_next_PC,
        output reg Predict_Flush // 如果 EX 的跳转生效, 那优先级高于 IF 的
    );
    reg [1:0] bht[1023:0]; // 记录跳转历史的表
    reg [51:0] btb[1023:0];
    /* [29:0] 是可能跳转地址的上 30 位 */
    /* [49:30] 是 PC[31:12], 用作 tag 区分 */
    /* [50] 是确认是否为 B 型指令 */
    /* [51] 是 dirty 位 */
    integer i;
    always @* begin
        IF_next_PC = (32'b1 + IF_PC) << 2;
        if (btb[EX_PC[9:0]][51] && btb[IF_PC[9:0]][50] && btb[IF_PC[9:0]][49:30] == IF_PC[29:10]) begin
            if (bht[IF_PC[9:0]] == 2'b10 || bht[IF_PC[9:0]] == 2'b11) begin
                /* 发生跳转 */
                IF_next_PC = (32'b0 + btb[IF_PC[9:0]][29:0]) << 2;
            end
        end
    end
    always @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < 1024; i = i + 1) begin 
                bht[i] <= 2'b0;
                btb[i] <= 52'b0;
            end
        end
        if (!btb[EX_PC[9:0]][51] || btb[EX_PC[9:0]][49:30] != EX_PC[29:10]) begin
            btb[EX_PC[9:0]][51] <= 1;
            btb[EX_PC[9:0]][50] <= Branch;
            btb[EX_PC[9:0]][49:30] <= EX_PC[29:10];
            btb[EX_PC[9:0]][29:0] <= EX_PC + (ID_EX_imm >> 2);
            bht[EX_PC[9:0]][1:0] <= 2'b0;
        end
        if (Branch) begin
            if (jump_taken && bht[EX_PC[9:0]] <= 2'b01) begin
                /* 认为不发生跳转但是发生了跳转 */
                EX_next_PC <= (EX_PC << 2) + ID_EX_imm;
                Predict_Flush <= 1;
                bht[EX_PC[9:0]] <= bht[EX_PC[9:0]] + 2'b01;
            end
            if (!jump_taken && bht[EX_PC[9:0]] <= 2'b01) begin
                /* 认为不发生跳转且未发生跳转 */
                EX_next_PC <= (32'b1 + EX_PC) << 2;
                Predict_Flush <= 0;
                if (bht[EX_PC[9:0]] == 2'b01) bht[EX_PC[9:0]] <= 2'b00;
            end
            if (jump_taken && bht[EX_PC[9:0]] >= 2'b10) begin
                /* 认为发生跳转且发生了跳转 */
                EX_next_PC <= (EX_PC << 2) + ID_EX_imm;
                Predict_Flush <= 0;
                if (bht[EX_PC[9:0]] == 2'b10) bht[EX_PC[9:0]] <= 2'b11;
            end
            if (!jump_taken && bht[EX_PC[9:0]] >= 2'b10) begin
                /* 认为发生跳转但是未发生跳转 */
                EX_next_PC <= (32'b1 + EX_PC) << 2;
                Predict_Flush <= 1;
                bht[EX_PC[9:0]] <= bht[EX_PC[9:0]] - 2'b01;
            end
        end
        else begin
            EX_next_PC <= 32'b0;
            Predict_Flush <= 0;
        end
    end
endmodule
