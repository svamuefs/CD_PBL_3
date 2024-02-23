module duzias (                                 //Contabiliza a quantidade de duzias de garrafas produzidas
    input clk , reset ,                         //o clk em questão é GP

    output [3:0]    unidades_duzias ,           //decimal codificado em binario
                    dezenas_duzias              //decimal codificado em binario
);

counter #(                                      //Contador de uma duzia, estado inicial: 11(1011);
    .START  (4'b1011) ,                         //estado final: 0(0000), contador decrescente
    .ENDING (4'b0000)
) counter_duzias (
    .clk    (clk) ,
    .rst    (reset) ,
    .down   (1'b1) ,

    .out    (duzia)
);

wire [3:0]  duzia;

counter #(                                      //Contador das unidades das duzia totais
    .START      (4'b0000) ,                     //Estado inicial: 0(0000); Estado final: 9(1001)
    .ENDING     (4'b1001)                       //Contador crescente
) counter_unidades (
    .clk    (duzia == 4'b1011) ,
    .rst    (reset) ,
    .down   (1'b0) ,

    .out    (unidades_duzias)
);

counter #(                                      //Contador das dezenas das duzia totais
    .START      (4'b0000) ,                     //Estado inicial: 0(0000); Estado final: 9(1001)
    .ENDING     (4'b1001)                       //Contador crescente
) counter_dezenas (
    .clk    (unidades_duzias == 4'b0000) ,
    .rst    (reset) ,
    .down   (1'b0) ,

    .out    (dezenas_duzias)
);  

endmodule