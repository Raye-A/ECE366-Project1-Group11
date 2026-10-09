// testbenches

module PPA_tb;

    reg  [15:0] A, B;
    reg         Cin;

    wire [15:0] S;
    wire        Cout;

    PPA dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout)
    );

    initial begin

        $monitor("Time=%0t A=%h B=%h Cin=%b | S=%h Cout=%b",
                 $time, A, B, Cin, S, Cout);
      

        A = 16'hFFFF;
        B = 16'h0001;
        Cin = 1'b0;
        #10;

        A = 16'h1234;
        B = 16'h5678;
        Cin = 1'b0;
        #10;

        A = 16'hAAAA;
        B = 16'h5555;
        Cin = 1'b0;
        #10;
      
         A = 16'h0005;
        B = 16'h0003;
        Cin = 1'b0;
        #10;

        A = 16'h0005;
        B = 16'h0003;
        Cin = 1'b1;
        #10;

        $finish;
    end

endmodule
