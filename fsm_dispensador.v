module fsm_dispensador #(
    parameter   ESPERAR = 2'b00;
                ALARME  = 2'b01;
                ACIONAR = 2'b10; 
) (
    input   MC, 
            BZ,
        
    output reg  AD,
                A ,

    output reg [1:0]    state ,
                        nextState
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state <= ESPERAR;
    end
    else state <= nextState;
end

always @* begin
    nextState = 2'bxx;
    case (state)
        ESPERAR, ACIONAR:    if      (BZ) nextState = ALARME;
                             else if (MC) nextState = ACIONAR;
                             else         nextState = ESPERAR;
        ALARME : nextState = ALARME;
    endcase
end

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        AD <= 1'b0;
        A  <= 1'b0;
    end
    else begin  
       AD <= nextState[1]; 
       A  <= nextState[0];
    end
end

endmodule