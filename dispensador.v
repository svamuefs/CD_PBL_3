module dispensador (                            //Contabiliza o número de rolhas no dispensador
    input ativar , reset ,                      //Ativar é um input produzido pela fsm_dispensador
                                                //significando que a bandeja possui apenas 5 rolhas
    output reabastecer                          //e portanto deve ser reabastercida
);
                                                //Reabastecer é um output que é usado como input no 
counter #(                                      //modulo da bandeja. Para que a bandeja seja efetivamente
    .DATAWIDTH  (3) ,                           //reabastecida, ou seja reabastecer = 1, é necessário que  
    .START      (3'b101) ,                      //hajam rolhas no dispensador para serem repostas na bandeja
    .ENDING     (3'b000)                        
) quantidade_rolhas (                           //1 no contador equivale a 20 rolhas, no total são 100 rolhas
    .clk        (reabastecer) ,                 //Reabastecer é usado como clock, dessa maneira, reduzindo
    .rst        (reset) ,                       //as 20 rolhas do dispensador
    .down       (1'b1) ,

    .out        (qt)
);

assign reabastecer = ativar & (qt != 3'b000);   //Reabastecer é 1 quando: o dispensador for acionado pela
                                                //fsm_dispensador e houverem rolhas para reposição

endmodule