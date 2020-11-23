//modulo de la rom
module ROM (input [11:0] address, output [7:0] data);

    reg [7:0] memory [0:4096];

    //para leer el valor del .list
    initial
        $readmemh("memory.list", memory);
        
    //para cargar el valor en la casilla seleccionada
    assign data = memory[address];

endmodule
