module assync_clk_enable (
    input start , clk , assync , reset ,

    output assyncClk
);

debouncer debouncer_start (
	.button	(start) ,
	.clk	(clk) ,

	.out	(debouncedStart)
);

level_to_pulse level_to_pulse_1 (
	.clk		(clk) ,
	.level		(debouncedStart) ,
	.reset		(reset) ,

	.pulse		(pulse)
);

t_flipflop TFF_1 (
	.t 		(pulse) ,
	.clk	(clk) ,
	.reset	(reset) ,
	
	.out	(enable)
);
    
and andOut (assyncClk , enable , assync);

endmodule