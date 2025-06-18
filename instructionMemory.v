`timescale 1ns / 1ps
module instructionMemory(
    input  [9:0] PCIn,
    output [31:0] instructionOut
);
    reg [31:0] memory [0:1023];
    assign instructionOut = memory[PCIn];

    initial begin
        // Initialize the instruction memory with your program instructions here
        // Sample program below:

        memory[0] = 32'b000000000100_00001_010_00101_0000011; // lw x5, 4(x1)     ; x5 = Mem[x1 + 4]
        memory[1] = 32'b0000000_00101_00010_000_00110_0110011; // add x6, x2, x5   ; x6 = x2 + x5
        memory[2] = 32'b0000000_00110_00011_000_00111_0110011; // add x7, x3, x6   ; x7 = x3 + x6
        memory[3] = 32'b0000000_00111_00100_100_01000_0110011; // xor x8, x4, x7   ; x8 = x4 ^ x7
        memory[4] = 32'b0000000_01000_00000_000_00000_0110011; // add x0, x0, x8   ; dummy (x0 always zero)
    end
endmodule
