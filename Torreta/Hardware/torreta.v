module torreta (
    input   clock,
    input   reset,
    input   ligar,
    input   echo,
    input   conta_municao,
    input   seletor_hexa,
    output  trigger,
    output  pwm_base,
    output  pwm_recarga,
    output  saida_serial,
    output  fim_posicao,
    output  ameaca_detectada,
    output db_trigger,
    output db_pwm_base,
    output db_saida_serial,
    output db_echo,
    output [6:0] db_estado,
    output [6:0] db_centena,
    output [6:0] db_dezena,
    output [6:0] db_unidade,
    output [6:0] hex_contagem_municao
);

parameter N_MUNICAO = 4;
parameter M_MUNICAO = 16;

//UC -> FD
wire s_girar, s_medir, s_transmitir, s_pronto, s_conta_tempo;
wire s_armar_disparo, s_disparar, s_recarregar_disparo;
// FD -> UC
wire s_medida_pronto, s_envio_pronto;
wire s_meio_tempo, s_fim_tempo;
wire s_trigger, s_saida_serial, s_pwm_base, s_pwm_recarga;
wire s_ameaca_detectada, s_disparo_carregado, s_municao_carregada, s_disparo_pronto, s_fim_disparo;


wire [3:0] s_db_estado, s_db_centena, s_db_dezena, s_db_unidade;
wire [3:0] s_centena, s_dezena, s_unidade, 
			s_centena_angulo, s_dezena_angulo, s_unidade_angulo;
wire [N_MUNICAO-1:0] contagem_municao;


torreta_uc UC (
    .clock(clock),
    .reset(reset),
    .ligar(ligar),
    // FD -> UC
    .meio_tempo(s_meio_tempo),
    .fim_tempo(s_fim_tempo),
    .medida_pronto(s_medida_pronto),
    .ameaca_detectada(s_ameaca_detectada),
    .envio_pronto(s_envio_pronto),
    .disparo_carregado(s_disparo_carregado),
    .municao_carregada(s_municao_carregada),
    .disparo_pronto(s_disparo_pronto),
    .fim_disparo(s_fim_disparo),
    // UC -> FD
    .girar(s_girar),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .pronto(s_pronto),
    .conta_tempo(s_conta_tempo),
    .armar_disparo(s_armar_disparo),
    .disparar(s_disparar),
    .recarregar_disparo(s_recarregar_disparo),
    .db_estado(s_db_estado)
);

torreta_fd #(
    .M_MUNICAO(M_MUNICAO),
    .N_MUNICAO(N_MUNICAO)
) FD(
    .clock(clock),
    .reset(reset),
    .conta_municao(conta_municao),
    // UC -> FD
    .medir(s_medir),
    .transmitir(s_transmitir),
    .girar(s_girar),
    .echo(echo),
    .conta_tempo(s_conta_tempo),
    .armar_disparo(s_armar_disparo),
    .disparar(s_disparar),
    .recarregar_disparo(s_recarregar_disparo),
    // FD -> UC
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .trigger(s_trigger),
    .saida_serial(s_saida_serial),
    .meio_tempo(s_meio_tempo),
    .fim_tempo(s_fim_tempo),
    .pwm_base(s_pwm_base),
    .pwm_recarga(s_pwm_recarga),
    .ameaca_detectada(s_ameaca_detectada),
    .disparo_carregado(s_disparo_carregado),
    .municao_carregada(s_municao_carregada),
    .disparo_pronto(s_disparo_pronto),
    .fim_disparo(s_fim_disparo),
    .contagem_municao(contagem_municao),
    .unidade(s_unidade),
    .dezena(s_dezena),
    .centena(s_centena),
    .unidade_angulo(s_unidade_angulo),
    .dezena_angulo(s_dezena_angulo),
    .centena_angulo(s_centena_angulo)
);


hexa7seg HEX_ESTADO (
	.hexa(s_db_estado),
	.display(db_estado)
);

hexa7seg HEX_CENTENA (
	.hexa(s_db_centena),
	.display(db_centena)
);

hexa7seg HEX_DEZENA (
	.hexa(s_db_dezena),
	.display(db_dezena)
);

hexa7seg HEX_UNIDADE (
	.hexa(s_db_unidade),
	.display(db_unidade)
);

hexa7seg HEX_CONT_MUNICAO (
    .hexa(contagem_municao),
    .display(hex_contagem_municao)
);

assign fim_posicao = s_pronto;

// Sensores e Serial
assign trigger = s_trigger;
assign db_trigger = s_trigger;

assign pwm_base = s_pwm_base;
assign db_pwm_base = s_pwm_base;

assign saida_serial = s_saida_serial;
assign db_saida_serial = saida_serial;

assign db_echo = echo;

// Ameaca
assign ameaca_detectada = s_ameaca_detectada;


// Debug
assign s_db_centena = seletor_hexa ? s_centena_angulo : s_centena;
assign s_db_unidade = seletor_hexa ? s_unidade_angulo : s_unidade;
assign s_db_dezena = seletor_hexa ? s_dezena_angulo : s_dezena; 

endmodule