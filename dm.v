`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/21 21:22:27
// Design Name: Data Memory
// Module Name: dm
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


module dm(
        input clk, rstn,
        input MemWrite, MemRead,
        input [2:0] DMType,
        input [31:0] Address, Write_data,
        output [31:0] Read_data
    );
    reg [7:0] data[32767:0];
    reg [31:0] R_d;
    integer i;
    always @(negedge clk or negedge rstn) begin
        if (!rstn) for (i = 0; i < 32768; i = i + 1) data[i] <= 8'b0;
        else begin
            if (MemWrite) begin
                case (DMType)
                    3'b000: begin
                        data[Address] <= Write_data[7:0];
                    end
                    3'b001: begin
                        data[Address] <= Write_data[7:0];
                        data[Address + 1] <= Write_data[15:8];
                    end
                    3'b010: begin
                        data[Address] <= Write_data[7:0];
                        data[Address + 1] <= Write_data[15:8];
                        data[Address + 2] <= Write_data[23:16];
                        data[Address + 3] <= Write_data[31:24];
                    end/*
                    3'b011: begin
                        data[Address] <= Write_data[7:0];
                        data[Address + 1] <= Write_data[15:8];
                        data[Address + 2] <= Write_data[23:16];
                        data[Address + 3] <= Write_data[31:24];
                        data[Address + 4] <= Write_data[39:32];
                        data[Address + 5] <= Write_data[47:40];
                        data[Address + 6] <= Write_data[55:48];
                        data[Address + 7] <= Write_data[63:56];
                    end*/
                endcase
            end
        end
    end
    always @* begin
        if (MemRead) begin
            case (DMType)
                3'b000: begin
                    R_d[31:0] = {{24{data[Address + 3][7]}}, data[Address + 3]};
                end
                3'b001: begin
                    R_d[31:0] = {{16{data[Address + 1][7]}}, data[Address + 1], data[Address]};
                end
                3'b010: begin
                    R_d[31:0] = {data[Address + 3], data[Address + 2], data[Address + 1], data[Address]};
                end/*
                3'b011: begin
                    R_d[63:0] = {data[Address + 7], data[Address + 6], data[Address + 5], data[Address + 4], data[Address + 3], data[Address + 2], data[Address + 1], data[Address]};
                end*/
                3'b100: begin
                    R_d[31:0] = {24'b0, data[Address]};
                end
                3'b101: begin
                    R_d[31:0] = {16'b0, data[Address + 1], data[Address]};
                end
                3'b110: begin
                    R_d[31:0] = {data[Address + 3], data[Address + 2], data[Address + 1], data[Address]};
                end
            endcase
        end
    end
    assign Read_data = R_d[31:0];
endmodule
