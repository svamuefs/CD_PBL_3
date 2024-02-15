module fulladder #(
    parameter DATAWIDTH = 4 
) (
    input   [DATAWIDTH-1:0] IN_a , IN_b

    output  [DATAWIDTH:0] Out ,
);
    
    Out = IN_a + IN_b;

endmodule