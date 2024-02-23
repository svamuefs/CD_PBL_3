module debouncer (
    input button , clk ,
    
    output out
);

    //O botão mantem o contador parado até ser pressionado.
    and andClk (clk_w , button , clk , notEnable);

    //Contador de 3 bits síncrono.
   t_flipflop tff0 (
        .t(1'b1) ,
        .clk (clk_w) ,
        .reset (button) ,

        .out (tff0Out)
    );

    t_flipflop tff1 (
        .t(tff0Out) ,
        .clk (clk_w) ,
        .reset (button) ,

        .out (tff1Out)
    );

    and and2 (and2Out , tff0Out , tff1Out);

    t_flipflop tff2 (
        .t(and2Out) ,
        .clk (clk_w) ,
        .reset (button) ,

        .out (tff2Out)
    );
	 
	 and and3 (and3Out , tff2Out , and2Out);

    t_flipflop tff3 (
        .t(and3Out) ,
        .clk (clk_w) ,
        .reset (button) ,

        .out (tff3Out)
    );
	 
	 and and4 (and4Out , tff3Out , and3Out);

    t_flipflop tff4 (
        .t(and4Out) ,
        .clk (clk_w) ,
        .reset (button) ,

        .out (tff4Out)
    );

    //Ao final da contagem: 111; O enable mantem o clock do contador em nivel alto, parando o contador 
    //e permitindo a passagem do sinal para a saída.

    and and0 (enable , tff0Out , tff1Out , tff2Out , tff3Out , tff4Out);
    not not0 (notEnable , enable);

    and andOut (out , button , enable);

endmodule