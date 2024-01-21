`ifndef _CARRY_LOOKAHEAD_ADDER
`define _CARRY_LOOKAHEAD_ADDER

module CLA_Adder4 (
    output Cout,
    output [3:0] Sum,
    input [3:0] A, B,
    input Cin
);
   wire [3:0] P, G;
   wire [3:1] C;

    // Compute propagate, generate
    assign P = A ^ B;
    assign G = A & B;

    // Compute all Carry
    assign C[1] = P[0] & Cin  | G[0];
    assign C[2] = P[1] & C[1] | G[1];
    assign C[3] = P[2] & C[2] | G[2];
    assign Cout = P[3] & C[3] | G[3];

    // Compute all Sum
    assign Sum[0] = A[0] ^ B[0] ^ Cin;
    assign Sum[1] = A[1] ^ B[1] ^ C[1];
    assign Sum[2] = A[2] ^ B[2] ^ C[2];
    assign Sum[3] = A[3] ^ B[3] ^ C[3];
endmodule

module CLA_Adder8 (
    output Cout,
    output [7:0] Sum,
    input [7:0] A, B,
    input Cin
);
   wire [7:0] P, G;
   wire [7:1] C;

    // Compute propagate, generate
    assign P = A ^ B;
    assign G = A & B;

    // Compute all Carry
    assign C[1] = P[0] & Cin  | G[0];
    assign C[2] = P[1] & C[1] | G[1];
    assign C[3] = P[2] & C[2] | G[2];
    assign C[4] = P[3] & C[3] | G[3];
    assign C[5] = P[4] & C[4] | G[4];
    assign C[6] = P[5] & C[5] | G[5];
    assign C[7] = P[6] & C[6] | G[6];
    assign Cout = P[7] & C[7] | G[7];

    // Compute all Sum
    assign Sum[0] = A[0] ^ B[0] ^ Cin;
    assign Sum[1] = A[1] ^ B[1] ^ C[1];
    assign Sum[2] = A[2] ^ B[2] ^ C[2];
    assign Sum[3] = A[3] ^ B[3] ^ C[3];
    assign Sum[4] = A[4] ^ B[4] ^ C[4];
    assign Sum[5] = A[5] ^ B[5] ^ C[5];
    assign Sum[6] = A[6] ^ B[6] ^ C[6];
    assign Sum[7] = A[7] ^ B[7] ^ C[7];
endmodule

module CLA_Adder32 (
    output Cout,
    output [31:0] Sum,
    input [31:0] A, B,
    input Cin
);
    wire C0, C1, C2;
    CLA_Adder8 A0(C0, Sum[7:0], A[7:0], B[7:0], Cin);
    CLA_Adder8 A1(C1, Sum[15:8], A[15:8], B[15:8], C0);
    CLA_Adder8 A2(C2, Sum[23:16], A[23:16], B[23:16], C1);
    CLA_Adder8 A3(Cout, Sum[31:24], A[31:24], B[31:24], C2);
endmodule

`endif 