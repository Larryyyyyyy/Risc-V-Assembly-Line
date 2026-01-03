`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/12/19 12:09:02
// Design Name: L1 Cache
// Module Name: cache
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

`define IDLE 2'b00
`define WRITE_BACK 2'b01
`define REFILL 2'b10

module cache(
        input clk, rstn,
        input CacheWrite, CacheRead,
        input [2:0] DMType,
        input [31:0] Address,
        input [31:0] Write_data,
        output stall,
        output reg [31:0] Read_data
    );
    reg [55:0] cache[255:0][3:0]; // 这里做了一个假定: 目前字节寻址都是 4 字节对齐, 所以后 2 位都是 0
    /* [31:0] 是存储的数据 */
    /* [53:32] 是高 22 位的 tag */
    /* [54] 是有效位 valid */
    /* [55] 是脏位 dirty */
    reg [4:0] LRU[255:0];
    /* 神秘 LRU 策略用到的 */
    reg [1:0] state;
    wire hit = (cache[Address[9:2]][0][54] && cache[Address[9:2]][0][53:32] == Address[31:10]) |
               (cache[Address[9:2]][1][54] && cache[Address[9:2]][1][53:32] == Address[31:10]) |
               (cache[Address[9:2]][2][54] && cache[Address[9:2]][2][53:32] == Address[31:10]) |
               (cache[Address[9:2]][3][54] && cache[Address[9:2]][3][53:32] == Address[31:10]);
    reg MemRead, MemWrite;
    wire MemReady;
    wire [31:0] MemData;
    wire [31:0] MemWriteData = cache[Address[9:2]][LRU[Address[9:2]] / 6][31:0];
    wire [31:0] MemAddress = {cache[Address[9:2]][LRU[Address[9:2]] / 6][53:32], Address[9:2], 2'b00};
    dm u_dm(
        .clk(clk),
        .rstn(rstn),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .DMType(DMType),
        .Address(MemAddress),
        .Write_data(MemWriteData),
        .Read_data(MemData),
        .MemReady(MemReady)
    );
    integer i;
    integer j;
    assign stall = ((state != `IDLE) || ((MemRead || MemWrite) && !hit)) ? 1 : 0;
    always @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < 256; i = i + 1) begin
                LRU[i] <= 5'b0;
            end
            for (i = 0; i < 256; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    cache[i][j] <= 56'b0;
                end
            end
            state <= 2'b00;
            MemRead <= 0;
            MemWrite <= 0;
        end
        else case (state)
            `IDLE: begin
                if (hit) begin
                    if (CacheRead) begin
                        /* 读 cache */
                        for (i = 0; i < 4; i = i + 1) begin
                            if (cache[Address[9:2]][i][54] && cache[Address[9:2]][i][53:32] == Address[31:10]) begin
                                Read_data <= cache[Address[9:2]][i][31:0];
                                if (LRU[Address[9:2]] < 6) begin
                                    case (LRU[Address[9:2]])
                                        0: LRU[Address[9:2]] <= 9;
                                        1: LRU[Address[9:2]] <= 11;
                                        2: LRU[Address[9:2]] <= 15;
                                        3: LRU[Address[9:2]] <= 17;
                                        4: LRU[Address[9:2]] <= 21;
                                        5: LRU[Address[9:2]] <= 23;
                                    endcase
                                end else if (LRU[Address[9:2]] < 12) begin
                                    case (LRU[Address[9:2]])
                                        6: LRU[Address[9:2]] <= 3;
                                        7: LRU[Address[9:2]] <= 5;
                                        8: LRU[Address[9:2]] <= 13;
                                        9: LRU[Address[9:2]] <= 16;
                                        10: LRU[Address[9:2]] <= 19;
                                        11: LRU[Address[9:2]] <= 22;
                                    endcase
                                end
                                else if (LRU[Address[9:2]] < 18) begin
                                    case (LRU[Address[9:2]])
                                        12: LRU[Address[9:2]] <= 1;
                                        13: LRU[Address[9:2]] <= 4;
                                        14: LRU[Address[9:2]] <= 7;
                                        15: LRU[Address[9:2]] <= 10;
                                        16: LRU[Address[9:2]] <= 18;
                                        17: LRU[Address[9:2]] <= 20;
                                    endcase
                                end
                                else if (LRU[Address[9:2]] < 24) begin
                                    case (LRU[Address[9:2]])
                                        18: LRU[Address[9:2]] <= 0;
                                        19: LRU[Address[9:2]] <= 2;
                                        20: LRU[Address[9:2]] <= 6;
                                        21: LRU[Address[9:2]] <= 8;
                                        22: LRU[Address[9:2]] <= 12;
                                        23: LRU[Address[9:2]] <= 14;
                                    endcase
                                end
                            end
                        end
                    end
                    else if (CacheWrite) begin
                        /* 写 cache */
                        for (i = 0; i < 4; i = i + 1) begin
                            if (cache[Address[9:2]][i][54] && cache[Address[9:2]][i][53:32] == Address[31:10]) begin
                                cache[Address[9:2]][i][31:0] <= Write_data;
                                cache[Address[9:2]][i][55] <= 1'b1;
                                if (LRU[Address[9:2]] < 6) begin
                                    case (LRU[Address[9:2]])
                                        0: LRU[Address[9:2]] <= 9;
                                        1: LRU[Address[9:2]] <= 11;
                                        2: LRU[Address[9:2]] <= 15;
                                        3: LRU[Address[9:2]] <= 17;
                                        4: LRU[Address[9:2]] <= 21;
                                        5: LRU[Address[9:2]] <= 23;
                                    endcase
                                end else if (LRU[Address[9:2]] < 12) begin
                                    case (LRU[Address[9:2]])
                                        6: LRU[Address[9:2]] <= 3;
                                        7: LRU[Address[9:2]] <= 5;
                                        8: LRU[Address[9:2]] <= 13;
                                        9: LRU[Address[9:2]] <= 16;
                                        10: LRU[Address[9:2]] <= 19;
                                        11: LRU[Address[9:2]] <= 22;
                                    endcase
                                end
                                else if (LRU[Address[9:2]] < 18) begin
                                    case (LRU[Address[9:2]])
                                        12: LRU[Address[9:2]] <= 1;
                                        13: LRU[Address[9:2]] <= 4;
                                        14: LRU[Address[9:2]] <= 7;
                                        15: LRU[Address[9:2]] <= 10;
                                        16: LRU[Address[9:2]] <= 18;
                                        17: LRU[Address[9:2]] <= 20;
                                    endcase
                                end
                                else if (LRU[Address[9:2]] < 24) begin
                                    case (LRU[Address[9:2]])
                                        18: LRU[Address[9:2]] <= 0;
                                        19: LRU[Address[9:2]] <= 2;
                                        20: LRU[Address[9:2]] <= 6;
                                        21: LRU[Address[9:2]] <= 8;
                                        22: LRU[Address[9:2]] <= 12;
                                        23: LRU[Address[9:2]] <= 14;
                                    endcase
                                end
                            end
                        end
                    end
                end
                else if (CacheRead || CacheWrite) begin
                    if (LRU[Address[9:2]] < 6) begin
                        if (cache[Address[9:2]][0][55]) state <= `WRITE_BACK;
                        else state <= `REFILL;
                    end
                    else if (LRU[Address[9:2]] < 12) begin
                        if (cache[Address[9:2]][1][55]) state <= `WRITE_BACK;
                        else state <= `REFILL;
                    end
                    else if (LRU[Address[9:2]] < 18) begin
                        if (cache[Address[9:2]][2][55]) state <= `WRITE_BACK;
                        else state <= `REFILL;
                    end
                    else if (LRU[Address[9:2]] < 24) begin
                        if (cache[Address[9:2]][3][55]) state <= `WRITE_BACK;
                        else state <= `REFILL;
                    end
                end 
            end
            `WRITE_BACK: begin
                MemRead <= 0;
                if (MemReady) begin
                    MemWrite <= 0;
                    state <= `REFILL;
                end
                else begin
                    MemWrite <= 1;
                    state <= `WRITE_BACK;
                end
            end
            `REFILL: begin
                if (CacheWrite) begin
                    MemRead <= 0;
                    MemWrite <= 0;
                    if (LRU[Address[9:2]] < 6) begin
                        cache[Address[9:2]][0][31:0] <= Write_data;
                        cache[Address[9:2]][0][53:32] <= Address[31:10];
                        cache[Address[9:2]][0][54] <= 1;
                        cache[Address[9:2]][0][55] <= 1;
                        case (LRU[Address[9:2]])
                            0: LRU[Address[9:2]] <= 9;
                            1: LRU[Address[9:2]] <= 11;
                            2: LRU[Address[9:2]] <= 15;
                            3: LRU[Address[9:2]] <= 17;
                            4: LRU[Address[9:2]] <= 21;
                            5: LRU[Address[9:2]] <= 23;
                        endcase
                    end else if (LRU[Address[9:2]] < 12) begin
                        cache[Address[9:2]][1][31:0] <= Write_data;
                        cache[Address[9:2]][1][53:32] <= Address[31:10];
                        cache[Address[9:2]][1][54] <= 1;
                        cache[Address[9:2]][1][55] <= 1;
                        case (LRU[Address[9:2]])
                            6: LRU[Address[9:2]] <= 3;
                            7: LRU[Address[9:2]] <= 5;
                            8: LRU[Address[9:2]] <= 13;
                            9: LRU[Address[9:2]] <= 16;
                            10: LRU[Address[9:2]] <= 19;
                            11: LRU[Address[9:2]] <= 22;
                        endcase
                    end
                    else if (LRU[Address[9:2]] < 18) begin
                        cache[Address[9:2]][2][31:0] <= Write_data;
                        cache[Address[9:2]][2][53:32] <= Address[31:10];
                        cache[Address[9:2]][2][54] <= 1;
                        cache[Address[9:2]][2][55] <= 1;
                        case (LRU[Address[9:2]])
                            12: LRU[Address[9:2]] <= 1;
                            13: LRU[Address[9:2]] <= 4;
                            14: LRU[Address[9:2]] <= 7;
                            15: LRU[Address[9:2]] <= 10;
                            16: LRU[Address[9:2]] <= 18;
                            17: LRU[Address[9:2]] <= 20;
                        endcase
                    end
                    else if (LRU[Address[9:2]] < 24) begin
                        cache[Address[9:2]][3][31:0] <= Write_data;
                        cache[Address[9:2]][3][53:32] <= Address[31:10];
                        cache[Address[9:2]][3][54] <= 1;
                        cache[Address[9:2]][3][55] <= 1;
                        case (LRU[Address[9:2]])
                            18: LRU[Address[9:2]] <= 0;
                            19: LRU[Address[9:2]] <= 2;
                            20: LRU[Address[9:2]] <= 6;
                            21: LRU[Address[9:2]] <= 8;
                            22: LRU[Address[9:2]] <= 12;
                            23: LRU[Address[9:2]] <= 14;
                        endcase
                    end
                    state <= `IDLE;
                end
                else if (CacheRead) begin
                    MemWrite <= 0;
                    if (MemReady) begin
                        MemRead <= 0;
                        Read_data <= MemData;
                        if (LRU[Address[9:2]] < 6) begin
                            cache[Address[9:2]][0][31:0] <= MemData;
                            cache[Address[9:2]][0][53:32] <= Address[31:10];
                            cache[Address[9:2]][0][54] <= 1;
                            cache[Address[9:2]][0][55] <= 0;
                            case (LRU[Address[9:2]])
                                0: LRU[Address[9:2]] <= 9;
                                1: LRU[Address[9:2]] <= 11;
                                2: LRU[Address[9:2]] <= 15;
                                3: LRU[Address[9:2]] <= 17;
                                4: LRU[Address[9:2]] <= 21;
                                5: LRU[Address[9:2]] <= 23;
                            endcase
                        end
                        else if (LRU[Address[9:2]] < 12) begin
                            cache[Address[9:2]][1][31:0] <= MemData;
                            cache[Address[9:2]][1][53:32] <= Address[31:10];
                            cache[Address[9:2]][1][54] <= 1;
                            cache[Address[9:2]][1][55] <= 0;
                            case (LRU[Address[9:2]])
                                6: LRU[Address[9:2]] <= 3;
                                7: LRU[Address[9:2]] <= 5;
                                8: LRU[Address[9:2]] <= 13;
                                9: LRU[Address[9:2]] <= 16;
                                10: LRU[Address[9:2]] <= 19;
                                11: LRU[Address[9:2]] <= 22;
                            endcase
                        end
                        else if (LRU[Address[9:2]] < 18) begin
                            cache[Address[9:2]][2][31:0] <= MemData;
                            cache[Address[9:2]][2][53:32] <= Address[31:10];
                            cache[Address[9:2]][2][54] <= 1;
                            cache[Address[9:2]][2][55] <= 0;
                            case (LRU[Address[9:2]])
                                12: LRU[Address[9:2]] <= 1;
                                13: LRU[Address[9:2]] <= 4;
                                14: LRU[Address[9:2]] <= 7;
                                15: LRU[Address[9:2]] <= 10;
                                16: LRU[Address[9:2]] <= 18;
                                17: LRU[Address[9:2]] <= 20;
                            endcase
                        end
                        else if (LRU[Address[9:2]] < 24) begin
                            cache[Address[9:2]][3][31:0] <= MemData;
                            cache[Address[9:2]][3][53:32] <= Address[31:10];
                            cache[Address[9:2]][3][54] <= 1;
                            cache[Address[9:2]][3][55] <= 0;
                            case (LRU[Address[9:2]])
                                18: LRU[Address[9:2]] <= 0;
                                19: LRU[Address[9:2]] <= 2;
                                20: LRU[Address[9:2]] <= 6;
                                21: LRU[Address[9:2]] <= 8;
                                22: LRU[Address[9:2]] <= 12;
                                23: LRU[Address[9:2]] <= 14;
                            endcase
                        end
                        state <= `IDLE;
                    end
                    else begin
                        MemRead <= 1;
                        state <= `REFILL;
                    end
                end
            end
        endcase
    end
endmodule

/*
0123 -> 1230  0 -> 9
0132 -> 1320  1 -> 11
0213 -> 2130  2 -> 15
0231 -> 2310  3 -> 17
0312 -> 3120  4 -> 21
0321 -> 3210  5 -> 23

1023 -> 0231  6 -> 3
1032 -> 0321  7 -> 5
1203 -> 2031  8 -> 13
1230 -> 2301  9 -> 16
1302 -> 3021  10-> 19
1320 -> 3201  11-> 22

2013 -> 0132  12-> 1
2031 -> 0312  13-> 4
2103 -> 1032  14-> 7
2130 -> 1302  15-> 10
2301 -> 3012  16-> 18
2310 -> 3102  17-> 20

3012 -> 0123  18-> 0
3021 -> 0213  19-> 2
3102 -> 1023  20-> 6
3120 -> 1203  21-> 8
3201 -> 2013  22-> 12
3210 -> 2103  23-> 14
*/