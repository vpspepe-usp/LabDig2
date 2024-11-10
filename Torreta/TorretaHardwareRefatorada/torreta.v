module torreta (
    input   clock,
    input   reset,
    input   ligar,
	input   seletor_hexa,
    input   soma_municao,
    input   fixar,
    input   echo,
    output  trigger,
    output  pwm_base,
    output  pwm_recarga,
    output  saida_serial,
    output  fim_posicao,
    output  ameaca_detectada,
    output  acionar_motor,
    output db_trigger,
    output db_pwm_base,
    output db_saida_serial,
    output db_echo,
    output db_acionar_motor,
    output [6:0] hex_contagem_municao,
    output [6:0] db_estado,
    output [6:0] db_centena,
    output [6:0] db_dezena,
    output [6:0] db_unidade
);

wire [3:0] s_contagem_municao;
wire edge_soma_municao;
wire s_acionar_motor;

//UC -> FD
wire s_girar, s_medir, s_transmitir, s_pronto, s_conta;
wire s_dispara, s_recarrega;
wire s_timeout_medicao;

// FD -> UC
wire s_giro_pronto, s_medida_pronto, s_envio_pronto;
wire s_meio_tempo, s_fim_tempo;
wire s_trigger, s_saida_serial, s_pwm_base, s_pwm_recarga;
wire s_fim_disparo, s_fim_recarga;
wire s_ameaca_detectada;
wire s_torreta_carregada;
wire [3:0] s_db_estado, s_db_centena, s_db_dezena, s_db_unidade;
wire [3:0] s_centena, s_dezena, s_unidade, 
				s_centena_angulo, s_dezena_angulo, s_unidade_angulo;

edge_detector EDGE_MUNICAO (
    .clock(clock),
    .reset(reset),
    .sinal(~soma_municao),
    .pulso(edge_soma_municao)

);

torreta_uc UC (
    .clock(clock),
    .reset(reset),
    .ligar(ligar),
    .fixar(fixar),
    .meio_tempo(s_meio_tempo),
    .fim_tempo(s_fim_tempo),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .ameaca_detectada(s_ameaca_detectada),
    .torreta_carregada(s_contagem_municao > 4'b0),
    .fim_disparo(s_fim_disparo),
    .fim_recarga(s_fim_recarga),
    .girar(s_girar),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .pronto(s_pronto),
    .conta(s_conta),
    .dispara(s_dispara),
    .recarrega(s_recarrega),
    .timeout_medicao(s_timeout_medicao),
    .db_estado(s_db_estado)
);

torreta_fd FD(
    .clock(clock),
    .reset(reset),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .girar(s_girar),
    .echo(echo),
    .conta(s_conta),
    .soma_municao(edge_soma_municao),
    .dispara(s_dispara),
    .recarrega(s_recarrega),
    .timeout_medicao(s_timeout_medicao),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .giro_pronto(s_giro_pronto), 
    .trigger(s_trigger),
    .saida_serial(s_saida_serial),
    .meio_tempo(s_meio_tempo),
    .fim_tempo(s_fim_tempo),
    .pwm_base(s_pwm_base),
    .pwm_recarga(s_pwm_recarga),
    .fim_disparo(s_fim_disparo),
    .fim_recarga(s_fim_recarga),
    .ameaca_detectada(s_ameaca_detectada),
    .acionar_motor(s_acionar_motor),
    .contagem_municao(s_contagem_municao),
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

hexa7seg HEX_MUNICAO (
    .hexa(s_contagem_municao),
    .display(hex_contagem_municao)
);



assign fim_posicao = s_pronto;

assign db_trigger = s_trigger;
assign db_pwm_base = s_pwm_base;
assign db_saida_serial = saida_serial;

assign db_echo = echo;

assign pwm_base = s_pwm_base;
assign pwm_recarga = s_pwm_recarga;
assign saida_serial = s_saida_serial;
assign trigger = s_trigger;

assign ameaca_detectada = s_ameaca_detectada;
assign acionar_motor = ~s_acionar_motor;
assign db_acionar_motor = ~s_acionar_motor;

assign s_db_centena = seletor_hexa ? s_centena_angulo : s_centena;
assign s_db_unidade = seletor_hexa ? s_unidade_angulo : s_unidade;
assign s_db_dezena = seletor_hexa ? s_dezena_angulo : s_dezena;


endmodule