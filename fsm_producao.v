module fsm_producao #(
    parameter   ENCHIMENTO = 1'b0 ,
                VEDACAO    = 1'b1 
) (
    input   PG , 
            CH , 
            RO ,
            clk ,
            reset ,
    
    output reg  GP ,
                M ,
                EV ,
                VE ,
                
    output reg  state ,
                next
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state <= ENCHIMENTO;
    end
    else state <= next;

end
    
always @* begin
    next = ENCHIMENTO;
    case (state)
        ENCHIMENTO: if (CH) next = VEDACAO;
        VEDACAO:    if (!RO) next = VEDACAO; 
    endcase
end
    
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        GP <= 1'b0;
        M  <= 1'b0;
        EV <= 1'b0;
        VE <= 1'b0;
    end
    else begin
        GP <= 1'b0;
        M  <= 1'b0;
        EV <= 1'b0;
        VE <= 1'b0;
        case (next)
            ENCHIMENTO: if (state) begin
                            GP <= 1'b1;
                            M  <= 1'b1;
                        end
                        else begin
                            if      (!PG)   M  <= 1'b1;
                            else            EV <= 1'b1;
                        end
            VEDACAO:    VE <= 1'b1;
        endcase
    end
    
end

endmodule