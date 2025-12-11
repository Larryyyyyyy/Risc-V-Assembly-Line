`timescale 1ns / 1ps

module main_tb;

reg clk;
reg rstn;

reg [15:0] sw_i;

wire [7:0] o_seg, o_sel;

main uut (
    .clk(clk),
    .rstn(rstn),
    .sw_i(sw_i),
    .disp_seg_o(o_seg),
    .disp_an_o(o_sel)
);

parameter CLK_PERIOD = 2;
integer i;

initial begin
    clk = 1'b0;
    rstn = 1'b0;
    sw_i = 16'b0;
    forever #(CLK_PERIOD) clk = ~clk;
end

initial begin
    $display("Start.");
    #(CLK_PERIOD);
    $display("%d: PC = %h, next_PC = %h", -1, uut.PC, uut.next_PC);
    rstn = 1'b1;
    #(CLK_PERIOD);
    for (i = 0; i < 256; i = i + 1) begin
        $display("%d: clk_1s = %h, PC = %d, next_PC = %d, x1 = %d, x2 = %d, x11 = %d, x10 = %d, x17 = %d, x12 = %d", 
        i, uut.clk_1s, uut.PC, uut.next_PC, uut.u_rf.Registers[1], uut.u_rf.Registers[2], 
        uut.u_rf.Registers[11], uut.u_rf.Registers[10], uut.u_rf.Registers[17], uut.u_rf.Registers[12]);
        #(CLK_PERIOD * 2);
    end
    $display("%d: PC = %d, next_PC = %d", 256, uut.PC, uut.next_PC);
    $display("x10 = %d, x2 = %d, x5 = %d", 
    uut.u_rf.Registers[10], uut.u_rf.Registers[2], uut.u_rf.Registers[5]);
    $display("End.");
    $finish;
end

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main_tb);
end

endmodule