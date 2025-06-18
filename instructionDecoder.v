`timescale 1ns / 1ps
module instructionDecoder(
    input [31:0] instructionIn,
    output [6:0] opcodeOut,
    output [4:0] rdOut,
    output [2:0] funct3Out,
    output [4:0] rs1Out,
    output [4:0] rs2Out,
    output [6:0] funct7Out,
    output [31:0] immIOut,
    output [31:0] immSOut,
    output [31:0] immBOut
);

    assign opcodeOut = instructionIn[6:0];
    assign rdOut     = instructionIn[11:7];
    assign funct3Out = instructionIn[14:12];
    assign rs1Out    = instructionIn[19:15];
    assign rs2Out    = instructionIn[24:20];
    assign funct7Out = instructionIn[31:25];

    assign immIOut = {{20{instructionIn[31]}}, instructionIn[31:20]};
    assign immSOut = {{20{instructionIn[31]}}, instructionIn[31:25], instructionIn[11:7]};
    assign immBOut = {{19{instructionIn[31]}}, instructionIn[31], instructionIn[7],
                      instructionIn[30:25], instructionIn[11:8], 1'b0} >> 2;

endmodule
