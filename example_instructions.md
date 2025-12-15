# 斐波那契数列
```c
int f(int x){
    if(x<=0)return 1;
    return f(x-2)+f(x-1);
}
```

参考汇编代码

```
0x0     0x00100793    addi x15 x0 1      li a5,1
0x4     0x04A7F663    bgeu x15 x10 76    bleu a0,a5,.L3
0x8     0xFF010113    addi x2 x2 -16     addi sp,sp,-16
0xc     0x00112623    sw x1 12(x2)       sw ra,12(sp)
0x10    0x00812423    sw x8 8(x2)        sw s0,8(sp)
0x14    0x00912223    sw x9 4(x2)        sw s1,4(sp)
0x18    0x00050413    addi x8 x10 0      mv s0,a0
0x1c    0xFFF50513    addi x10 x10 -1    addi a0,a0,-1
0x20    0x00000317    auipc x6 0         call fib
0x24    0xFE0300E7    jalr x1 x6 -32     call fib
0x28    0x00050493    addi x9 x10 0      mv s1,a0
0x2c    0xFFE40513    addi x10 x8 -2     addi a0,s0,-2
0x30    0x00000317    auipc x6 0         call fib
0x34    0xFD0300E7    jalr x1 x6 -48     call fib
0x38    0x00A48533    add x10 x9 x10     add a0,s1,a0
0x3c    0x00C12083    lw x1 12(x2)       lw ra,12(sp)
0x40    0x00812403    lw x8 8(x2)        lw s0,8(sp)
0x44    0x00412483    lw x9 4(x2)        lw s1,4(sp)
0x48    0x01010113    addi x2 x2 16      addi sp,sp,16
0x4c    0x00008067    jalr x0 x1 0       jr ra
0x50    0x00100513    addi x10 x0 1      li a0,1
0x54    0x00008067    jalr x0 x1 0       ret
```

适合写入`instructions.v`的部分

```
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
```

# 数据冒险
```
32'd0: instruction = 32'b00000000101100000000000010010011;    // addi x1, x0, 11
32'd4: instruction = 32'b00000001011000000000000100010011;    // addi x2, x0, 22
32'd8: instruction = 32'b00000000000000000000000000000000;    // nop
32'd12: instruction = 32'b00000000000000000000000000000000;   // nop
32'd16: instruction = 32'b00000000000000000000000000000000;   // nop
32'd20: instruction = 32'b00000000000000000000000000000000;   // nop
32'd24: instruction = 32'b00000000000000000000000000000000;   // nop
32'd28: instruction = 32'b00000000010100010000000010010011;   // addi x1, x2, 5
32'd32: instruction = 32'b00000000001000001000000110110011;   // add x3, x1, x2
32'd36: instruction = 32'b00000000111100001000001000010011;   // addi x4, x1, 15
32'd40: instruction = 32'b00000000000100001000001010110011;   // add x5, x1, x1
default: instruction = 32'b00000000000000000000000000000000;
```

# 快速幂
```c
int f(int x, int y){
    if (y == 0) return 1;
    if (y == 1) return x;
    return f(x * x, y >> 1) * ((y & 1) ? x : 1);
}
```

