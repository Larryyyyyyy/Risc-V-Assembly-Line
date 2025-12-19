`timescale 1ns / 1ps

module main_tb;

reg clk;
reg rstn;

main uut (
    .clk(clk),
    .rstn(rstn)
);

parameter CLK_PERIOD = 2;
integer i;

initial begin
    clk = 1'b0;
    rstn = 1'b0;
    forever #(CLK_PERIOD) clk = ~clk;
end

initial begin
    $display("Start.");
    #(CLK_PERIOD);
    $display("%d: clk = %h, PC = %d, next_PC = %d, x1 = %d, x2 = %d, x10 = %d, data = %d, t1 = %d, t2 = %d, t3 = %d", 
        -1, uut.clk, uut.PC, uut.next_PC, uut.u_rf.Registers[1], uut.u_rf.Registers[2], 
        uut.u_rf.Registers[10], uut.u_cache.u_dm.data[0], uut.IF_next_PC, uut.EX_next_PC,
        uut.Branch);
    rstn = 1'b1;
    #(CLK_PERIOD);
    for (i = 0; i < 512; i = i + 1) begin
        /*
        $display("%d: clk = %h, PC = %d, next_PC = %d, d[0] = %d, d[4] = %d, d[8] = %d, d[12] = %d, d[16] = %d, d[20] = %d, d[24] = %d", 
        i, uut.clk, uut.PC, uut.next_PC, uut.u_dm.data[0], uut.u_dm.data[1], 
        uut.u_dm.data[2], uut.u_dm.data[3], uut.u_dm.data[4], uut.u_dm.data[5],
        uut.u_dm.data[6]);
        */
        $strobe("%d: clk = %h, PC = %d, next_PC = %d, x1 = %d, x2 = %d, x10 = %d, data = %d, t1 = %d, t2 = %d, t3 = %d", 
        i, uut.clk, uut.PC, uut.next_PC, uut.u_rf.Registers[1], uut.u_rf.Registers[2], 
        uut.u_rf.Registers[10], uut.u_cache.u_dm.data[0], uut.u_cache.cache[0][0][31:0], uut.u_cache.state,
        uut.u_cache.u_dm.data[0]);
        
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