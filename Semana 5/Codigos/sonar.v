module sonar (
    input   clock,
    input   reset,
    input   ligar,
    input   echo,
    output  trigger,
    output  pwm,
    output  saida_serial,
    output  fim_posicao,
    output db_trigger,
    output db_pwm,
    output db_saida_serial,
    output db_echo
);

//UC -> FD
wire s_girar, s_medir, s_transmitir, s_pronto, s_conta;

// FD -> UC
wire s_giro_pronto, s_medida_pronto, s_envio_pronto;
wire s_meio_tempo, s_fim_tempo;
wire s_trigger, s_saida_serial, s_pwm;

sonar_uc UC (
    .clock(clock),
    .reset(reset),
    .ligar(ligar),
    .meio_tempo(s_meio_tempo),
    .fim_tempo(s_fim_tempo),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .girar(s_girar),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .pronto(s_pronto),
    .conta(s_conta),
    .db_estado()
);

sonar_fd FD(
     .clock(clock),
     .reset(reset),
     .medir(s_medir),
     .transmitir(s_transmitir),
     .girar(s_girar),
     .echo(echo),
     .conta(s_conta),
     .medida_pronto(s_medida_pronto),
     .envio_pronto(s_envio_pronto),
     .giro_pronto(s_giro_pronto), 
     .trigger(s_trigger),
     .saida_serial(s_saida_serial),
     .meio_tempo(s_meio_tempo),
     .fim_tempo(s_fim_tempo),
     .pwm(s_pwm),
     .unidade(),
     .dezena(),
     .centena()
);

assign fim_posicao = s_pronto;

assign db_trigger = s_trigger;
assign db_pwm = s_pwm;
assign db_saida_serial = saida_serial;

assign db_echo = echo;

assign pwm = s_pwm;
assign saida_serial = s_saida_serial;
assign trigger = s_trigger;

endmodule