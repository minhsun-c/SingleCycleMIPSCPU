`include "src/rcpu.v"

module tb;
    reg clk, areset;

    RCPU CPU(clk, areset);

    initial begin
        $dumpfile("build/rcpu.vcd");
        $dumpvars(0, tb);
        areset = 0; clk = 0;
        #2 areset = 1; 
        #2 clk = 1; #2 clk = 0;
        #2 clk = 1; #2 clk = 0;
        
        #5 $finish;
    end

    
endmodule