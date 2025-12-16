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
            32'd0: instruction = 32'h00100f93;
            32'd4: instruction = 32'h01f02023;
            32'd8: instruction = 32'h01f02423;
            32'd12: instruction = 32'h01f02a23;
            32'd16: instruction = 32'h00900f93;
            32'd20: instruction = 32'h01f02223;
            32'd24: instruction = 32'h01f02623;
            32'd28: instruction = 32'h00800f93;
            32'd32: instruction = 32'h01f02823;
            32'd36: instruction = 32'h00004137;
            32'd40: instruction = 32'h40000093;
            32'd44: instruction = 32'h00600613;
            32'd48: instruction = 32'h0ec5da63;
            32'd52: instruction = 32'hfd010113;
            32'd56: instruction = 32'h00912c23;
            32'd60: instruction = 32'h01212823;
            32'd64: instruction = 32'h01312423;   
            32'd68: instruction = 32'h02112423;   
            32'd72: instruction = 32'h02812023;   
            32'd76: instruction = 32'h00050493;   
            32'd80: instruction = 32'h00060993;   
            32'd84: instruction = 32'h00450913;   
            32'd88: instruction = 32'h00259693;   
            32'd92: instruction = 32'h00d486b3;   
            32'd96: instruction = 32'h0006a803;   
            32'd100: instruction = 32'h00098793;   
            32'd104: instruction = 32'h00058413;   
            32'd108: instruction = 32'h0935d263;   
            32'd112: instruction = 32'h00279713;   
            32'd116: instruction = 32'h00e48733;   
            32'd120: instruction = 32'h00c0006f;   
            32'd124: instruction = 32'hfff78793;   
            32'd128: instruction = 32'h06878463;   
            32'd132: instruction = 32'h00072683;   
            32'd136: instruction = 32'hffc70713;   
            32'd140: instruction = 32'hff06d8e3;   
            32'd144: instruction = 32'h04f45c63;   
            32'd148: instruction = 32'h00279893;   
            32'd152: instruction = 32'h011488b3;   
            32'd156: instruction = 32'h0008a603;   
            32'd160: instruction = 32'h00241713;   
            32'd164: instruction = 32'h00e486b3;   
            32'd168: instruction = 32'h00140413;
            32'd172: instruction = 32'h00c6a023;
            32'd176: instruction = 32'h02f45c63;
            32'd180: instruction = 32'h00e90733;
            32'd184: instruction = 32'h00c0006f;
            32'd188: instruction = 32'h00140413;
            32'd192: instruction = 32'h02878463;
            32'd196: instruction = 32'h00072603;
            32'd200: instruction = 32'h00070693;
            32'd204: instruction = 32'h00470713;
            32'd208: instruction = 32'hff0646e3;
            32'd212: instruction = 32'h00f45e63;
            32'd216: instruction = 32'hfff78793;
            32'd220: instruction = 32'h00c8a023;
            32'd224: instruction = 32'hf8f448e3;
            32'd228: instruction = 32'h00c0006f;
            32'd232: instruction = 32'h00241693;
            32'd236: instruction = 32'h00d486b3;
            32'd240: instruction = 32'h0106a023;
            32'd244: instruction = 32'hfff40613;
            32'd248: instruction = 32'h00048513;
            32'd252: instruction = 32'hf35ff0ef;
            32'd256: instruction = 32'h00140593;
            32'd260: instruction = 32'hf535cae3;
            32'd264: instruction = 32'h02812083;
            32'd268: instruction = 32'h02012403;
            32'd272: instruction = 32'h01812483;
            32'd276: instruction = 32'h01012903;
            32'd280: instruction = 32'h00812983;
            32'd284: instruction = 32'h03010113;
            32'd288: instruction = 32'h00008067;
            32'd292: instruction = 32'h00008067;
            default: instruction = 32'h00000000;
        endcase
    end
endmodule
