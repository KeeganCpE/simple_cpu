// -----------------------------------------------------------------------------
// alu_tb.v - Testbench for 4-bit ALU
// -----------------------------------------------------------------------------
// Applies a series of test vectors to the ALU, cycling through all supported
// opcodes for several operand pairs. Displays results in both binary and
// decimal, along with carry and zero flags, to verify correctness.
//
// This is a simulation-only file and is not synthesizable.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module alu_tb;

    // Testbench signals
    reg  [3:0] a;
    reg  [3:0] b;
    reg  [2:0] opcode;
    wire [3:0] result;
    wire       carry;
    wire       zero;

    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .zero(zero)
    );

    // Task to display results in a nice format
    task show_state;
        begin
            $display("T=%0t | a=%b (%0d) | b=%b (%0d) | op=%03b | result=%b (%0d) | carry=%b | zero=%b",
                     $time, a, a, b, b, opcode, result, result, carry, zero);
        end
    endtask

    initial begin
        // Header
        $display("=== ALU Testbench Start ===");

        // Test vector set 1
        a = 4'b0101; // 5
        b = 4'b0011; // 3
        for (opcode = 0; opcode < 7; opcode = opcode + 1) begin
            #5 show_state();
        end

        // Test vector set 2
        a = 4'b1111; // 15
        b = 4'b0001; // 1
        for (opcode = 0; opcode < 7; opcode = opcode + 1) begin
            #5 show_state();
        end

        // Test vector set 3
        a = 4'b1000; // 8
        b = 4'b1000; // 8
        for (opcode = 0; opcode < 7; opcode = opcode + 1) begin
            #5 show_state();
        end

        $display("=== ALU Testbench Complete ===");
        $stop;
    end

endmodule
