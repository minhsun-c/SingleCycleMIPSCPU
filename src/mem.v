`ifndef __READ_WRITE_MEMORY
`define __READ_WRITE_MEMORY

// 1 word, 4 bytes, 32 bits
module MEM (
    output reg [31:0] out,  // load 32-bit data 
    input [3:0] byte_addr,  // 16 byte_addr options => lg16 = 4 bits 
    input [31:0] data_i,    // 32-bit data to store
    input e_read, e_write
);

    reg [7:0] memory [15:0];

    initial begin
        memory[0] =  8'h0;
        memory[1] =  8'h1;
        memory[2] =  8'h2;
        memory[3] =  8'h3;
        memory[4] =  8'h4;
        memory[5] =  8'h5;
        memory[6] =  8'h6;
        memory[7] =  8'h7;
        memory[8] =  8'h8;
        memory[9] =  8'h9;
        memory[10] = 8'hA;
        memory[11] = 8'hB;
        memory[12] = 8'hC;
        memory[13] = 8'hD;
        memory[14] = 8'hE;
        memory[15] = 8'hF;
    end

    wire [3:0] start_addr;
    assign start_addr = {byte_addr[3:2], 2'b0};

    always@(*) begin
        if (e_write) begin
            memory[start_addr]   =  data_i[31:24];
            memory[start_addr+1] =  data_i[23:16];
            memory[start_addr+2] =  data_i[15:8];
            memory[start_addr+3] =  data_i[7:0];
            out = 32'b0;
        end
        else if (e_read) begin
            out = {
                memory[start_addr], memory[start_addr+1],
                memory[start_addr+2], memory[start_addr+3]
            };
        end
        else begin
            out = 32'b0;
        end
    end
    
endmodule

`endif 