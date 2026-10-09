`timescale 1ns / 1ps

module tb_separate_RCA_RCS;
  reg [3:0] A, B;
  reg Cin_add, Cin_sub;
  wire [3:0] S_add, S_sub;
  wire Cout_add, Cout_sub;

  four_bit_RCA uut_adder (
    .A(A), .B(B), .Cin(Cin_add), .S(S_add), .Cout(Cout_add)
  );

  four_bit_RCS uut_subtractor (
    .A(A), .B(B), .Cin(Cin_sub), .S(S_sub), .Cout(Cout_sub)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);

    Cin_add = 0;
    Cin_sub = 1;

    $display("Time | A B | Add (A+B): S Cout | Sub (A-B): S Cout");
    $monitor("%4t | %2d %2d | %9d %4b | %9d %4b",
             $time, A, B, S_add, Cout_add, S_sub, Cout_sub);

    A = 4'd5;  B = 4'd3; #10;
    A = 4'd9;  B = 4'd4; #10;
    A = 4'd4;  B = 4'd7; #10;
    A = 4'd12; B = 4'd6; #10;

    $finish;
  end
endmodule
