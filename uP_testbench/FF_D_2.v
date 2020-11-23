//FF de 2 bits
module FF_D_2(input clk, reset, enabled, input [1:0] D, output [1:0] Q);

    FF_D_1 U1 (clk, reset, enabled, D[1], Q[1]);
    FF_D_1 U0 (.clk(clk), .reset(reset), .enabled(enabled), .D(D[0]), .Q(Q[0]));

endmodule
