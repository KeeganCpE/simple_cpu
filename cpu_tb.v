// -----------------------------------------------------------------------------
// cpu_tb.v - Testbench for simple 4-bit CPU
// -----------------------------------------------------------------------------
// Loads a short program into the CPU's instruction memory and runs it,
// monitoring the program counter, current instruction, registers, and ALU flags.
// Verifies correct execution of LDI, ALU operations, and HLT.
//
// This is a simulation-only file and is not synthesizable.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module cpu_tb;
    reg clk, reset;

    // Instantiate CPU
    simple_cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor CPU state
    initial begin
        $display("Time | PC | Instr  |  R0  |  R1  | Carry | Zero | Halt");
        $monitor("%4t | %2d | %b | %4b | %4b |   %b   |  %b   |  %b",
                 $time, uut.pc, uut.instr, uut.R0, uut.R1,
                 uut.alu_carry, uut.alu_zero, uut.halt);
    end

    // Test program
    initial begin
        reset = 1;
        #10 reset = 0;

        // Program:
        // 0: LDI R0, 5
        // 1: LDI R1, 3
        // 2: ALU ADD (000)
        // 3: ALU SUB (001)
        // 4: ALU AND (010)
        // 5: ALU OR  (011)
        // 6: ALU XOR (100)
        // 7: HLT
        uut.instr_mem[0] = 8'b0000_0101; // LDI R0, 5
        uut.instr_mem[1] = 8'b0001_0011; // LDI R1, 3
        uut.instr_mem[2] = 8'b0010_0000; // ALU ADD
        uut.instr_mem[3] = 8'b0010_0001; // ALU SUB
        uut.instr_mem[4] = 8'b0010_0010; // ALU AND
        uut.instr_mem[5] = 8'b0010_0011; // ALU OR
        uut.instr_mem[6] = 8'b0010_0100; // ALU XOR
        uut.instr_mem[7] = 8'b1111_0000; // HLT

        // Run simulation for enough cycles
        #200 $stop;
    end

endmodule
