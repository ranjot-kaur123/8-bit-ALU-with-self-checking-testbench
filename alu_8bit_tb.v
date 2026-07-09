// Self-checking testbench for 8-bit ALU
`timescale 1ns/1ps

module alu_8bit_tb;

    reg  [7:0] a, b;
    reg  [2:0] opcode;
    wire [7:0] result;
    wire zero, carry;

    reg  [7:0] expected_result;
    reg        expected_carry;
    integer errors = 0;
    integer i, op;

    alu_8bit dut (
        .a(a), .b(b), .opcode(opcode),
        .result(result), .zero(zero), .carry(carry)
    );

    task automatic check;
        begin
            expected_carry = 1'b0;
            case (opcode)
                3'b000: {expected_carry, expected_result} = a + b;
                3'b001: {expected_carry, expected_result} = a - b;
                3'b010: expected_result = a & b;
                3'b011: expected_result = a | b;
                3'b100: expected_result = a ^ b;
                3'b101: expected_result = a << 1;
                3'b110: expected_result = a >> 1;
                3'b111: expected_result = (a > b) ? 8'd1 : 8'd0;
                default: expected_result = 8'd0;
            endcase

            if (result !== expected_result) begin
                errors = errors + 1;
                $display("FAIL: opcode=%b a=%d b=%d | got=%d expected=%d",
                          opcode, a, b, result, expected_result);
            end
        end
    endtask

    initial begin
        $display("Starting ALU verification...");

        for (op = 0; op < 8; op = op + 1) begin
            for (i = 0; i < 20; i = i + 1) begin
                a = $random;
                b = $random;
                opcode = op[2:0];
                #5;
                check;
            end
        end

        if (errors == 0)
            $display("ALL 160 TESTS PASSED - full opcode coverage achieved");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;
    end

endmodule