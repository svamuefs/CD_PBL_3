module fsm_producao #(                              //Máquina de mealy responsavel por controlar as
    //Codificação de Estados                        //estapas de produção e acionamento dos mecanismos
    parameter   ENCHIMENTO = 1'b0 ,                 //da automação
                VEDACAO    = 1'b1 
) (
    //Sensores
    input   PG ,                                    //PG: 1 = Presença de garrafa
            CH ,                                    //CD: 1 = Garrafa cheia
            RO ,                                    //RO: 1 = Há rolhas para vedação
    ////
            clk ,
            reset ,
    
    output      GP ,                                //GP: 1 = Uma Garrafa produzida
                M ,                                 //M : 1 = Motor da esteira Ligado
                EV ,                                //EV: 1 = Valvula de enchimento ligada
                VE ,                                //VE: 1 = Processo de vedação iniciado
                
    output reg  state ,
                next
);

always @(posedge clk or negedge reset) begin    //always sequencial para mudança de estado
    if (!reset) begin
        state <= ENCHIMENTO;
    end
    else state <= next;

end
    
always @* begin                                 //always combinacional para decidir o proximo estado
    next = ENCHIMENTO;                          //valor padrão, caso nenhum dos IFs seja atingindo
    case (state)
        //Caso estado atual seja enchimento e a garrafa esteja cheia, passar para a vedação
        ENCHIMENTO: if (CH) next = VEDACAO;
        //Caso estado atual seja vedação e não houver rolhas, manter-se na vedação
        //Caso haja rolha, passar para o enchimento
        VEDACAO:    if (PG) next = VEDACAO;
    endcase
end
    
//Vou deixar esse terceiro always comentado, ele demonstra bem como as saídas se relacionam com os
//estados

//always @(posedge clk or negedge reset) begin    //always sequencial para registrar as saídas
//    if (!reset) begin
//        GP <= 1'b0;
//        M  <= 1'b0;
//        EV <= 1'b0;
//        VE <= 1'b0;
//    end
//    else begin
//        GP <= 1'b0;                             //Valores de saída padrão: 0000(GP,M,EV,VE)
//        M  <= 1'b0;                             //Dentro dos cases e IFs, apenas os valores diferentes
//        EV <= 1'b0;                             //dos valores padrões serão manipulados
//        VE <= 1'b0;
//        case (next)                             //next é usado no case para sincronizar as saidas
                                                //com a mudança de estado

//            ENCHIMENTO: if (state) begin        //if (state) , para determinar qual o estado de partida
                                                //e então determinar a saída

                            //Caso estado atual seja vedação e o proximo é enchimento, há apenas uma
                            //combinação de saídas:
//                           GP <= 1'b1;         
//                            M  <= 1'b1;  
                            //Uma garrafa produzida e a esteira volta a girar
                            //1100
//                        end
//                        else begin
                            //Caso estado atual seja enchimento e o proximo também, há duas 
                            //combinações de saídas:
                            //Caso não haja garrafa na posição, a esteira continua girando: 0100
//                            if      (!PG)   M  <= 1'b1;
                            //Caso haja uma garrafa na posição, a valvula de enchimento é ativada: 0010
//                            else            EV <= 1'b1;
//                        end
            
//            VEDACAO:    VE <= 1'b1;             //Caso proximo estado seja vedação, o processo de 
                                                //vedação é sempre ativado: 0001
//        endcase
//    end
    
//end

assign M = ((~PG) | (state & RO)) & reset;
assign EV = ((~state & PG & ~CH)) & reset;
assign VE = ((~state & PG & CH) | (state & PG & ~RO)) & reset;
assign GP = ((state & PG & RO)) & reset;

endmodule