`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/12/04 14:59:23
// Design Name: Triple mux
// Module Name: forward_mux
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


module forward_mux(
    input [31:0] A, B, C,
    input [1:0] Forward,
    output [31:0] res
    );
    assign res = (Forward == 2'b00) ? A : (Forward == 2'b01 ? B : C); 
endmodule
