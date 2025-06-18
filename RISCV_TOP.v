`timescale 1ns / 1ps
module RISCV_TOP(
    input clk,
    input reset
);
    wire [31:0] instruction;
    reg [31:0] RegisterFile [0:31];
    reg [31:0] DataMemory [0:1023];
    reg [31:0] ALUResult;
    reg [31:0] Data1, Data2;
    wire [31:0] PC;
    reg [31:0] PCNext;
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] immI, immS, immB;
    reg PCSrc;

    // Program Counter
    programCounter PCounter(
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PCSource(PCSrc),
        .PC(PC)
    );

    // Instruction Memory
    instructionMemory instrMem (
        .PCIn(PC),
        .instructionOut(instruction)
    );

    // Instruction Decoder
    instructionDecoder decoder (
        .instructionIn(instruction),
        .opcodeOut(opcode),
        .rdOut(rd),
        .funct3Out(funct3),
        .rs1Out(rs1),
        .rs2Out(rs2),
        .funct7Out(funct7),
        .immIOut(immI),
        .immSOut(immS),
        .immBOut(immB)
    );

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            PCNext = 0;
            PCSrc = 0;
            for (i = 0; i < 32; i = i + 1)
                RegisterFile[i] = 0;
                
            // Here you can initialize the DataMemory with intended values
//            Example:
//            DataMemory[0] = 10;            
//            DataMemory[1] = 10;
//            DataMemory[2] = 5;
//            DataMemory[3] = 3;

        end else begin
            Data1 = RegisterFile[rs1];
            Data2 = RegisterFile[rs2];
            PCSrc = 0;
            case (opcode)
                // R-type: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
                7'b0110011: begin
                    case ({funct7, funct3})
                        10'b0000000_000: ALUResult = Data1 + Data2; // ADD
                        10'b0100000_000: ALUResult = Data1 - Data2; // SUB
                        10'b0000000_001: ALUResult = Data1 << Data2[4:0]; // SLL
                        10'b0000000_010: ALUResult = (Data1 < Data2) ? 1 : 0; // SLT
                        10'b0000000_011: ALUResult = (Data1 < Data2) ? 1 : 0; // SLTU (unsigned same as signed in this simple case)
                        10'b0000000_100: ALUResult = Data1 ^ Data2; // XOR
                        10'b0000000_101: ALUResult = Data1 >> Data2[4:0]; // SRL
                        10'b0100000_101: ALUResult = $signed(Data1) >>> Data2[4:0]; // SRA
                        10'b0000000_110: ALUResult = Data1 | Data2; // OR
                        10'b0000000_111: ALUResult = Data1 & Data2; // AND
                        default: ALUResult = 0;
                    endcase
                end

                // I-type: LW, ADDI, SLTI, XORI, ORI, ANDI
                7'b0000011: begin // LW
                    if (funct3 == 3'b010)
                        ALUResult = DataMemory[Data1 + immI];
                end

                7'b0010011: begin
                    case (funct3)
                        3'b000: ALUResult = Data1 + immI; // ADDI
                        3'b010: ALUResult = (Data1 < immI) ? 1 : 0; // SLTI
                        3'b100: ALUResult = Data1 ^ immI; // XORI
                        3'b110: ALUResult = Data1 | immI;  // ORI
                        3'b111: ALUResult = Data1 & immI;  // ANDI
                
                        3'b001: begin // SLLI
                            ALUResult = Data1 << immI[4:0]; // shamt = imm[4:0]
                        end
                
                        3'b101: begin
                            if (funct7 == 7'b0000000) begin
                                ALUResult = Data1 >> immI[4:0]; // SRLI (logical shift right)
                            end
                            else if (funct7 == 7'b0100000) begin
                                ALUResult = $signed(Data1) >>> immI[4:0]; // SRAI (arithmetic shift right)
                            end
                            else begin
                                ALUResult = 0; // Undefined
                            end
                        end
                
                        default: ALUResult = 0;
                    endcase
                end

                // S-type: SW
                7'b0100011: begin
                    if (funct3 == 3'b010)
                        DataMemory[Data1 + immS] = Data2;
                end

                // B-type: BEQ, BNE, BLT, BGE
                7'b1100011: begin
                    case (funct3)
                        3'b000: if (Data1 == Data2) begin // BEQ
                            PCNext = PC + immB + 1;
                            PCSrc = 1;
                        end
                        3'b001: if (Data1 != Data2) begin // BNE
                            PCNext = PC + immB + 1;
                            PCSrc = 1;
                        end
                        3'b100: if ($signed(Data1) < $signed(Data2)) begin // BLT
                            PCNext = PC + immB + 1;
                            PCSrc = 1;
                        end
                        3'b101: if ($signed(Data1) >= $signed(Data2)) begin // BGE
                            PCNext = PC + immB + 1;
                            PCSrc = 1;
                        end
                    endcase
                end

                default: ALUResult = 0;
            endcase

            // Writeback
            if ((opcode == 7'b0110011 || opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b1100111) && rd != 0)
                RegisterFile[rd] = ALUResult;

            // PC update
            if (!PCSrc)
                PCNext = PC + 1;
        end
    end
endmodule
