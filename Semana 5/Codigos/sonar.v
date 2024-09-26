module sonar (
    input   clock,
    input   reset,
    input   ligar,
    input   echo,
    output  trigger,
    output  pwm,
    output  saida_serial,
    output  fim_posicao
);

//UC -> FD
    wire s_girar, s_medir, s_transmitir, s_pronto;

// FD -> UC
    wire s_giro_pronto, s_medida_pronto, s_envio_pronto;

sonar_uc UC(
     .clock(clock),
     .reset(reset),
     .ligar(ligar),
     .giro_pronto(s_giro_pronto),
     .medida_pronto(s_medida_pronto),
     .envio_pronto(s_envio_pronto),
     .girar(s_girar),
     .medir(s_medir),
     .transmitir(s_transmitir),
     .pronto(s_pronto),
     .db_estado()
);

sonar_fd FD (
     .clock(clock),
     .reset(reset),
     .ligar(ligar),
     .giro_pronto(s_giro_pronto),
     .medida_pronto(s_medida_pronto),
     .envio_pronto(s_envio_pronto),
     .girar(s_girar),
     .medir(s_medir),
     .transmitir(s_transmitir),
     .pronto(s_pronto),
     .db_estado()

);




endmodule