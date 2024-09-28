module sonar_fd(
    input clock,
    input reset,
    input medir,
    input transmitir,
    input girar,
    input echo,
    input conta,
    output medida_pronto,
    output envio_pronto,
    output giro_pronto, 
    output trigger,
    output saida_serial,
    output meio_tempo,
    output fim_tempo,
    output pwm,
    output [3:0] unidade,
    output [3:0] dezena,
    output [3:0] centena
);

    wire [11:0] s_medida;
    wire s_trigger, s_medida_pronto, s_envio_pronto, s_giro_pronto;
    wire [1:0] seletor_mux;
    wire [6:0] dados_ascii, s_unidade, s_dezena, s_centena;
    wire [6:0] s_unidade_angulo, s_dezena_angulo, s_centena_angulo;
    wire [2:0] s_posicao;
    wire [23:0] s_saida_rom;


// Circuito de interface com sensor
interface_hcsr04 INT (
    .clock    (clock    ),
    .reset    (reset    ),
    .medir    (medir    ),
    .echo     (echo     ),
    .trigger  (s_trigger),
    .medida   (s_medida ),
    .pronto   (s_medida_pronto  ),
    .db_estado()
);

controle_servo_3 SERVO (
        .clock(clock),
        .reset(reset),
        .posicao(s_posicao),
        .controle(pwm),
        .db_reset(),
        .db_posicao(),
        .db_controle()
);

contadorg_updown_m # (
.M(50),  
.N(6)
) CONT_UP_DOWN (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(girar),
    .Q(s_posicao),
    .inicio(),
    .fim(),
    .meio(),
    .direcao()
);

contador_m # (
    .M(100_000_000),
    .N(27)
) CONT_2_S (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(conta),
    .Q(),
    .fim(fim_tempo),
    .meio(meio_tempo)
);

rom_angulos_8x24 ROM(
    .endereco(s_posicao), 
    .saida(s_saida_rom)
);

transmissor_ascii # (
    .N()
) TRANS_ASCII (
    .clock(clock),
    .reset(reset),
    .iniciar(transmitir),
    .centena_angulo(s_centena_angulo),
    .dezena_angulo(s_dezena_angulo),
    .unidade_angulo(s_unidade_angulo),
    .caractere_final_angulo(7'b0101100), // ,
    .centena_distancia(s_centena),
    .dezena_distancia(s_dezena),
    .unidade_distancia(s_unidade),
    .caractere_final_distancia(7'b0100011), // #
    .pronto(s_envio_pronto),
    .dado_serial(saida_serial)
);

contador_m # (
    .M(4),
    .N(2)
) CONT_CHAR (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(s_envio_pronto),
    .Q(seletor_mux),
    .fim(),
    .meio()
);

assign s_unidade = {3'b011, s_medida[3:0]}; //unidade
assign s_dezena = {3'b011, s_medida[7:4]};//dezena
assign s_centena = {3'b011, s_medida[11:8]};//centena
assign trigger = s_trigger;
assign medida_pronto = s_medida_pronto;
assign envio_pronto = s_envio_pronto;

assign unidade = s_unidade;
assign dezena = s_dezena;
assign centena = s_centena;

//303230 -> 30|32|30 em ASCII = 0(011)(0000)|0(011)(0010)|0(011)(0000) 
//por isso ignora o bit fora do parenteses

assign s_unidade_angulo = {s_saida_rom[6:0]}
assign s_dezena_angulo = {s_saida_rom[14:8]}
assign s_centena_angulo = {s_saida_rom[22:16]}

endmodule
