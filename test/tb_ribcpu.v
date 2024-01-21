`include "src/ribcpu.v"

module tb;
    reg clk, areset;

    RIBCPU CPU(clk, areset);

    initial begin
        $dumpfile("build/ribcpu.vcd");
        $dumpvars(0, tb);
        areset = 0; clk = 0;
        #1 areset = 1; 
        #2 clk = 1; 
        #2 clk = 0;
        #2 clk = 1; #2 clk = 0;
        #2 clk = 1; #2 clk = 0;
        #2 clk = 1; #2 clk = 0;
        #2 clk = 1; #2 clk = 0;
        
        
        #5 $finish;
    end

    
endmodule