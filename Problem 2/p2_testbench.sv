`timescale 1ns/1ps

module tb_problem2;

    // Problem 1 signals. These are kept because Problem 2(b) asks us to
    // enhance the Problem 1 testbench rather than throw it away.
    reg  [3:0] A4, B4;
    reg        Cin_add4, Cin_sub4;
    wire [3:0] S_add4, S_sub4;
    wire       Cout_add4, Cout_sub4;

    // Problem 2 CLA signals.
    reg  [31:0] A32, B32;
    reg         Cin32;
    wire [31:0] S32;
    wire        Cout32;

    four_bit_RCA old_adder(
        .A(A4), .B(B4), .Cin(Cin_add4),
        .S(S_add4), .Cout(Cout_add4)
    );

    four_bit_RCS old_subtractor(
        .A(A4), .B(B4), .Cin(Cin_sub4),
        .S(S_sub4), .Cout(Cout_sub4)
    );

    CLA dut(
        .A(A32), .B(B32), .Cin(Cin32),
        .S(S32), .Cout(Cout32)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_problem2);

        // Initial values
        A4 = 0;
        B4 = 0;
        Cin_add4 = 0;
        Cin_sub4 = 1;

        A32 = 0;
        B32 = 0;
        Cin32 = 0;

        // ------------------------------------------------------------
        // Original Problem 1 test types
        // ------------------------------------------------------------

        // Unsigned addition: 5 + 3 = 8
        A4 = 4'd5;
        B4 = 4'd3;
        #10;
        $display("P1 unsigned add: 5 + 3 -> S=%0d Cout=%b (expected 8,0)",
                 S_add4, Cout_add4);

        // Unsigned subtraction: 9 - 4 = 5
        A4 = 4'd9;
        B4 = 4'd4;
        #10;
        $display("P1 unsigned sub: 9 - 4 -> S=%0d (expected 5)",
                 S_sub4);

        // Signed addition with negative operand: -4 + 6 = 2
        A4 = 4'b1100;
        B4 = 4'b0110;
        #10;
        $display("P1 signed add: -4 + 6 -> S=%b (expected 0010)",
                 S_add4);

        // Signed subtraction with negative operand: 3 - (-2) = 5
        A4 = 4'b0011;
        B4 = 4'b1110;
        #10;
        $display("P1 signed sub: 3 - (-2) -> S=%b (expected 0101)",
                 S_sub4);

        // Carry-out case: 15 + 1 = 16
        A4 = 4'd15;
        B4 = 4'd1;
        #10;
        $display("P1 carry out: 15 + 1 -> S=%0d Cout=%b (expected 0,1)",
                 S_add4, Cout_add4);

        // ------------------------------------------------------------
        // Problem 2 CLA tests
        // ------------------------------------------------------------

        // Normal unsigned addition: 100 + 23 = 123
        A32 = 32'd100;
        B32 = 32'd23;
        Cin32 = 0;
        #10;
        $display("P2 unsigned add: 100 + 23 -> S=%0d Cout=%b (expected 123,0)",
                 S32, Cout32);

        // Signed addition with a negative operand: -5 + 7 = 2
        A32 = 32'hFFFFFFFB;
        B32 = 32'h00000007;
        Cin32 = 0;
        #10;
        $display("P2 signed add: -5 + 7 -> S=%h (expected 00000002)",
                 S32);

        // Carry-out case: FFFFFFFF + 1 = 00000000, Cout = 1
        A32 = 32'hFFFFFFFF;
        B32 = 32'h00000001;
        Cin32 = 0;
        #10;
        $display("P2 carry out: FFFFFFFF + 1 -> S=%h Cout=%b (expected 00000000,1)",
                 S32, Cout32);

        // Required carry propagation across multiple 4-bit blocks.
        // Adding 1 to 0FFFFFFF propagates a carry through seven blocks.
        A32 = 32'h0FFFFFFF;
        B32 = 32'h00000001;
        Cin32 = 0;
        #10;
        $display("P2 multi-block carry: 0FFFFFFF + 1 -> S=%h Cout=%b (expected 10000000,0)",
                 S32, Cout32);
        $display("Internal c32,c28,...,c4,c0 = %b (expected 011111110)",
                 dut.block_carry);

        // Explicit Cin test
        A32 = 32'h12345678;
        B32 = 32'h11111111;
        Cin32 = 1;
        #10;
        $display("P2 Cin test: 12345678 + 11111111 + 1 -> S=%h Cout=%b (expected 2345678A,0)",
                 S32, Cout32);

        $finish;
    end

endmodule
