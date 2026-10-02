module one_bit_full_adder_behavioral (A, B, Cin, S, Cout);
  input A, B, Cin;
  output S, Cout;

  assign {Cout, S} = A + B + Cin;
endmodule

module one_bit_full_adder_structural (A, B, Cin, S, Cout);
  input A, B, Cin;
  output S, Cout;
  wire axorb, a_and_b, cin_and_axorb;

  xor (axorb, A, B);
  xor (S, axorb, Cin);
  and (a_and_b, A, B);
  and (cin_and_axorb, Cin, axorb);
  or (Cout, a_and_b, cin_and_axorb);
endmodule

module four_bit_RCA (A, B, Cin, S, Cout);
  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  wire c1, c2, c3;

  one_bit_full_adder_behavioral FA0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(c1));
  one_bit_full_adder_behavioral FA1 (.A(A[1]), .B(B[1]), .Cin(c1), .S(S[1]), .Cout(c2));
  one_bit_full_adder_behavioral FA2 (.A(A[2]), .B(B[2]), .Cin(c2), .S(S[2]), .Cout(c3));
  one_bit_full_adder_behavioral FA3 (.A(A[3]), .B(B[3]), .Cin(c3), .S(S[3]), .Cout(Cout));
endmodule

module four_bit_RCS (A, B, Cin, S, Cout);
  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  wire [3:0] B_inv;
  wire c1, c2, c3;

  assign B_inv = ~B;

  one_bit_full_adder_behavioral FA0 (.A(A[0]), .B(B_inv[0]), .Cin(Cin), .S(S[0]), .Cout(c1));
  one_bit_full_adder_behavioral FA1 (.A(A[1]), .B(B_inv[1]), .Cin(c1), .S(S[1]), .Cout(c2));
  one_bit_full_adder_behavioral FA2 (.A(A[2]), .B(B_inv[2]), .Cin(c2), .S(S[2]), .Cout(c3));
  one_bit_full_adder_behavioral FA3 (.A(A[3]), .B(B_inv[3]), .Cin(c3), .S(S[3]), .Cout(Cout));
endmodule
