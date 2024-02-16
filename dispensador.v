module dispensador (
    input ativar , reset ,

    output reabastecer 
);

counter #(
    .DATAWIDTH  (3) ,
    .START      (3'b101) ,
    .ENDING     (3'b000)
) quantidade_rolhas ( //1 = 20
    .clk        (ativar & (qt != 3'b000)) ,
    .rst        (reset) ,
    .down       (1'b1) ,

    .out        (qt)
);

assign reabastecer = ativar & (qt != 3'b000);


endmodule