module torreta_fd(
    input clock,
    input reset,
    input medir,
    input transmitir,
    input girar,
    input echo,
    input conta,
    input soma_municao,
    input dispara,
    input recarrega,
    input timeout_medicao,
    output medida_pronto,
    output envio_pronto,
    output giro_pronto, 
    output trigger,
    output saida_serial,
    output meio_tempo,
    output fim_tempo,
    output pwm_base,
    output pwm_recarga,
    output fim_disparo,
    output fim_recarga,
    output ameaca_detectada,
    output acionar_motor, // 1 se motor FlyWheel deve ser acionado
    output [3:0] contagem_municao,
    output [3:0] unidade,
    output [3:0] dezena,
    output [3:0] centena,
	output [3:0] unidade_angulo,
    output [3:0] dezena_angulo,
    output [3:0] centena_angulo
);

    parameter [11:0] DISTANCIA_AMEACA = {4'b0000, 4'b0001, 4'b0000}; // 10cm
    wire [11:0] s_medida;
    wire s_trigger, s_medida_pronto, s_envio_pronto, s_giro_pronto;
    wire s_ameaca_detectada, reg_ameaca_detectada;
    wire s_fim_disparo, s_fim_recarga;
    wire [3:0] s_contagem_municao;
    wire [1:0] seletor_mux;
    wire [6:0] s_unidade, s_dezena, s_centena;
    wire [6:0] s_unidade_angulo, s_dezena_angulo, s_centena_angulo;
    wire [4:0] s_posicao;
    wire [23:0] s_saida_rom;

// Registrador de Ameaça
registrador REG_AMEACA (
    .clock(clock),
    .clear(reset),
    .enable(transmitir),
    .D(s_ameaca_detectada),
    .Q(ameaca_detectada)
);

// Contador soma sub de munição
contador_soma_sub_m CONT_MUNICAO (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .soma(soma_municao),
    .sub(s_fim_disparo),
    .Q(s_contagem_municao),
    .fim(),
    .meio()
);


// Circuito de interface com sensor
interface_hcsr04 INT (
    .clock    (clock    ),
    .reset    (reset || timeout_medicao),
    .medir    (medir    ),
    .echo     (echo     ),
    .trigger  (s_trigger),
    .medida   (s_medida ),
    .pronto   (s_medida_pronto  ),
    .db_estado()
);

controle_servo_5 SERVO (
        .clock(clock),
        .reset(reset),
        .posicao(s_posicao),
        .controle(pwm_base),
        .db_reset(),
        .db_posicao(),
        .db_controle()
);

contadorg_updown_m # (
.M(29),  
.N(5)
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
    .M(20_000_000),
    .N(27)
) CONT_400_MS (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(conta),
    .Q(),
    .fim(fim_tempo),
    .meio(meio_tempo)
);
servo_recarga SERVO_RECARGA (
    .clock(clock),
    .reset(reset),
    .recarregar(dispara),
    .pwm(pwm_recarga),
    .fim_recarga(s_fim_recarga)
);

contador_m # (
    .M(50_000_000),
    .N(27)
) CONT_1_S_DISPARO (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(dispara),
    .Q(),
    .fim(s_fim_disparo),
    .meio()
);

// contador_m # (
//     .M(50_000_000),
//     .N(27)
// ) CONT_1_S_RECARGA (
//     .clock(clock),
//     .zera_as(1'b0),
//     .zera_s(reset),
//     .conta(recarrega),
//     .Q(),
//     .fim(s_fim_recarga),
//     .meio()
// );

rom_angulos_29x24 ROM(
    .endereco(s_posicao), 
    .saida(s_saida_rom)
);

transmissor_ascii TRANS_ASCII (
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

assign s_unidade = {3'b011, s_medida[3:0]}; //unidade
assign s_dezena = {3'b011, s_medida[7:4]};//dezena
assign s_centena = {3'b011, s_medida[11:8]};//centena
assign trigger = s_trigger;
assign medida_pronto = s_medida_pronto;
assign envio_pronto = s_envio_pronto;

assign contagem_municao = s_contagem_municao;
assign unidade = s_unidade[3:0];
assign dezena = s_dezena[3:0];
assign centena = s_centena[3:0];

assign unidade_angulo = s_unidade_angulo[3:0];
assign dezena_angulo = s_dezena_angulo[3:0];
assign centena_angulo = s_centena_angulo[3:0];

//303230 -> 30|32|30 em ASCII = 0(011)(0000)|0(011)(0010)|0(011)(0000) 
//por isso ignora o bit fora do parenteses

assign s_unidade_angulo = {s_saida_rom[6:0]};
assign s_dezena_angulo = {s_saida_rom[14:8]};
assign s_centena_angulo = {s_saida_rom[22:16]};

assign s_ameaca_detectada = {s_centena[3:0] ,s_dezena[3:0], s_unidade[3:0]} < DISTANCIA_AMEACA;
assign fim_disparo = s_fim_disparo;
assign fim_recarga = s_fim_recarga;
assign acionar_motor = dispara || recarrega;

endmodule
