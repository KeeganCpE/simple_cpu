# mini_assembler.py

# -----------------------------------------------------------------------------
# Simplified CPU Mini Assembler
# -----------------------------------------------------------------------------
# This script translates a small subset of human-readable assembly instructions
# into 8-bit machine code for the custom 4-bit CPU.
#
# Instruction format:
#   Bits [7:4] = CPU opcode
#   Bits [3:0] = Immediate value (for LDI) OR 3-bit ALU opcode (for ALU ops)
#
# Supported CPU opcodes:
#   0000 = LDI R0, imm   | 0001 = LDI R1, imm
#   0010 = ALU operation | 1111 = HLT
#
# Supported ALU opcodes (used in bits [2:0] when CPU opcode = 0010):
#   000 = ADD, 001 = SUB, 010 = AND, 011 = OR,
#   100 = XOR, 101 = PASSA, 110 = PASSB
#
# All values are unsigned 4-bit. Instructions execute in a single cycle with
# no pipelining. The assembler outputs binary and hex codes for use in Verilog
# instruction memory initialization.
# -----------------------------------------------------------------------------

# CPU opcodes
CPU_OPCODES = {
    "LI_R0": 0b0000,
    "LI_R1": 0b0001,
    "ALU":   0b0010,
    "HLT":   0b1111
}

# ALU opcodes
ALU_OPCODES = {
    "ADD":   0b000,
    "SUB":   0b001,
    "AND":   0b010,
    "OR":    0b011,
    "XOR":   0b100,
    "PASSA": 0b101,
    "PASSB": 0b110
}

def assemble_line(line):
    parts = line.strip().split()
    if not parts or parts[0].startswith("#"):
        return None  # skip empty/comment lines

    instr = parts[0].upper()

    if instr == "LI":
        reg = parts[1].upper().strip(",")
        imm = int(parts[2])
        if reg == "R0":
            opcode = (CPU_OPCODES["LI_R0"] << 4) | (imm & 0xF)
        elif reg == "R1":
            opcode = (CPU_OPCODES["LI_R1"] << 4) | (imm & 0xF)
        else:
            raise ValueError(f"Unknown register {reg}")
        return opcode

    elif instr in ALU_OPCODES:
        alu_code = ALU_OPCODES[instr]
        opcode = (CPU_OPCODES["ALU"] << 4) | alu_code
        return opcode

    elif instr == "HLT":
        return (CPU_OPCODES["HLT"] << 4)

    else:
        raise ValueError(f"Unknown instruction {instr}")

def assemble_program(lines):
    machine_code = []
    for line in lines:
        code = assemble_line(line)
        if code is not None:
            machine_code.append(code)
    return machine_code

if __name__ == "__main__":
    # Example program
    asm = [
        "LI R0, 5",
        "LI R1, 3",
        "ADD",
        "SUB",
        "AND",
        "OR",
        "XOR",
        "HLT"
    ]

    mc = assemble_program(asm)
    print("Machine code (binary):")
    for code in mc:
        print(f"{code:08b}")

    print("\nMachine code (hex):")
    for code in mc:
        print(f"0x{code:02X}")
