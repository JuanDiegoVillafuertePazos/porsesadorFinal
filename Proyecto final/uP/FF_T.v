//`include "FF_D_1.v"
//FF T con un FF de 1 bit
module FF_T(input clk, reset, enabled, output Q);
    wire notQ;
    not v1(notQ, Q);
    // alternativa en 1 línea:
     FF_D_1 U1(clk, reset, enabled, notQ, Q);


endmodule
