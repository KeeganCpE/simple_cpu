4‑Bit CPU Project with Python Mini‑Assembler

Overview
This project implements a custom 4‑bit CPU in Verilog, complete with:
- A parameterized ALU supporting arithmetic and logic operations.
- A minimal instruction set for loading registers, performing ALU ops, and halting.
- A Python mini‑assembler that converts human‑readable assembly into machine code for the CPU.
- Testbenches for both the ALU and CPU to verify correctness in simulation.

The design is intended as a learning tool and portfolio piece, demonstrating digital logic design, CPU architecture, and tooling integration.

Instruction Format
Each instruction is 8 bits:
[7:4] = CPU opcode
[3:0] = Immediate value (for LDI) OR 3‑bit ALU opcode (for ALU ops)

CPU Opcodes:
0000 = LDI R0, n   | Load immediate into R0
0001 = LDI R1, n   | Load immediate into R1
0010 = ALU op      | Perform ALU operation
1111 = HLT         | Halt execution

ALU Opcodes (when CPU opcode = 0010):
000 = ADD      | R0 = R0 + R1
001 = SUB      | R0 = R0 − R1
010 = AND      | R0 = R0 & R1
011 = OR       | R0 = R0 | R1
100 = XOR      | R0 = R0 ^ R1
101 = PASSA    | R0 = R0
110 = PASSB    | R0 = R1

All values are unsigned 4‑bit. Instructions execute in a single cycle with no pipelining.

File Structure
/project
│
├── quartus_project/
│   ├── simple_cpu.v              # Top-level CPU module
│   ├── alu.v                               # 4-bit ALU module
│   ├── alu_tb.v                        # ALU testbench
│   └── cpu_tb.v                        # CPU testbench
│
├── mini_assembler.py         # Python assembler script
└── README.txt            	    # This file

Workflow
1. Write your program in the assembler’s asm list (or in a .asm file if extended).
2. Run the assembler to generate binary/hex machine code:
   python mini_assembler.py
3. Load the machine code into your CPU’s instr_mem in the testbench or FPGA.
4. Simulate in ModelSim/Quartus to verify behavior.
5. (Optional) Synthesize to FPGA for a live hardware demo.

Example Program
Assembly:
LI R0, 5
LI R1, 3
ADD
SUB
AND
OR
XOR
HLT

Assembler Output (hex):
0x05
0x13
0x20
0x21
0x22
0x23
0x24
0xF0

Simulation
- ALU Testbench (alu_tb.v): Cycles through all ALU ops for several operand pairs, printing results.
- CPU Testbench (cpu_tb.v): Loads a program into instruction memory and monitors PC, instruction, registers, and flags.

Next Steps
Potential expansions:
- Add branching/jump instructions.
- Implement load/store with RAM.
- Parameterize to 8‑bit or 16‑bit datapath.
- Create a .mif or .mem output from the assembler for direct Quartus loading.
