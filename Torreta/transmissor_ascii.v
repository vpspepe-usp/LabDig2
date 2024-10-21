module transmissor_ascii
    (
        input clock,
        input reset,
        input iniciar,
        input [6:0] centena_angulo,
        input [6:0] dezena_angulo,
        input [6:0] unidade_angulo,
        input [6:0] caractere_final_angulo,
        input [6:0] centena_distancia,
        input [6:0] dezena_distancia,
        input [6:0] unidade_distancia,
        input [6:0] caractere_final_distancia,
        output pronto,
        output dado_serial
    );
	 
wire s_transmite, s_fim_transmissao;

transmissor_ascii_fd FD (
    .clock(clock),
    .reset(reset),
    .centena_angulo(centena_angulo),
    .dezena_angulo(dezena_angulo),
    .unidade_angulo(unidade_angulo),
    .caractere_final_angulo(caractere_final_angulo),
    .centena_distancia(centena_distancia),
    .dezena_distancia(dezena_distancia),
    .unidade_distancia(unidade_distancia),
    .caractere_final_distancia(caractere_final_distancia),
	 .transmite(s_transmite),
    .fim_transmissao(s_fim_transmissao),
    .saida_serial(dado_serial)
	 );


transmissor_ascii_uc UC (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
	 .fim_transmissao(s_fim_transmissao),
	 .transmite(s_transmite),
    .pronto(pronto)
);


endmodule