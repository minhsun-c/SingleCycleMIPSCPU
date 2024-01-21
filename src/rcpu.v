`ifndef __R_TYPE_CPU
`define __R_TYPE_CPU
`include "src/rom.v"
`include "src/regfile.v"
`include "src/alu.v"
`include "src/adder.v"

module RCPU(
    input clk, areset
);
    
    /* PROGRAM COUNTER */
    reg [3:0] Program_Counter;
    always @(posedge clk) begin
        Program_Counter = Program_Counter + 4;
    end

    /* ASYNCHRONOUS RESET */
    always @(posedge areset) Program_Counter = 4'b0;

    /* INSTRUCTION FETCH */
    wire [31:0] inst;       // output of IM:    instruction
    wire [3:0]  read_addr;  // input of IM:     address of IM
    assign read_addr = Program_Counter;
    ROM Instruction_Memory(
        .out(inst), 
        .byte_addr(read_addr)
    );

    /* INSTRUCTION DECODE */
    wire [31:0] read_data1; // output of RF:    data#1
    wire [31:0] read_data2; // output of RF:    data#2
    wire [4:0]  read_addr1; // input of RF:     read address #1
    wire [4:0]  read_addr2; // input of RF:     read address #2
    wire [4:0]  write_addr; // input of RF:     write address 
    wire [31:0] write_data; // input of RF:     data written to RF
    wire RegWrite_ctrl;     // Control Line:    1 = write enable
    assign read_addr1 = inst[26:21];
    assign read_addr2 = inst[20:16];
    assign write_addr = inst[15:11];
    assign RegWrite_ctrl = 1'b1;
    RegisterFile RF(
        .read_d1(read_data1), .read_d2(read_data2),
        .read_addr1(read_addr1), .read_addr2(read_addr2), .write_addr(write_addr),
        .write_data(write_data),
        .e_write(RegWrite_ctrl)
    );
    reg [1:0] ALUOp_reg;
    always@(*) begin
        if (inst[31:26] == 6'b0) begin
            if (inst[5:0] == 6'b100100) ALUOp_reg = 2'b00;
            else if (inst[5:0] == 6'b100101) ALUOp_reg = 2'b01;
            else if (inst[5:0] == 6'b100000) ALUOp_reg = 2'b10;
            else ALUOp_reg = 2'b11;
        end
        else begin
            
        end
    end

    /* EXECUTION - ALU */
    wire [31:0] in1;        // input of ALU:    input#1
    wire [31:0] in2;        // input of ALU:    input#2
    wire [31:0] alu_result; // output of ALU:   result of input#1 op input#2
    wire zero_flag;         // output of ALU:   1 = output is zero
    wire [1:0] ALUOp_ctrl;  // Control Line:    0 = and, 1 = or, 2 = add
    assign in1 = read_data1;
    assign in2 = read_data2;
    ALU32 alu(
        .result(alu_result),
        .zero_f(zero_flag),
        .Cout(), .Cin(1'b0),
        .A(in1), .B(in2),
        .opcode(ALUOp_ctrl)
    );

    assign ALUOp_ctrl = ALUOp_reg;

    /* WRITE BACK */
    assign write_data = alu_result;

endmodule

`endif