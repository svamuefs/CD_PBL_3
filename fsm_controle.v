module fsm_controle #(
    parameter   ENCHIMENTO = 1'b0 ,
                VEDACAO    = 1'b1
) (
    input   PG , 
            CH , 
            RO ,
            clk ,
            reset ,
    
    output reg  NEXT ,
        GP ,
                
    output reg  state,
                nextState
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
    state <= ENCHIMENTO;
    end
    else state <= nextState;
end
    
always @* begin
    nextState = (~PG & CH & RO) | (PG & ~state);
    NEXT = (~PG & CH) | (PG & state);
    GP = (PG & state);
    end
    

endmodule