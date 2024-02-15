module automacao (
	input 				start ,
						PG ,
						CH ,
						RO ,
						clk50MHz ,
						assync ,
						reset ,

	output 				EV ,
						VE ,
						M  ,
						A  ,

	output [3:0]		display_colune ,
	output [6:0] 		display_data , 


);

//organizar reset, start e enable
//testar todos os modulos isoladamente

sync_freq_divider sync_freq_divider_1 (
	.clk				(clk50MHz) ,
	.enable				(1'b1) , 					//!!!!!!

	.final_clk			(clk)
);

debouncer debouncer_start (
	.button				(start) ,
	.clk				(clk) ,

	.out				(debouncedStart)
);

level_to_pulse level_to_pulse_1 (
	.clk				(clk) ,
	.level				(debouncedStart) ,
	.reset				(1'b1) ,//!!!!!!!!

	.pulse				(pulse)
);

t_flipflop ON_OFF (
	.t 					(pulse) ,
	.clk				(clk) ,
	.reset				(1'b1) ,//!!!!!!!!

	.out				(enable)
);
    
and andOut (assyncClk , enable , assync);

fsm_controle fsm_controle_1 (
	.PG 				(PG) ,
	.CH 				(CH) ,
	.RO 				(RO) ,
	.clk 				(assyncClk) ,
	.reset 				(enable) ,///!!!!!!!!

	.NEXT 				(NEXT) ,
	.GP 				(GP) 
);

fsm_processo fsm_processo_1 (
	.clk 				(NEXT) ,
	.reset 				(enable) ,///!!!!!!!

	.VE 				(VE) ,
	.EV 				(EV) ,
	.M					(M)
);

fsm_dispensador fsm_dispensador_1 (
	.MC					(MC) ,
	.BZ					(BZ) ,
	.clk 				(assyncClk) ,
	.reset 				(enable) ,////!!!!!

	.AD  				(AD_w) ,
	.A  				(A) 
);

assign AD = AD_w;

bandeja bandeja_1 (
	.clk				(GP) ,
	.reset 				(enable) ,////!!!!!
	.reabastecer 		(reabastecer) ,

	.MC					(MC) ,
	.BZ					(BZ) ,
	.unidades_bandeja	(unidades_bandeja) ,
	.dezenas_bandeja	(dezenas_bandeja)
);

dispensador dispensador_1 (
	.ativar				(AD_w) ,
	.reset				(enable) ,//!!!!

	.reabastecer		(reabastecer)
);

duzias duzias_1 (
	.clk				(GP) ,
	.reset				(~pulse) ,//!!!!!

	.unidades_duzias 	(unidades_duzias) ,
	.dezenas_duzias		(dezenas_duzias)
);

//multiplexação

counter #(
	.DATAWIDTH			(2) ,
	.START				(2'b00) , 
	.ENDING				(2'b11) 
) counter_display (
	.clk 				(clk) ,
	.rst				(enable) ,//!!!!
		
	.out				(counter_displayOut)
);

wire [1:0] counter_displayOut;
wire [3:0] display_data_bin , dezenas_duzias , unidades_duzias , dezenas_bandeja , unidades_bandeja;


mux4x1 display_data_mux (
	.IN_A				(dezenas_duzias) ,
	.IN_B				(unidades_duzias) ,
	.IN_C				(dezenas_bandeja) ,
	.IN_D				(unidades_bandeja) ,
	.slc				(counter_displayOut) ,

	.out				(display_data_bin) ,
);

display_decoder display_decoder_1 (
	.binary_code		(display_data_bin) ,
	.enable				(enable) ,						//!!!

	.digitOut			(display_data)
);

//???
mux4x1 display_colune_mux (
	.IN_A				(4'b1000) ,
	.IN_B				(4'b0100) ,
	.IN_C				(4'b0010) ,
	.IN_D				(4'b0001) ,
	.slc				(counter_displayOut) ,

	.out				(display_colune) ,
);

endmodule