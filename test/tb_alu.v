`include "src/alu.v"

module tb;
    reg [31:0] A, B;
    reg Cin;
    reg [1:0] opcode;
    wire [31:0] result;
    wire Cout;
    wire zero;

    ALU32 alu(result, Cout, zero, A, B, Cin, opcode);

    initial begin
        $dumpfile("build/alu.vcd");
        $dumpvars(0, tb);
        A = 32'hce42; B = 32'h5efb; Cin = 1'b1;
        #1 opcode = 2'd0;
        #1 opcode = 2'd1;
        #1 opcode = 2'd2;
        #1 Cin = 1'b0;
        #2 A = 32'h56e0; B = 32'ha759; Cin = 1'b1;
        #1 opcode = 2'd0;
        #1 opcode = 2'd1;
        #1 opcode = 2'd2;
        #1 Cin = 1'b0;
        #2 A = 32'h0; B = 32'ha759; Cin = 1'b1;
        #1 opcode = 2'd0;
        #1 opcode = 2'd1;
        #1 opcode = 2'd2;
        #1 Cin = 1'b0;
        
        #5 $finish;
    end

    
endmodule