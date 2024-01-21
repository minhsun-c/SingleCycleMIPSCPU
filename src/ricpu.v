`ifndef __R_I_TYPE_CPU
`define __R_I_TYPE_CPU
`include "src/rom.v"
`include "src/regfile.v"
`include "src/alu.v"
`include "src/adder.v"
`include "src/mem.v"

module RICPU(
    input clk, areset
);
    
    /* PROGRAM COUNTER */
    reg [3:0] Program_Counter;
    always @(posedge clk) begin
        Program_Counter = Program_Counter + 4;
    end

    /* ASYNCHRONOUS RESET */
    always @(posedge areset) begin 
        Program_Counter = 4'd12;
        RegWrite_ctrl   = 1'b0;
        MemWrite_ctrl   = 1'b0;
        MemRead_ctrl    = 1'b0;
        wb_data         = 32'b0;
    end

    /* INSTRUCTION FETCH */
    wire [31:0] inst;           // output of IM:    instruction
    wire [3:0]  im_read_addr;   // input of IM:     address of IM
    assign im_read_addr = Program_Counter;
    ROM Instruction_Memory(
        .out(inst), 
        .byte_addr(im_read_addr)
    );

    /* INSTRUCTION DECODE */
    wire [31:0] rf_read_data1;  // output of RF:    data#1
    wire [31:0] rf_read_data2;  // output of RF:    data#2
    wire [4:0]  rf_read_addr1;  // input of RF:     read address #1
    wire [4:0]  rf_read_addr2;  // input of RF:     read address #2
    wire [4:0]  rf_write_addr;  // input of RF:     write address 
    wire [31:0] rf_write_data;  // input of RF:     data written to RF
    wire [31:0] imm_sign_ex;    // Immediate value to 32 bits
    
    assign rf_read_addr1 = inst[26:21];
    assign rf_read_addr2 = inst[20:16];
    assign rf_write_addr = (RegDst_ctrl == 1'b0) ? inst[20:16] : inst[15:11];

    assign imm_sign_ex = {{16{inst[15]}}, inst[15:0]};
    RegisterFile RF(
        .read_d1(rf_read_data1), .read_d2(rf_read_data2),
        .read_addr1(rf_read_addr1), .read_addr2(rf_read_addr2), .write_addr(rf_write_addr),
        .write_data(rf_write_data),
        .e_write(RegWrite_ctrl)
    );

    /* CONTROL UNIT */
    reg RegDst_ctrl;        // MUX Control Line:    0 = write from inst[20:16], 1 = write from inst[15:11]
    reg RegWrite_ctrl;      // Control Line:        1 = write enable
    reg [1:0] ALUOp_ctrl;   // Control Line:        0 = and, 1 = or, 2 = add
    reg ALUSrc_ctrl;        // Mux Control Line:    0 = rf out#2 => alu_in2, 1 = imm => alu_in2
    reg MemWrite_ctrl;      // Control Line:        1 = write enable
    reg MemRead_ctrl;       // Control Line:        1 = read enable
    reg MemtoReg_ctrl;      // Mux Control Line:    0 = memory output, 1 = alu output
    
    `define FUNCT_AND       6'b100100   
    `define FUNCT_OR        6'b100101   
    `define FUNCT_ADD       6'b100000
    
    `define OPCODE_RTYPE    6'b000000   
    `define OPCODE_LW       6'b100011   
    `define OPCODE_SW       6'b101011   

    `define ENABLE          1'b1        
    `define DISABLE         1'b0        

    always@(*) begin
        if (inst[31:26] == `OPCODE_RTYPE) begin     // R-TYPE
            $display("RTYPE");
            RegDst_ctrl     =   1'b1;
            ALUSrc_ctrl     =   `DISABLE;
            RegWrite_ctrl   =   `ENABLE;
            MemRead_ctrl    =   `DISABLE;
            MemWrite_ctrl   =   `DISABLE;
            MemtoReg_ctrl   =   1'b0;
            if      (inst[5:0] == `FUNCT_AND)   ALUOp_ctrl = 2'b00; // and
            else if (inst[5:0] == `FUNCT_OR)    ALUOp_ctrl = 2'b01; // or
            else if (inst[5:0] == `FUNCT_ADD)   ALUOp_ctrl = 2'b10; // add
            else                                ALUOp_ctrl = 2'b11; // default
        end
        else if (inst[31:26] == `OPCODE_LW) begin   // load word
            $display("LW");
            RegDst_ctrl     =   1'b0;
            ALUSrc_ctrl     =   `ENABLE;
            RegWrite_ctrl   =   `ENABLE;
            MemRead_ctrl    =   `ENABLE;
            MemWrite_ctrl   =   `DISABLE;
            MemtoReg_ctrl   =   1'b1;
        end
        else if (inst[31:26] == `OPCODE_SW) begin   // store word
            $display("SW");
            ALUSrc_ctrl     =   `ENABLE;
            RegWrite_ctrl   =   `DISABLE;
            MemRead_ctrl    =   `DISABLE;
            MemWrite_ctrl   =   `ENABLE;
        end
        else begin    
            
        end
    end

    /* EXECUTION - ALU */
    wire [31:0] alu_in1;        // input of ALU:    input#1
    wire [31:0] alu_in2;        // input of ALU:    input#2
    wire [31:0] alu_result;     // output of ALU:   result of input#1 op input#2
    wire alu_zero_flag;         // output of ALU:   1 = output is zero
    assign alu_in1 = rf_read_data1;
    assign alu_in2 = (ALUSrc_ctrl == 1'b0) ? rf_read_data2 : imm_sign_ex;
    ALU32 alu(
        .result(alu_result),
        .zero_f(alu_zero_flag),
        .Cout(), .Cin(1'b0),
        .A(alu_in1), .B(alu_in2),
        .opcode(ALUOp_ctrl)
    );

    /* MEMORY */
    wire [31:0] dm_output;  // output of DM:    load out of dm 
    wire [3:0]  dm_addr;    // input of DM:     where data should be stored
    wire [31:0] dm_data;    // input of DM:     data stored in dm
    assign dm_addr = alu_result;
    assign dm_data = rf_read_data2;
    MEM Data_Memory(
        .out(dm_output), 
        .byte_addr(dm_addr),  
        .data_i(dm_data),    
        .e_read(MemRead_ctrl), .e_write(MemWrite_ctrl)
    );


    /* WRITE BACK */
    reg [31:0] wb_data;
    always@(*) begin
        if (MemtoReg_ctrl == 1'b1) 
            wb_data = dm_output;
        else
            wb_data = alu_result;
    end
    assign rf_write_data = wb_data;

endmodule

`endif