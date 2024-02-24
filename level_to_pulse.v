module level_to_pulse #(                                        //Máquina que transforma um sinal positivo
                                                                //em level, para um único pulso positivo
    //Codificação dos estados
    parameter   IDLE        = 2'b00 ,                           //Máquina de Moore
                PULSE       = 2'b01 ,
                PULSE_END   = 2'b10
) (
    input   clk ,
            level ,                                             //Input level, no caso um botão
            reset ,

    output  pulseOut ,

    output  reg [1:0]   state ,
                         next 
);
    always @(posedge clk or negedge reset) begin                //always sequencial para mudança de estado
        if (!reset) state <= IDLE;
        else state <= next;
    end

    always @* begin                                             //always combinacional para gerar o proximo estado
        next = IDLE;                                            //valor padrão, caso nenhum dos IFs seja atingindo
        case (state)
            //Caso o botão esteja pressionado e no estado IDLE, o proximo estado é PUlSE
            //Caso contrário, o proximo estado IDLE
            IDLE:       if (level)  next = PULSE;
            //Caso o botão esteja pressionado e no estado PULSE, o proximo estado é PUlSE_END
            //Caso contrário, o proximo estado IDLE
            PULSE:      if (level)  next = PULSE_END;
            //Caso o botão esteja pressionado e no estado PULSE_END, o proximo estado é PUlSE_END
            //Caso contrário, o proximo estado IDLE
            PULSE_END:  if (level)  next = PULSE_END; 
        endcase
    end

assign pulseOut = ~state[1] & state[0];             //pulse = 1 apenas quando state: 01
                                                    //quando state: 00 ou 10 -> pulse = 0

endmodule