`ifndef __REGISTER_FILE
`define __REGISTER_FILE

module RegisterFile (
    output reg [31:0] read_d1, read_d2,
    input [4:0] read_addr1, read_addr2, write_addr,
    input [31:0] write_data,
    input e_write
);
    reg [31:0] rf [31:0]; // 32 reg, 32 bits for each
    
    initial begin
        rf[0] = 32'h0;		    rf[1] = 32'h2;		    rf[2] = 32'h2;		    rf[3] = 32'h3;	
        rf[4] = 32'h4;		    rf[5] = 32'h5;		    rf[6] = 32'h6;		    rf[7] = 32'h7;	
        rf[8] = 32'h8;		    rf[9] = 32'h9;		    rf[10] = 32'ha;		    rf[11] = 32'hb;	
        rf[12] = 32'hc;		    rf[13] = 32'hd;		    rf[14] = 32'he;		    rf[15] = 32'hf;	
        rf[16] = 32'h10;		rf[17] = 32'h11;		rf[18] = 32'h12;		rf[19] = 32'h13;	
        rf[20] = 32'h14;		rf[21] = 32'h15;		rf[22] = 32'h16;		rf[23] = 32'h17;	
        rf[24] = 32'h18;		rf[25] = 32'h19;		rf[26] = 32'h1a;		rf[27] = 32'h1b;	
        rf[28] = 32'h1c;		rf[29] = 32'h1d;		rf[30] = 32'h1e;		rf[31] = 32'h1f;	

    end
    
    always @(*) begin
        read_d1 = rf[read_addr1];
        read_d2 = rf[read_addr2];
    end
    always @(*) begin
        $display("e: %b", e_write);
        if (e_write) begin
            $display("e_write");
            rf[write_addr] = write_data;
        end
        else $display("ne");
        $display("[time %2t]", $time);
        for (integer i=0; i<10; i++)
            $display("[%1d: %2d] ", i, rf[i]);
        $display("");
    end
endmodule

`endif 