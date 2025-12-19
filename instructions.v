`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/25 14:38:24
// Design Name: You can use instructions in this module to test your CPU
// Module Name: instructions
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


module instructions(
        input signed [31:0] PC,
        output reg [31:0] instruction
    );
    always @* begin
        case (PC)
            32'd0: instruction = 32'h00a00513;
            32'd4: instruction = 32'h00a02023;
            32'd8: instruction = 32'h01400513;
            32'd12: instruction = 32'h40a02023;
            32'd16: instruction = 32'h01e00513;
            32'd20: instruction = 32'h7e350113;
            32'd24: instruction = 32'hfea12fa3;
            32'd28: instruction = 32'h02800513;
            32'd32: instruction = 32'h3ea12fa3;
            32'd36: instruction = 32'h03200513;
            32'd40: instruction = 32'h7ea12fa3;
            default: instruction = 32'h00000000;
        endcase
        /*
        0:	00a00513          	addi x10,x0,10
        4:  00a02023            sw x10,0(x0)
        8:  01400513            addi x10,x0,20
        12:  40a02023            sw x10,1024(x0)
        16:  01e00513            addi x10,x0,30
        20:  7e350113            addi x2,x10,2019
        24:  fea12fa3            sw x10,-1(x2)
        28:  02800513            addi x10,x0,40
        32:  3ea12fa3            sw x10,1023(x2)
        36:  03200513            addi x10,x0,50
        40:  7ea12fa3            sw x10,2047(x2)
        */
    end
endmodule
