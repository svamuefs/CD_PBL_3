module fsm_processo #(
    parameter   SEM_GARRAFA = 0,
                GARRAFA_VAZIA = 1,
                GARRAFA_CHEIA = 2
) (
    input   clk ,
            reset ,
    
    output reg  VE ,
                EV ,
                M ,

    output reg [2:0]    state ,
                        nextState

);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state <= 3'b0;
        state[SEM_GARRAFA] <= 1'b1;
    end
    else state <= nextState;
end
    
always @* begin
    nextState = 3'b0;

    case (1'b1)
        state[SEM_GARRAFA]   : nextState[GARRAFA_VAZIA] = 1'b1; 
        state[GARRAFA_VAZIA] : nextState[GARRAFA_CHEIA] = 1'b1;
        state[GARRAFA_CHEIA] : nextState[SEM_GARRAFA]   = 1'b1; 
    endcase
    
end

always @(posedge clk or negedge reset) begin
    if (!reset) begin
       VE <= 1'b0; 
       EV <= 1'b0;
       M <= 1'b1;
    end
    else begin
       VE <= nextState[GARRAFA_CHEIA]; 
       EV <= nextState[GARRAFA_VAZIA];
       M  <= nextState[SEM_GARRAFA];
    end
end

endmodule