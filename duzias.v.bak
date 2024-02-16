module duzias (
    input clk , reset ,

    output [3:0]    unidades_duzias , 
                    dezenas_duzias
);

counter #(
    .START  (4'b1100) ,
    .ENDING (4'b0000) ,
) counter_unidades (
    .clk    (clk) ,
    .rst    (reset) ,
    .down   (1'b1) ,

    .out    (duzia)
);

counter #(
    .START      (4'b0000) ,
    .ENDING     (4'b1001) ,
) counter_dezenas (
    .clk    (duzia == 4'b0000) ,
    .rst    (reset) ,
    .down   (1'b1) ,

    .out    (unidades_duzias)
);

counter #(
    .START      (4'b0000) ,
    .ENDING     (4'b1001) ,
) counter_dezenas (
    .clk    (unidades_duzias == 4'b0000) ,
    .rst    (reset) ,
    .down   (1'b1) ,

    .out    (dezenas_duzias)
);  

endmodule