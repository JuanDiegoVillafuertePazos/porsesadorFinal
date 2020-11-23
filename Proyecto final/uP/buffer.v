module buffer(input enabled, input [3:0] A, output [3:0] Y);

    // asignacion para la salida del buffer
    assign Y = enabled ? A : 4'bz;

endmodule
