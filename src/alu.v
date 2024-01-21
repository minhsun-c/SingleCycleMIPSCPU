`ifndef __ARITMETIC_LOGIC_UNIT
`define __ARITMETIC_LOGIC_UNIT

/*
    opcode = 0: and op
    opcode = 1: or  op
    opcode = 2: add op
*/

module FullAdder (
    output Cout, Sum,
    input A, B, Cin
);
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
    assign Sum = A ^ B ^ Cin;
    
endmodule

module ALU (
    output reg result, Cout, 
    output zero_f,
    input A, B, Cin,
    input [1:0] opcode
);
    wire addition_rst, addition_cout;
    FullAdder ADD(addition_cout, addition_rst, A, B, Cin);

    // opcode 0: and, 1: or, 2: add
    always @(*) begin
        case (opcode)
            2'd0: begin
                result = A & B;
            end 
            2'd1: begin
                result = A | B;
            end
            2'd2: begin
                result = addition_rst;
                Cout = addition_cout;
            end
            2'd3: begin
                result = A ^ B;
            end
            default: 
                result = 1'b0;
        endcase
    end
    assign zero_f = (result == 1'b0);
endmodule

module ALU16 (
    output [15:0] result,
    output Cout,
    output zero_f,
    input [15:0] A, B,
    input Cin,
    input [1:0] opcode 
);
    wire C0, C1, C2, C3, C4, C5, C6, C7, 
        C8, C9, C10, C11, C12, C13, C14;
    wire zero_f0, zero_f1, zero_f2, zero_f3, 
        zero_f4, zero_f5, zero_f6, zero_f7, 
        zero_f8, zero_f9, zero_f10, zero_f11, 
        zero_f12, zero_f13, zero_f14, zero_f15;
    ALU A0(result[0], C0, zero_f0, A[0], B[0], Cin, opcode);
    ALU A1(result[1], C1, zero_f1, A[1], B[1], C0, opcode);
    ALU A2(result[2], C2, zero_f2, A[2], B[2], C1, opcode);
    ALU A3(result[3], C3, zero_f3, A[3], B[3], C2, opcode);
    ALU A4(result[4], C4, zero_f4, A[4], B[4], C3, opcode);
    ALU A5(result[5], C5, zero_f5, A[5], B[5], C4, opcode);
    ALU A6(result[6], C6, zero_f6, A[6], B[6], C5, opcode);
    ALU A7(result[7], C7, zero_f7, A[7], B[7], C6, opcode);
    ALU A8(result[8], C8, zero_f8, A[8], B[8], C7, opcode);
    ALU A9(result[9], C9, zero_f9, A[9], B[9], C8, opcode);
    ALU A10(result[10], C10, zero_f10, A[10], B[10], C9, opcode);
    ALU A11(result[11], C11, zero_f11, A[11], B[11], C10, opcode);
    ALU A12(result[12], C12, zero_f12, A[12], B[12], C11, opcode);
    ALU A13(result[13], C13, zero_f13, A[13], B[13], C12, opcode);
    ALU A14(result[14], C14, zero_f14, A[14], B[14], C13, opcode);
    ALU A15(result[15], Cout, zero_f15, A[15], B[15], C14, opcode);
    assign zero_f = (
        zero_f0 & zero_f1 & zero_f2 & zero_f3 & zero_f4 & 
        zero_f5 & zero_f6 & zero_f7 & zero_f8 & zero_f9 & 
        zero_f10 & zero_f11 & zero_f12 & zero_f13 & 
        zero_f14 & zero_f15
    );

endmodule

module ALU32 (
    output [31:0] result,
    output Cout,
    output zero_f,
    input [31:0] A, B,
    input Cin,
    input [1:0] opcode 
);
    wire C, zero_f0, zero_f1;
    ALU16 A0(result[15:0], C, zero_f0, A[15:0], B[15:0], Cin, opcode);
    ALU16 A1(result[31:16], Cout, zero_f1, A[31:16], B[31:16], C, opcode);
    assign zero_f = (zero_f0 & zero_f1);
endmodule

`endif 