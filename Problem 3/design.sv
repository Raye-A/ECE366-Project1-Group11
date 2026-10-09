//Starting code as given by project

module PPA(A, B, Cin, S, Cout);

input [15:0] A, B;
input Cin;
output [15:0] S;
output Cout;

//Pre-Computation
  
wire [15:0] P;
wire [15:0] G;

genvar i;

generate
    for (i = 0; i < 16; i = i + 1) begin
        or  (P[i], A[i], B[i]);
        and (G[i], A[i], B[i]);
    end
endgenerate
	 
//Prefix Logic
  
wire [15:0] P1, G1;
wire [15:0] P2, G2;
wire [15:0] P3, G3;
wire [15:0] P4, G4;

wire [15:0] temp1;
wire [15:0] temp2;
wire [15:0] temp3;
wire [15:0] temp4;
  
  
	// distance of 1

genvar j;

generate
    for (j = 0; j < 16; j = j + 1) begin

        if (j == 0) begin
            assign P1[j] = P[j];
            assign G1[j] = G[j];
        end
        else begin
            and (P1[j], P[j], P[j-1]);

            and (temp1[j], P[j], G[j-1]);
            or  (G1[j], G[j], temp1[j]);
        end

    end
endgenerate
  
	// distance of 2
  
genvar k;

generate
    for (k = 0; k < 16; k = k + 1) begin

        if (k < 2) begin
            assign P2[k] = P1[k];
            assign G2[k] = G1[k];
        end
        else begin
            and (P2[k], P1[k], P1[k-2]);

            and (temp2[k], P1[k], G1[k-2]);
            or  (G2[k], G1[k], temp2[k]);
        end

    end
endgenerate
  
	// distance of 4
  
genvar m;

generate
    for (m = 0; m < 16; m = m + 1) begin

        if (m < 4) begin
            assign P3[m] = P2[m];
            assign G3[m] = G2[m];
        end
        else begin
            and (P3[m], P2[m], P2[m-4]);

            and (temp3[m], P2[m], G2[m-4]);
            or  (G3[m], G2[m], temp3[m]);
        end

    end
endgenerate  
  
  
	// distance of 8

genvar n;

generate
    for (n = 0; n < 16; n = n + 1) begin

        if (n < 8) begin
            assign P4[n] = P3[n];
            assign G4[n] = G3[n];
        end
        else begin
            and (P4[n], P3[n], P3[n-8]);

            and (temp4[n], P3[n], G3[n-8]);
            or  (G4[n], G3[n], temp4[n]);
        end

    end
endgenerate 
  
    // Carrying values

    wire [16:0] C;
    wire [15:0] carry_temp;

    assign C[0] = Cin;

    genvar q;

    generate
        for (q = 0; q < 16; q = q + 1) begin
            and (carry_temp[q], P4[q], Cin);
            or  (C[q+1], G4[q], carry_temp[q]);
        end
    endgenerate
  
//Sum Logic

    genvar r;

    generate
        for (r = 0; r < 16; r = r + 1) begin
            wire axorb;
            xor (axorb, A[r], B[r]);
            xor (S[r], axorb, C[r]);
        end
    endgenerate

    // Final carry-out
    assign Cout = C[16];

endmodule
