module automacao (
	input 	start ,
			PG ,
			CH ,
			RO ,
			clk ,
			assync ,
			reset ,

	output [6:0] 	display_data , 
	output [9:0] 	leds_bar

);

fsm_controle fsm_controle_1 (
	.PG 	(PG) ,
	.CH 	(CH) ,
	.RO 	(RO) ,
	.clk 	(assync) ,
	.reset 	(reset) ,

	.NEXT 	(NEXT) ,
	.GP 	(GP) 
);

fsm_processo fsm_processo_1 (
	.clk 	(NEXT) ,
	.reset 	(reset) ,

	.VE 	(VE) ,
	.EV 	(EV) ,
	.M		(M)
);

fsm_dispensador fsm_dispensador_1 (
	.MC		(MC) ,
	.BZ		(BZ) ,
	.clk 	(assync) ,
	.reset 	(reset) ,

	.AD  	(AD) ,
	.A  	(A) 
);

counter #(.DATAWIDTH(4)) DownCounterMod10 (
	.clock (clk)

);

endmodule