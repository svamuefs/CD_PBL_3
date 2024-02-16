module counter #(
    parameter   DATAWIDTH   = 4 ,                   //Quantidade de bits do contador. 
                START       = 4'b0000 ,             //Posição de inicio do contador.
                ENDING      = 4'b1111               //Posição final do contador.
) (
    input   clk ,                                   
            rst ,
            down ,
            load ,

    input   [DATAWIDTH-1:0] load_value ,

    output  reg [DATAWIDTH-1:0] out
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out <= START;
    end

    else if (load) out <= load_value;

    else if (out == ENDING) out <= START;

    else out <= down ? out - 1'b1 : out + 1'b1;

end
    
endmodule