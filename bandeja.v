module bandeja (
    input   clk ,

    output [3:0]    unidades_bandeja , 
                    dezenas_bandeja
);

counter #(
    .START  (4'b1001) ,
    .ENDING (4'b0000) ,
) counter_unidades (
    .clk    (clk) ,
    .rst    (rst) ,
    .down   (1'b1) ,

    .out    (unidades_bandeja)
);

counter #(
    .START  (4'b1001) ,
    .ENDING (4'b0000) ,
) counter_dezenas (
    .clk    (unidades_bandeja == 4'b0000) ,
    .rst    (rst) ,
    .down   (1'b1) ,

    .out    (dezenas_bandeja)
);

endmodule