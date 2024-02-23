module colune_decoder
 (
    input [1:0] code, 

    output [3:0] display_colune
);

    assign display_colune[3] = (~code[1] & ~code[0]);       //00 -> 1000

    assign display_colune[2] = (~code[1] & code[0]);        //01 -> 0100

    assign display_colune[1] = (code[1] & ~code[0]);        //10 -> 0010

    assign display_colune[0] = (code[1] & code[0]);         //11 -> 0001
    
endmodule