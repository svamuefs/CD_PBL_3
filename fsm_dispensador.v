module fsm_dispensador #(
    //Codificação dos estados
                                                   //fsm_dispensador controla a ativação do alarme e
    parameter   ESPERAR = 2'b00 ,                  //do dispensador
                ALARME  = 2'b01 ,
                ACIONAR_DISPENSADOR = 2'b10
) (
    input   CR,                                    //CR: 1 = Cinco rolhas restantes na bandeja
            BZ,                                    //BZ: 1 = Zero rolhas restantes na bandeja
            clk ,
            reset ,
        
    output reg  AD,                                //Acionar Dispensador
                A ,                                //Acionar Alarme

    output reg [1:0]    state ,
                        next
);

always @(posedge clk or negedge reset) begin        //always sequencial para mudança de estado
    if (!reset) begin
        state <= ESPERAR;
    end
    else state <= next;
end

always @* begin                                     //always combinacional para decidir o proximo estado
    next = ESPERAR;                                 //valor padrão, caso nenhum dos IFs seja atingindo

    case (state)         
        //ESPERAR e ACIONAR_DISPENSADOR possuem as mesmas transições    
        //Caso não haja rolhas na bandeja o proximo estado é alarme
        //Caso hajam cinco rolhas na bandeja o proximo estado é acionar_dispensador                       
        ESPERAR, ACIONAR_DISPENSADOR:   if      (BZ) next = ALARME;                  
                                        else if (CR) next = ACIONAR_DISPENSADOR;

        //Quando em alarme, só sairá do estado de alarme quando a bandeja não estiver vazia
        ALARME :    if (BZ) next = ALARME;
    endcase
end

always @(posedge clk or negedge reset) begin        //always sequencial para registrar as saídas
    if (!reset) begin
        AD <= 1'b0;
        A  <= 1'b0;
    end
    else begin  
        AD <= 1'b0;                                 //Valores de saída padrão: 00 (AD , A)
        A  <= 1'b0;
        case (next)                                 //next é usado no case para sincronizar as saidas
                                                    //com a mudança de estado
            ESPERAR: ;                              //00
            ACIONAR_DISPENSADOR: AD <= 1'b1;        //10
            ALARME:  A <=  1'b1;                    //01
        endcase
    end
end

endmodule