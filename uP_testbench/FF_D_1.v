//FF de 1 bit
module FF_D_1(input clk, reset, enabled, D, output reg Q);

    always @ (posedge clk, posedge reset)
        if (reset)
            Q = 1'b0;
        else if (enabled)
            Q = D;
endmodule
