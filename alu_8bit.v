// 8-bit ALU
// Opcodes: 000=ADD 001=SUB 010=AND 011=OR 100=XOR 101=SLL(shift left) 110=SRL(shift right) 111=CMP(a>b)

module alu_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] opcode,
    output reg [7:0] result,
    output reg zero,
    output reg carry
);

    always @(*) begin
        carry = 1'b0;
        case (opcode)
            3'b000: {carry, result} = a + b;
            3'b001: {carry, result} = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = a << 1;
            3'b110: result = a >> 1;
            3'b111: result = (a > b) ? 8'd1 : 8'd0;
            default: result = 8'd0;
        endcase
        zero = (result == 8'd0);
    end

endmodule