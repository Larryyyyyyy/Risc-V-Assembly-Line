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
            32'd4: instruction = 32'h00108093;
            32'd8: instruction = 32'hfea0cee3;
            default: instruction = 32'h00000000;
        endcase
        /*
        0:	00a00513          	addi x10,x0,10
        4:	00108093          	addi x1,x1,1
        8:	fea0cee3          	blt x1,x10,-4
        */
    end
endmodule
