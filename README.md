# 32-bit Single-Cycle RISC-V Processor (RV32I)

This project implements a 32-bit single-cycle RISC-V processor using Verilog HDL. The processor supports a functional subset of the **RV32I** instruction set, including R-type, I-type, S-type (store), and B-type (branch) instructions. The entire design was simulated using **Xilinx Vivado**, and verified through waveform outputs.

---

## 🔧 Setup & Usage

### 🔹 Simulation Environment:
- **Language**: Verilog HDL
- **Tool**: Xilinx Vivado (recommended for simulation and waveform analysis)
- **Target Board**: Not implemented on hardware yet, simulation only.

### 🔹 Running Your Own Instructions

To run your own instructions:
1. **Edit the `instructionMemory` module**:
   - Replace the current instruction values with your custom RISC-V machine codes.
   - Instructions must follow RV32I encoding.
   - Use the instruction set provided in the repo [Instruction_Set](./Instruction_Set.pdf) for reference.

2. **Load data into memory manually (if needed)**:
   - In the `RISCV_TOP` module, initialize the `DataMemory` array directly if your program uses memory (e.g., `LW`, `SW`).
   - Example:
     ```verilog
     initial begin
       DataMemory[0] = 32'd10;
       DataMemory[1] = 32'd20;
       ...
     end
     ```

3. **Simulate the design**:
   - Run the simulation in Vivado and analyze the waveform to track register values and memory updates.

---

## 📄 Documentation

- For full design details, instruction formats, and supported operations, please read the [Project Summary PDF](./RISCV_Project_Summary.pdf) provided in the repo.
- It explains:
  - The architecture and modules used
  - Supported instruction types (R, I, S, B)
  - Bubble sort test case
  - Simulation and verification strategy

---

## 📁 Repository Contents

- `instructionMemory.v`: Memory module containing the instruction list
- `instructionDecoder.v`: Decodes opcodes and generates control signals
- `RISCV_TOP.v`: Top-level processor module with PC, registers, memory, ALU, and control logic
- `RISCV_TB.v`: Testbench for running simulations
- `Instruction_set.pdf`: Reference instruction encodings for RV32I subset
- `RISCV_Project_Summary.pdf`: Detailed explanation of design and supported features

---

## 📌 Notes

- This is a **single-cycle design** (no pipelining).
- Register file and data memory are **internal** — there are no external memory interfaces.
- Suitable for understanding RISC-V basics, instruction execution, and Verilog simulation flow.

---

## 📬 Questions?

If you face issues running the design or want to understand specific modules, feel free to open an issue or reach out.

