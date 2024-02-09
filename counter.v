module counter #(
    parameter   DATAWIDTH   = 4 ,
                START       = 4'b0000 ,
                ENDING      = 4'b1111 
) (
    input   clk ,
            rst ,
            down ,
            load ,

    input   [DATAWIDTH-1:0] load_value ,

    output  [DATAWIDTH-1:0] out
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out <= START;
    end

    else if (load) out <= load_value;

    else out <= down ? out - 1 : out + 1;
end
    
endmodule