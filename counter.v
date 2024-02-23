module counter #(
    parameter   DATAWIDTH   = 4 ,                   //Quantidade de bits do contador. 
                START       = 4'b0000 ,             //Posição de inicio do contador.
                ENDING      = 4'b1111               //Posição final do contador.
) (
    input   clk ,
            rst ,
            down ,                                  //down: 1 = contador decrescente

    output  reg [DATAWIDTH-1:0] out 
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out <= START;
    end

    else if (out == ENDING) out <= START;           //loop completo

    else out <= down ? out - 1'b1 : out + 1'b1;     //quando down = 1: out - 1; quando down = 0: out + 1

end
    
endmodule