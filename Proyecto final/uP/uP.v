/*`include "ALU.v"
`include "buffer.v"
`include "counter.v"
`include "Decode.v"
`include "FF_D_1.v"
`include "FF_D_2.v"
`include "FF_D_4.v"
`include "FF_D_8.v"
`include "FF_T.v"
`include "RAM.v"
`include "ROM.v"*/

/*
Juan Diego Villafuerte Pazos 19593
Universidad del Valle de Guatemala
22/11/2020
*/

//modulo de conecciones entre los modulos que componene el procesador

//declaracion para variables de entrada y salida del procesador entero
module uP(input clock, reset,
            input [3:0] pushbuttons,
            output c_flag, z_flag, phase,
            output [7:0] program_byte,
            output [3:0] instr, oprnd, data_bus, FF_out, accu,
            output [11:0] PC, address_RAM);

//declaracion de wires y cables para el procesador, concatenaciones, entre otros
    wire [11:0] PC;
    wire [7:0] program_byte, enFetch;
    wire [3:0] instr, oprnd;
    wire [3:0] data_bus, aluResult;
    wire c_flag, z_flag, z0, c;
    wire phase;
    wire incPC, loadPC, loadA, loadFlags, S2, S1, S0,
    csRAM, weRAM, oeALU, oeIN, oeOprnd, loadOut;

//asignacion de concatenaciones, la de entrada de la ram y el contador, y la de la divicion de salida para el fetch
    assign address_RAM = {oprnd, program_byte};
    assign instr = enFetch[7:4];
    assign oprnd = enFetch[3:0];

// puertos de counter -> input clk, reset, enabled, load, input [11:0] loadData, output reg [11:0] outValue
    counter U1(clock, reset, incPC, loadPC, address_RAM, PC);

// puertos de ROM -> input [11:0] address, output [7:0] data
    ROM U2 (PC, program_byte);

// puertos de FF_D -> input clk, reset, enabled, input [7:0] D, output reg [7:0] Q
//Fetch, lleva el phase negado como eneable y la asignacion de enFetch como salida
    FF_D_8 U3 (clock, reset, ~phase, program_byte, enFetch);


// puertos de buffer -> input enabled, input [3:0] A, output [3:0] Y
//BusDriver del data_bus conectdo al fetch y de la salida de la alu que conecta al data_bus
    buffer U4(oeOprnd, oprnd, data_bus);
    buffer U5(oeALU, aluResult, data_bus);

// puertos de ALU -> input [3:0] A, B, input [2:0] F, output C, Z, output [3:0] S
    ALU U6(.A(accu), .B(data_bus), .F({S2, S1, S0}), .C(c), .Z(z0), .S(aluResult));

// puertos de FF_D -> input clk, reset, enabled, input [3:0] D, output reg [3:0] Q
// este es el acumulador con la salida accu directa a la entrada A de la ALU
    FF_D_4 U7(clock, reset, loadA, aluResult, accu);



// puertos de FF_D_2 -> input clk, reset, enabled, input [1:0] D, output reg [1:0] Q
// corresponde a flags que es entrada del decode con salidas de c_flag y z_flag
    FF_D_2 U8(clock, reset, loadFlags, {c, z0}, {c_flag, z_flag});

// puertos de FF_T -> input clk, reset, enabled, output Q
// unico ff t para el phase conectado al decode
    FF_T U9(clock, reset, 1'b1, phase);

// puertos de Decode -> input [6:0] address, output [12:0] signals
// de entrada la concatenacion de 3 variables o wires y salida las 13 eneables y direcciones que controlas el procesador
    Decode U10({instr, c_flag, z_flag, phase},
    {incPC, loadPC, loadA, loadFlags, S2, S1, S0, csRAM, weRAM, oeALU, oeIN, oeOprnd, loadOut});



// puertos de RAM -> input [11:0] address_ram, input csRAM, weRAM, input [3:0] data
// con data como inout para que el funcionamiento permita escribir en ram y extraer datos del/al data_bus
    RAM U11(address_RAM, csRAM, weRAM, data_bus);

// puertos de FF_D -> input clk, reset, enabled, input [3:0] D, output reg [3:0] Q
// para las salidas fisicas del procesador
    FF_D_4 U12(clock, reset, loadOut, data_bus, FF_out);

// puertos de buffer -> input enabled, input [3:0] A, output [3:0] Y
// para las entradas fisicas del procesador que en este caso son pushbuttons
    buffer U13(oeIN, pushbuttons, data_bus);

endmodule
