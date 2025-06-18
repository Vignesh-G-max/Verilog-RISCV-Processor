`timescale 1ns / 1ps
module programCounter(
    input clk,
    input reset,
    input [31:0] PCNext,
    input PCSource,
    output [31:0] PC
);
    assign PC = PCNext;
endmodule
