module automacao (
	input 				start , 				//Botão on/off
						PG_button ,					//Presença de Garrafa: 0 = sem garrafa
						CH_button ,					//1 = Garrafa Cheia
						RO_button ,					//1 = Rolha Disponível
						clk50MHz ,				//Clock da placa	

	output				EV ,					//1 = Valvula de enchimento ativada
						VE ,					//1 = Processo de vedação ativado
						M  ,					//1 = Motor ativado
						A  ,					//1 = Alarme ativado
						AD ,					//1 = Dispensador ativado
						PG_Out ,
						CH_Out ,
						RO_Out ,
						

	output [3:0]		display_colune ,		//Vetor para Ativação das colunas (1000 -> 0100 ...)
	output [6:0] 		display_data ,	 		//Vetor para quais segmentos ativar na display

	output				GP_led ,					//1 = Uma garrafa produzida
						reabastecer_led			//1 = dispensador tem rolhas para reposição

);

assign GP_led = GP;
assign reabastecer_led = reabastecer;
assign RO_Out = RO;
assign PG_Out = PG;
assign CH_Out = CH;

///////////////

//ON/OFF , CLOCK E CONTROLE ASSINCRONO	

sync_freq_divider sync_freq_divider_1 (			//Divisor de frequência, f/2^13.
	//Inputs									//50MHz -> 6KHz
	.clk				(clk50MHz) ,
	.enable				(1'b1) , 				

	//Outputs
	.final_clk			(clk)
);

//Comente o modulo acima e retire do comentario a linha abaixo, antes de testar no waveform

//assign clk = clk50MHz;

debouncer debouncer_start (
	//Inputs					
												//debouncer do botão start
	.button				(~start) ,				//sinal do botão invertido para utilizar na lógica	
	.clk				(clk) ,					//positiva do TFF

	//Outputs
	.out				(debouncedStart)
);

debouncer debouncer_PG (
	//Inputs					
												//debouncer do botão start
	.button				(~PG_button) ,				//sinal do botão invertido para utilizar na lógica	
	.clk				(clk) ,					//positiva do TFF

	//Outputs
	.out				(debouncedPG)
);

debouncer debouncer_CH (
	//Inputs					
												//debouncer do botão start
	.button				(~CH_button) ,				//sinal do botão invertido para utilizar na lógica	
	.clk				(clk) ,					//positiva do TFF

	//Outputs
	.out				(debouncedCH)
);

debouncer debouncer_RO (
	//Inputs					
												//debouncer do botão start
	.button				(~RO_button) ,				//sinal do botão invertido para utilizar na lógica	
	.clk				(clk) ,					//positiva do TFF

	//Outputs
	.out				(debouncedRO)
);

level_to_pulse level_to_pulse_PG (
	//Inputs
												//transforma um level em um pulso com a mesma largura
	.clk				(clk) ,					//do clock. Dessa maneira, mesmo pressionando o botão
	.level				(debouncedPG) ,		//só será gerado um unico pulso positivo.
	.reset				(1'b1) ,

	//Outputs
	.pulseOut			(pulsePG)
);

level_to_pulse level_to_pulse_CH (
	//Inputs
												//transforma um level em um pulso com a mesma largura
	.clk				(clk) ,					//do clock. Dessa maneira, mesmo pressionando o botão
	.level				(debouncedCH) ,		//só será gerado um unico pulso positivo.
	.reset				(1'b1) ,

	//Outputs
	.pulseOut			(pulseCH)
);

level_to_pulse level_to_pulse_RO (
	//Inputs
												//transforma um level em um pulso com a mesma largura
	.clk				(clk) ,					//do clock. Dessa maneira, mesmo pressionando o botão
	.level				(debouncedRO) ,		//só será gerado um unico pulso positivo.
	.reset				(1'b1) ,

	//Outputs
	.pulseOut			(pulseRO)
);

t_flipflop FF_PG (
	//Inputs
												//TFF utilizado para controlar o acionamento ou não da
	.t 					(pulsePG) ,				//automação, pressionar o botão start desliga e liga a
	.clk				(clk) ,					//automação, por conta do debouncer e do level_to_pulse
	.reset				(1'b1) ,				//não há risco de race condition

	//Outputs
	.out				(PG)
);

t_flipflop FF_CH (
	//Inputs
												//TFF utilizado para controlar o acionamento ou não da
	.t 					(pulseCH) ,				//automação, pressionar o botão start desliga e liga a
	.clk				(clk) ,					//automação, por conta do debouncer e do level_to_pulse
	.reset				(1'b1) ,				//não há risco de race condition

	//Outputs
	.out				(CH)
);

t_flipflop FF_RO (
	//Inputs
												//TFF utilizado para controlar o acionamento ou não da
	.t 					(pulseRO) ,				//automação, pressionar o botão start desliga e liga a
	.clk				(clk) ,					//automação, por conta do debouncer e do level_to_pulse
	.reset				(1'b1) ,				//não há risco de race condition

	//Outputs
	.out				(RO)
);

//debouncer debouncer_assync (			
	//Inputs
												//debouncer do controle assincrono
//	.button				(~assync) ,				//sinal do botão invertido para utilizar na lógica
//	.clk 				(clk) ,					//positiva das FSM
	//Outputs
//	.out 				(debouncedAssync)
//);

level_to_pulse level_to_pulse_start (
	//Inputs
												//transforma um level em um pulso com a mesma largura
	.clk				(clk) ,					//do clock. Dessa maneira, mesmo pressionando o botão
	.level				(debouncedStart) ,		//só será gerado um unico pulso positivo.
	.reset				(1'b1) ,

	//Outputs
	.pulseOut			(pulse)
);

t_flipflop ON_OFF (
	//Inputs
												//TFF utilizado para controlar o acionamento ou não da
	.t 					(pulse) ,				//automação, pressionar o botão start desliga e liga a
	.clk				(clk) ,					//automação, por conta do debouncer e do level_to_pulse
	.reset				(1'b1) ,				//não há risco de race condition

	//Outputs
	.out				(enable)
);
    
//and assyncClk_enable (assyncClk , enable , debouncedAssync); //and enable do controle assincrono

//MÁQUINAS DE ESTADO

fsm_producao fsm_producao (			
	//Inputs
												//A máquina de produção é responsável pelo controle 
	.PG 				(PG) ,					//das etapas de produção, e do acionamento do motor,
	.CH 				(CH) ,					//valvula de enchimento e vedação
	.RO 				(RO) , 
	.clk 				(clk) ,
	.reset 				(~A & enable) ,			//Condição de resete composta pelo enable e o alarme

	//Outputs
	.GP 				(GP) ,					//GP: 1 = uma garrafa produzida. Utilizada para 
	.VE 				(VE) ,					//contabilizar as rolhas e duzias produzidas
	.EV 				(EV) ,
	.M					(M)						//Mais detalhes do funcionamento no arquivo do módulo
);

fsm_dispensador fsm_dispensador_1 (
	//Inputs
												//A máquina do dispensador controla o acionamento do
	.CR					(CR) ,					//do dispensador e do alarme, com duas variaveis de
	.BZ					(BZ) ,					//transição: CR: 1 = Cinco rolhas restantes;
	.clk 				(clk) ,			//BZ: 1 = Bandeja com zero rolhas.
	.reset 				(enable) ,				

	//Outputs
	.AD  				(AD_w) ,				//AD: 1 = Acionar dispensador
	.A  				(A) 					//A : 1 = Acionar Alarme
);												//Mais detalhes do funcionamento no arquivo do módulo

assign AD = AD_w;		//Assign para monitoramento

//MÓDULOS PARA CONTABILIZAÇÃO DE ROLHAS E GARRAFAS

bandeja bandeja_1 (		
	//Inputs
												//Modulo para contabilizar a quantidade de rolhas
	.clk				(GP) ,					//na bandeja de vedação, GP é usado como clock para
	.reset 				(enable) ,				//os contadores dentro do módulo. Reabastecer é um 
	.reabastecer 		(reabastecer) ,			//input gerado pelo dispensador, quando ' 1 ', a 
												//bandeja acrescenta 20 rolhas aos contadores 

	//Outputs
	.CR					(CR) ,					//Sinais utilizados na fsm_dispensador.
	.BZ					(BZ) ,					//CR: 1 = Cinco rolhas restantes
	.unidades_bandeja	(unidades_bandeja) ,	//BZ: 1 = Zero rolhas restantes
	.dezenas_bandeja	(dezenas_bandeja)		//unidades e dezenas_bandejas são numeros decimais
);												//em código binario. Usados no display
												//Mais detalhes do funcionamento no arquivo do módulo


dispensador dispensador_1 (						//Módulo para contabilizar a quantidade de rolhas no  
	//Inputs									//dispensador. AD: 1 = Ativar dispensador. Caso hajam
	.ativar				(AD_w) ,				//rolhas no dispensador para serem repostas na bandeja
	.reset				(enable) ,				// e AD = 1, então, reabastecer = 1.

	//Outputs
	.reabastecer		(reabastecer)			//reabastecer é usado como input no módulo da bandeja
);												//Mais detalhes do funcionamento no arquivo do módulo


duzias duzias_1 (								//Módula para contabilizar a quantidade de duzias de 
	//Inputs									//vinhos produzidas. GP é usado como clock para os 
	.clk				(GP) ,					//contadores dentro do módulo.
	.reset				(enable) ,				

	//Outputs
	.unidades_duzias 	(unidades_duzias) ,		//unidades e dezenas_bandejas são numeros decimais
	.dezenas_duzias		(dezenas_duzias)		//em código binario. Usados no display
);												//Mais detalhes do funcionamento no arquivo do módulo

//MULTIPLEXAÇÃO DO DISPLAY

counter #(					
	//Parâmetros
												//Contador para sincronização do acionamento da coluna
	.DATAWIDTH			(2) ,					//e dos segmentos acionados. O contador ao lado possui
	.START				(2'b00) , 				//parametros modificados em relação aos parametros 
	.ENDING				(2'b11) 				//definidos no arquivo do módulo instanciado
) counter_display (
	//Inputs

	.clk 				(clk) ,
	.rst				(enable) ,
		
	//Outputs
	.out				(counter_displayOut)
);

wire [1:0] counter_displayOut;
wire [3:0] display_data_bin , dezenas_duzias , unidades_duzias , dezenas_bandeja , unidades_bandeja;

mux4x1 display_data_mux (						
	//Inputs
												//Mux utilizado para mudar a informação mostrada
	.IN_A				(dezenas_duzias) ,		//no display em sincronia com o acionamento das
	.IN_B				(unidades_duzias) ,		//colunas
	.IN_C				(dezenas_bandeja) ,
	.IN_D				(unidades_bandeja) ,
	.slc				(counter_displayOut) ,	//Seleção feita pelo contador

	//Outputs
	.out				(display_data_bin)
);

display_decoder display_decoder_1 (				
	//Inputs
												//Decodificador do display. Decodifica um número
	.binary_code		(display_data_bin) ,	//decimal, codificado em binario, em um vetor para
	.enable				(enable) ,				//acionar os segmentos que representam aquele número
												//graficamente
	//Outputs
	.digitOut			(display_data)
);

//PERGUNTA: Algum problema em utilizar valores fixos para acionar as colunas?
// mux4x1 display_colune_mux (						
// 	//Inputs									//Mux para sincronizar o acionamento das colunas com
// 	.IN_A				(4'b0111) ,				//a informação mostrada no display.
// 	.IN_B				(4'b1011) ,				//Cada posição no vetor representa uma coluna.
// 	.IN_C				(4'b1101) ,
// 	.IN_D				(4'b1110) ,
// 	.slc				(counter_displayOut) ,	//Seleção feita pelo contador
	
// 	//Outputs
// 	.out				(display_colune)
// );

colune_decoder colune_decoder_1(
	//Inputs
	.code				(counter_displayOut) ,

	//Outputs
	.display_colune		(display_colune)
);

endmodule