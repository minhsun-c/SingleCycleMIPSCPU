`include "src/rom.v"

module tb;
    reg [3:0] addr;
    reg enable;
    wire [31:0] out;

    ROM rom(out, addr, enable);

    initial begin
        $dumpfile("build/rom.vcd");
        $dumpvars(0, tb);
        enable = 0;
        #1 enable = 1;
        #1 addr = 4'd0; 
        #1 addr = 4'd1; 
        #1 addr = 4'd2; 
        #1 addr = 4'd3; 
        #1 addr = 4'd4; 
        #1 addr = 4'd5; 
        #1 addr = 4'd6; 
        #1 addr = 4'd7; 
        #1 enable = 0;
        #1 enable = 1;
        #1 addr = 4'd8; 
        #1 addr = 4'd9; 
        #1 addr = 4'd10; 
        #1 addr = 4'd11;
        #1 addr = 4'd12; 
        #1 addr = 4'd13; 
        #1 addr = 4'd14; 
        #1 addr = 4'd15; 
        #5 $finish;
    end

    
endmodule