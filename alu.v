// -----------------------------------------------------------------------------
// alu.v - 4-bit Arithmetic Logic Unit
// -----------------------------------------------------------------------------
// Performs arithmetic and logic operations on two 4-bit inputs (A, B) based on
// a 3-bit opcode. Outputs a 4-bit result, carry/borrow flag, and zero flag.
//
// ALU opcodes:
//   000 = ADD (A + B)
//   001 = SUB (A - B) [carry output is actually borrow indicator]
//   010 = AND (A & B)
//   011 = OR  (A | B)
//   100 = XOR (A ^ B)
//   101 = PASSA (Result = A)
//   110 = PASSB (Result = B)
//
// All operations are unsigned 4-bit. Zero flag is set when result == 0.
// -----------------------------------------------------------------------------


module alu (
    input  wire [3:0] a,        // Operand A (R0)
    input  wire [3:0] b,        // Operand B (R1)
    input  wire [2:0] opcode,   // 3-bit operation select
    output reg  [3:0] result,   // ALU result
    output reg        carry,    // Carry/borrow flag
    output reg        zero      // Zero flag
);

    // Operation codes (3 bits)
    localparam [2:0]
        OP_ADD = 3'b000,  // R0 = R0 + R1
        OP_SUB = 3'b001,  // R0 = R0 - R1
        OP_AND = 3'b010,  // R0 = R0 & R1
        OP_OR  = 3'b011,  // R0 = R0 | R1
        OP_XOR = 3'b100,  // R0 = R0 ^ R1
        OP_PASSA = 3'b101,// Pass-through A
        OP_PASSB = 3'b110;// Pass-through B

    always @(*) begin
        // Defaults
        result = 4'b0000;
        carry  = 1'b0;

        case (opcode)
            OP_ADD:   {carry, result} = a + b;
            OP_SUB:   {carry, result} = a - b; // carry here is actually borrow
            OP_AND:   result = a & b;
            OP_OR:    result = a | b;
            OP_XOR:   result = a ^ b;
            OP_PASSA: result = a;
            OP_PASSB: result = b;
            default:  result = a; // Default pass-through
        endcase

        zero = (result == 4'b0000);
    end

endmodule 