module fsm_dispensador #(
    //Codificação dos estados
                                                   //fsm_dispensador controla a ativação do alarme e
    parameter   ESPERAR = 2'b00 ,                  //do dispensador
                ALARME  = 2'b01 ,                  //Máquina de Moore
                ACIONAR_DISPENSADOR = 2'b10
) (
    input   CR,                                    //CR: 1 = Cinco rolhas restantes na bandeja
            BZ,                                    //BZ: 1 = Zero rolhas restantes na bandeja
            clk ,
            reset ,
        
    output      AD,                                //Acionar Dispensador
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

assign AD = (state[1] & ~state[0]) & reset;         // AD = 1 quando state: 10
assign A  = state[0] & reset;                       // A = 1 sempre que state: X1(BZ: 1)
                                                    //state: 00 -> Saídas: 00

endmodule