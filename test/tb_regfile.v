`include "src/regfile.v"

module tb;

    wire [31:0] read_d1, read_d2;
    reg [4:0] read_addr1, read_addr2, write_addr;
    reg [31:0] write_data;
    reg e_write;

    RegisterFile RF(
        read_d1, read_d2,
        read_addr1, read_addr2, write_addr,
        write_data,
        e_write
    );

    initial begin
        $dumpfile("build/regfile.vcd");
        $dumpvars(0, tb);
        e_write = 1'b0;
        #1 read_addr1 = 5'd0; read_addr2 = 5'd31;
        #1 read_addr1 = 5'd1; read_addr2 = 5'd30;
        #1 read_addr1 = 5'd2; read_addr2 = 5'd29;
        #1 read_addr1 = 5'd3; read_addr2 = 5'd28;
        #1 read_addr1 = 5'd4; read_addr2 = 5'd27;
        #1 read_addr1 = 5'd5; read_addr2 = 5'd26;
        #1 read_addr1 = 5'd6; read_addr2 = 5'd25;
        #1 read_addr1 = 5'd7; read_addr2 = 5'd24;
        #1 read_addr1 = 5'd8; read_addr2 = 5'd23;
        #1 read_addr1 = 5'd9; read_addr2 = 5'd22;
        #1 read_addr1 = 5'd10; read_addr2 = 5'd21;
        #1 read_addr1 = 5'd11; read_addr2 = 5'd20;
        #1 e_write = 1'b1; write_addr = 5'd26; write_data = 32'hAABBCDEF;
        #1 read_addr1 = 5'd12; read_addr2 = 5'd19;
        #1 read_addr1 = 5'd13; read_addr2 = 5'd18;
        #1 read_addr1 = 5'd14; read_addr2 = 5'd17;
        #1 read_addr1 = 5'd15; read_addr2 = 5'd16;
        #1 read_addr1 = 5'd16; read_addr2 = 5'd15;
        #1 read_addr1 = 5'd17; read_addr2 = 5'd14;
        #1 read_addr1 = 5'd18; read_addr2 = 5'd13;
        #1 read_addr1 = 5'd19; read_addr2 = 5'd12;
        #1 read_addr1 = 5'd20; read_addr2 = 5'd11;
        #1 read_addr1 = 5'd21; read_addr2 = 5'd10;
        #1 read_addr1 = 5'd22; read_addr2 = 5'd9;
        #1 read_addr1 = 5'd23; read_addr2 = 5'd8;
        #1 read_addr1 = 5'd24; read_addr2 = 5'd7;
        #1 read_addr1 = 5'd25; read_addr2 = 5'd6;
        #1 read_addr1 = 5'd26; read_addr2 = 5'd5;
        #1 read_addr1 = 5'd27; read_addr2 = 5'd4;
        #1 read_addr1 = 5'd28; read_addr2 = 5'd3;
        #1 read_addr1 = 5'd29; read_addr2 = 5'd2;
        #1 read_addr1 = 5'd30; read_addr2 = 5'd1;
        #1 read_addr1 = 5'd31; read_addr2 = 5'd0;

        
        #5 $finish;
    end

    
endmodule