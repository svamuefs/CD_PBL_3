module bandeja (
    input   clk ,                           //Clock
            reset ,                         //Reset
            reabastecer ,                   //1 = Incrementar a quantidade de rolhas em 20

    output  CR ,                            //1 = Cinco rolhas restantes
            BZ ,                            //1 = Zero rolhas restantes

    output [3:0]    unidades_bandeja ,      //Decimal em Binario representando as unidades de rolhas
                    dezenas_bandeja         //Decimal em Binario representando as dezenas de rolhas
);

counter #(                                  //Contador das unidades, decrementa em 1 com cada pulso
                                            //de clock. Começa em 9(1001) e termina em 0(0000).
    //Parametros                                    
    .START  (4'b1001) ,
    .ENDING (4'b0000)

) counter_unidades (

    //Inputs
    .clk    (clk) ,
    .rst    (reset) ,
    .down   (1'b1) ,

    //Outputs
    .out    (unidades_bandeja)
);

counter #(                                  //Contador das unidades, decrementa em 1 cada vez que
                                            //o contador de unidades passa de 0 para 9. 
                                            //Começa em 2(10) e termina em 0(00).
    //Parametros
    .START      (4'b0010) ,
    .ENDING     (4'b0000)

) counter_dezenas (

    //Inputs
    .clk    (unidades_bandeja == 4'b1001) ,
    .rst    (~reabastecer & reset) ,        //Reset composto da variavel reabastecer e reset, dessa 
                                            //maneira é possivel simular o reabastecimento de 20 rolhas
                                            //na bandeja resetando o contador de dezenas para 2(10)
    .down   (1'b1) ,
                                            //Reabastecer: 1 = adicionar 20 rolhas na bandeja. 
    //Outputs
    .out    (dezenas_bandeja)
);

//PERGUNTA: Deveria ser refeito em estrutural?

assign CR = ((unidades_bandeja == 4'b0101) & ~dezenas_bandeja[1] & ~dezenas_bandeja[0]) & reset; 
//CR é 1 quando: Há cinco unidades de rolhas e 0 dezenas de rolhas

assign BZ = ((unidades_bandeja == 4'b0000) & ~dezenas_bandeja[1] & ~dezenas_bandeja[0]) & reset;
//BZ é 1 quando: Há zero unidades de rolhas e 0 dezenas de rolhas

endmodule