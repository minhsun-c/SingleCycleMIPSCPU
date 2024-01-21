`include "src/mem.v"

module tb;

    wire [31:0] out;  
    reg [3:0] byte_addr;  
    reg [31:0] data_i;    
    reg e_read, e_write;

    MEM DM(out, byte_addr, data_i, e_read, e_write);

    initial begin
        $dumpfile("build/mem.vcd");
        $dumpvars(0, tb);
        e_read = 0; e_write = 0;
        #1 e_read = 1;
        #1 byte_addr = 4'd0; 
        #1 byte_addr = 4'd1; 
        #1 byte_addr = 4'd2; 
        #1 byte_addr = 4'd3; 
        #1 byte_addr = 4'd4; 
        #1 byte_addr = 4'd5; 
        e_write = 1; e_read = 0;
        data_i = 32'h1A2B3C4D;
        #1 byte_addr = 4'd6; 
        e_write = 0; e_read = 1;
        #1 byte_addr = 4'd7; 
        e_write = 0; e_read = 0;
        #1 byte_addr = 4'd8; 
        e_write = 0; e_read = 1;
        #1 byte_addr = 4'd4; 
        #1 byte_addr = 4'd5; 
        #1 byte_addr = 4'd6;
        #1 byte_addr = 4'd7; 
        #1 byte_addr = 4'd13; 
        #1 byte_addr = 4'd14; 
        #1 byte_addr = 4'd15; 
        #5 $finish;
    end

    
endmodule