//modulo de la ram
module RAM (input [11:0] address_ram, input csRAM, weRAM, inout [3:0] data);
    reg [3:0] RAM1 [0:4095];
    reg [3:0] salida;

    //asignacion del data que es el inout
    assign data = (csRAM & ~weRAM) ? salida: 4'bzzzz;

    //para escribir en la ram o para sacar el valor al data_bus dependiendo de las entradas csRAM y weRAM
    always @(csRAM, weRAM, data, address_ram) begin
    if (~weRAM & csRAM)
      salida = RAM1[address_ram];
      else if(csRAM & weRAM)
      RAM1[address_ram] = data;
    end
endmodule
