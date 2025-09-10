// -----------------------------------------------------------------------------
// simple_cpu.v - Minimal 4-bit CPU
// -----------------------------------------------------------------------------
// Implements a simple single-cycle CPU with two 4-bit registers (R0, R1),
// a program counter, instruction memory, and an ALU. Executes a small set of
// instructions defined by the custom 8-bit format:
//
//   Bits [7:4] = CPU opcode
//   Bits [3:0] = Immediate value (for LDI) OR 3-bit ALU opcode (for ALU ops)
//
// CPU opcodes:
//   0000 = LDI R0, imm   | 0001 = LDI R1, imm
//   0010 = ALU operation | 1111 = HLT
//
// ALU opcodes (when CPU opcode = 0010):
//   000 = ADD, 001 = SUB, 010 = AND, 011 = OR,
//   100 = XOR, 101 = PASSA, 110 = PASSB
//
// All operations are unsigned 4-bit. No pipelining; each instruction completes
// in one clock cycle. Halt stops execution until reset.
// -----------------------------------------------------------------------------

module simple_cpu (
    input wire clk,
    input wire reset
);
    // === CPU State ===
    reg [3:0] pc;               // Program counter
    reg [7:0] instr_mem [0:15]; // 16 x 8-bit instruction memory
    reg [7:0] instr;            // Current instruction
    reg [3:0] R0, R1;           // Registers
    reg halt;

    // === ALU Wires ===
    wire [3:0] alu_result;
    wire alu_carry, alu_zero;

    // === ALU Instance ===
    alu my_alu (
        .a(R0),
        .b(R1),
        .opcode(instr[2:0]), // lower 3 bits = ALU opcode
        .result(alu_result),
        .carry(alu_carry),
        .zero(alu_zero)
    );

    // === Instruction Opcodes (CPU-level) ===
    localparam [3:0]
        OP_LDI_R0 = 4'b0000, // Load immediate into R0
        OP_LDI_R1 = 4'b0001, // Load immediate into R1
        OP_ALU    = 4'b0010, // ALU operation (opcode in lower 3 bits)
        OP_HLT    = 4'b1111; // Halt

    // === CPU Execution ===
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc   <= 0;
            halt <= 0;
            R0   <= 0;
            R1   <= 0;
        end else if (!halt) begin
            instr <= instr_mem[pc];
            pc    <= pc + 1;

            case (instr[7:4]) // top 4 bits = CPU opcode
                OP_LDI_R0: R0 <= instr[3:0];
                OP_LDI_R1: R1 <= instr[3:0];
                OP_ALU:    R0 <= alu_result; // ALU writes back to R0
                OP_HLT:    halt <= 1;
                default:   ; // NOP
            endcase
        end
    end

endmodule
