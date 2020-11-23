//contador de 12 bits, cuenta con el eneable en 1 y si load es 1 pasa el alor de carga que viene del addres_RAM
module counter (input clk, reset, enabled, load, input [11:0] loadData, output reg [11:0] outValue);

    always @ (posedge clk, posedge reset) begin
        if (reset)
            outValue <= 12'b0;
        else if (load)
            outValue <= loadData;
        else if (enabled)
            outValue <= outValue + 1;
    end

endmodule