```
0: 1045c: 40000093          	addi x1,x0,1024
4: 10460: 20000113          	addi x2, x0, 512
8: 10464: 00200513          	addi x10, x0, 2
12: 10468: 00a00593          	addi x11, x0, 10
16: 1046c: 0c058263          	beq x11,x0,10530 <f+0xc4>
20: 10470: 00100693          	addi x13,x0,1
24: 10474: 00050713          	addi x14,x10,0
28: 10478: 0ad58a63          	beq x11,x13,1052c <f+0xc0>
32: 1047c: 02a50833          	mul x16,x10,x10
36: 10480: 4015d613          	srai x12,x11,1
40: 10484: 00058793          	addi x15,x11,0
44: 10488: 00080513          	addi x10,x16,0
48: 1048c: 08d60a63          	beq x12,x13,10520 <f+0xb4>
52: 10490: 03080533          	mul x10,x16,x16
56: 10494: 4025d893          	srai x17,x11,2
60: 10498: 00050313          	addi x6,x10,0
64: 1049c: 06d88c63          	beq x17,x13,10514 <f+0xa8>
68: 104a0: 02a50533          	mul x10,x10,x10
72: 104a4: fc010113          	addi x2,x2,-64
76: 104a8: 4035d593          	srai x11,x11,0x3
80: 104ac: 00e12c23          	sw x14,24(x2)
84: 104b0: 00c12823          	sw x12,16(x2)
88: 104b4: 01012423          	sw x16,8(x2)
92: 104b8: 00f12023          	sw x15,0(x2)
96: 104bc: 03112023          	sw x17,32(x2)
100: 104c0: 02112c23          	sw x1,56(x2)
104: 104c4:	02612423          	sw x6,40(x2)
108: 104c8:	fa5ff0ef          	jal x1,-92
112: 104cc:	02012883          	lw x17,32(x2)
116: 104d0:	00012783          	lw x15,0(x2)
120: 104d4:	00812803          	lw x16,8(x2)
124: 104d8:	0018f893          	andi x17,x17,1
128: 104dc:	01012603          	lw x12,16(x2)
132: 104e0:	01812703          	lw x14,24(x2)
136: 104e4:	00088663          	beq x17,x0,104f0 <f+0x84>
140: 104e8:	02812303          	lw x6,40(x2)
144: 104ec:	02a30533          	mul x10,x6,x10
148: 104f0:	00167613          	andi x12,x12,1
152: 104f4:	00060463          	beq x12,x0,104fc <f+0x90>
156: 104f8:	02a80533          	mul x10,x16,x10
160: 104fc:	0017f593          	andi x11,x15,1
164: 10500:	00058463          	beq x11,x0,10508 <f+0x9c>
168: 10504:	02a70533          	mul x10,x14,x10
172: 10508:	03812083          	lw x1,56(x2)
176: 1050c:	04010113          	addi x2,x2,64
180: 10510:	00008067          	jalr x0,0(x1)
184: 10514:	00167613          	andi x12,x12,1
188: 10518:	00060463          	beq x12,x0,10520 <f+0xb4>
192: 1051c:	02a80533          	mul x10,x16,x10
196: 10520:	0017f593          	andi x11,x15,1
200: 10524:	00058463          	beq x11,x0,1052c <f+0xc0>
204: 10528:	02a70533          	mul x10,x14,x10
208: 1052c:	00008067          	jalr x0,0(x1)
212: 10530:	00100513          	addi x10,x0,1
216: 10534:	00008067          	jalr x0,0(x1)
```

# 欧几里得求最大公约数

```
0:  06400093            addi x1,x0,100
4:  10000113            addi x2,x0,256
8:  06400513            addi x10,x0,100
12: 04600593            addi x11,x0,70
16: 00058793          	addi x15,x11,0
20: 02b565b3          	rem x11,x10,x11
24: 00078513          	addi x10,x15,0
28: 00059863          	bne x11,x0,-12
32: 00008067          	jalr x0,0(x1)
```

# 选择排序

```
0: addi x3,x0,20
4: addi x15,x0,1
8: sw x15,0(x3)
12: addi x15,x0,1
16: sw x15,-4(x3)
20: addi x15,x0,4
24: sw x15,-8(x3)
28: addi x15,x0,5
32: sw x15,-12(x3)
36: addi x15,x0,1
40: sw x15,-16(x3)
44: addi x15,x0,4
48: sw x15,-20(x3)
52: jal x1, 8
56: jalr x0,0(x1)
60: addi x12,x0,4
64: addi x11,x3,0
68: addi x10,x0,1
72: addi x16,x0,6
76: add x15,x12,x0
80: lw x13,0(x15)
84: lw x14,-4(x12)
88: bge x13,x14,12
92: sw x13,-4(x12)
96: sw x14,0(x15)
100: addi x15,x15,4
104: bne x11,x15,-24
108: addi x10,x10,1
112: addi x12,x12,4
116: bne x10,x16,-40
120: jalr x0,0(x1)
```

```
32'd0: instruction = 32'h01400193;
32'd4: instruction = 32'h00100793;
32'd8: instruction = 32'h00f1a023;
32'd12: instruction = 32'h00100793;
32'd16: instruction = 32'hfef1ae23;   
32'd20: instruction = 32'h00400793;   
32'd24: instruction = 32'hfef1ac23;   
32'd28: instruction = 32'h00500793;   
32'd32: instruction = 32'hfef1aa23;   
32'd36: instruction = 32'h00100793;   
32'd40: instruction = 32'hfef1a823;   
32'd44: instruction = 32'h00400793;   
32'd48: instruction = 32'hfef1a623;   
32'd52: instruction = 32'h008000ef;   
32'd56: instruction = 32'h00008067;   
32'd60: instruction = 32'h00400613;   
32'd64: instruction = 32'h00018593;   
32'd68: instruction = 32'h00100513;   
32'd72: instruction = 32'h00600813;   
32'd76: instruction = 32'h000607b3;   
32'd80: instruction = 32'h0007a683;   
32'd84: instruction = 32'hffc62703;   
32'd88: instruction = 32'h00e6d663;   
32'd92: instruction = 32'hfed62e23;   
32'd96: instruction = 32'h00e7a023;   
32'd100: instruction = 32'h00478793;   
32'd104: instruction = 32'hfef594e3;   
32'd108: instruction = 32'h00150513;   
32'd112: instruction = 32'h00460613;   
32'd116: instruction = 32'hfd051ce3;   
32'd120: instruction = 32'h00008067;   
default: instruction = 32'h00000000;  
```

