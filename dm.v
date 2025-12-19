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
        output [31:0] Read_data,
        output MemReady
    );
    reg [31:0] data[8191:0];
    reg [31:0] R_d;
    integer i;
    always @(negedge clk or negedge rstn) begin
        if (!rstn) for (i = 0; i < 8192; i = i + 1) data[i] <= 32'b0;
        else begin
            if (MemWrite) begin
                case (DMType)
                    3'b000: begin
                        data[Address[31:2]][7:0] <= Write_data[7:0];
                    end
                    3'b001: begin
                        data[Address[31:2]][7:0] <= Write_data[7:0];
                        data[Address[31:2]][15:8] <= Write_data[15:8];
                    end
                    3'b010: begin
                        data[Address[31:2]][7:0] <= Write_data[7:0];
                        data[Address[31:2]][15:8] <= Write_data[15:8];
                        data[Address[31:2]][23:16] <= Write_data[23:16];
                        data[Address[31:2]][31:24] <= Write_data[31:24];
                    end
                endcase
            end
        end
    end
    always @(posedge clk or negedge rstn) begin
        if (!rstn) R_d <= 0;
        else if (MemRead) begin
            case (DMType)
                3'b000: begin
                    R_d <= {{24{data[Address[31:2]][7]}}, data[Address[31:2]][7:0]};
                end
                3'b001: begin
                    R_d <= {{16{data[Address[31:2]][15]}}, data[Address[31:2]][15:0]};
                end
                3'b010: begin
                    R_d <= data[Address[31:2]];
                end
                3'b100: begin
                    R_d <= {24'b0, data[Address[31:2]][7:0]};
                end
                3'b101: begin
                    R_d <= {16'b0, data[Address[31:2]][15:0]};
                end
                3'b110: begin
                    R_d <= data[Address[31:2]];
                end
            endcase
        end
    end
    assign Read_data = R_d;
    assign MemReady = MemRead | MemWrite; // 因为目前我们的主存是一个时钟周期读写数据
endmodule
