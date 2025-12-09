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
            32'd0: instruction = 32'h00500513;    // addi x10, x0, 4
            32'd4: instruction = 32'h06400093;    // addi x1, x0, 100
            32'd8: instruction = 32'h20000113;    // addi x2, x0, 512
            32'd12: instruction = 32'h00100793;   // addi x15, x0, 1
            32'd16: instruction = 32'h04a7f663;   // bgeu x15, x10, 76
            32'd20: instruction = 32'hFF010113;   // addi x2, x2, -16
            32'd24: instruction = 32'h00112623;   // sw x1, 12(x2)
            32'd28: instruction = 32'h00812423;   // sw x8, 8(x2)
            32'd32: instruction = 32'h00912223;   // sw x9, 4(x2)
            32'd36: instruction = 32'h00050413;   // addi x8, x10, 0
            32'd40: instruction = 32'hFFF50513;   // addi x10, x10, -1
            32'd44: instruction = 32'h00000317;   // auipc x6, 0
            32'd48: instruction = 32'hFE0300E7;   // jalr x1, x6, -32
            32'd52: instruction = 32'h00050493;   // addi x9, x10, 0
            32'd56: instruction = 32'hFFE40513;   // addi x10, x8, -2
            32'd60: instruction = 32'h00000317;   // auipc x6, 0
            32'd64: instruction = 32'hFD0300E7;   // jalr x1, x6, -48
            32'd68: instruction = 32'h00A48533;   // add x10, x9, x10
            32'd72: instruction = 32'h00C12083;   // lw x1, 12(x2)
            32'd76: instruction = 32'h00812403;   // lw x8, 8(x2)
            32'd80: instruction = 32'h00412483;   // lw x9, 4(x2)
            32'd84: instruction = 32'h01010113;   // addi x2, x2, 16
            32'd88: instruction = 32'h00008067;   // jalr x0, x1, 0
            32'd92: instruction = 32'h00100513;   // addi x10, x0, 1
            32'd96: instruction = 32'h00008067;   // jalr x0, x1, 0
            default: instruction = 32'h00000000;  // nop
        endcase
    end
endmodule
