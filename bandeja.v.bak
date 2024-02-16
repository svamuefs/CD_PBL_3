module bandeja (
    input   clk ,
            reabastecer ,
            reset ,

    output  MC , BZ ,
    output [3:0]    unidades_bandeja , 
                    dezenas_bandeja 
);

counter #(
    .START  (4'b1001) ,
    .ENDING (4'b0000) ,
) counter_unidades (
    .clk    (clk) ,
    .rst    (reset) ,
    .down   (1'b1) ,

    .out    (unidades_bandeja)
);

counter #(
    .DATAWIDTH  (2)
    .START      (2'b10) ,
    .ENDING     (2'b00) ,
) counter_dezenas (
    .clk    (unidades_bandeja == 4'b0000) ,
    .rst    (~reabastecer & reset) ,
    .down   (1'b1) ,

    .out    (dezenas_bandeja)
);

assign MC = (unidades_bandeja == 4'b1001) & ~dezenas_bandeja[1] & ~dezenas_bandeja[0]; 
assign BZ = (unidades_bandeja == 4'b0000) & ~dezenas_bandeja[1] & ~dezenas_bandeja[0];
endmodule