`ifndef __READ_ONLY_MEMORY
`define __READ_ONLY_MEMORY

module ROM (
    output reg [31:0] out,  // output 1 word, 4 bytes, 32 bits
    input [3:0] byte_addr  // 16 byte_addr options => lg16 = 4 bits 
);
    reg [7:0] memory [15:0]; // Byte * 16

    initial begin
        $readmemb("data/rib_im.txt", memory);
    end
    wire [3:0] start_addr;
    assign start_addr = {byte_addr[3:2], 2'b0};

    always @(*) begin
        out = {
            memory[start_addr+3], memory[start_addr+2],
            memory[start_addr+1], memory[start_addr]
        };
    end
    
endmodule

`endif