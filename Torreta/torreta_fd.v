module torreta_fd #(parameter M_MUNICAO = 16,
                    parameter N_MUNICAO = 4)(
    input clock,
    input reset,
    input conta_municao,
    input medir,
    input transmitir,
    input girar,
    input echo,
    input conta_tempo,
    input armar_disparo,
    input disparar,
    input recarregar_disparo,
    output medida_pronto,
    output envio_pronto,
    output trigger,
    output saida_serial,
    output meio_tempo,
    output fim_tempo,
    output pwm,
    output ameaca_detectada,
    output disparo_carregado,
    output municao_carregada,
    output disparo_pronto,
    output fim_disparo,
    output [N_MUNICAO-1:0] contagem_municao,
    output [3:0] unidade,
    output [3:0] dezena,
    output [3:0] centena,
    output [3:0] unidade_angulo,
    output [3:0] dezena_angulo,
    output [3:0] centena_angulo
);
    parameter distancia_max_ameaca = {4'b0000,4'b0101,4'b0000}; // 50 cm

    wire [11:0] s_medida;
    wire s_trigger, s_medida_pronto, s_envio_pronto;
    wire edge_conta_municao;
    wire [1:0] seletor_mux;
    wire [6:0] s_unidade, s_dezena, s_centena;
    wire [6:0] s_unidade_angulo, s_dezena_angulo, s_centena_angulo;
    wire [4:0] s_posicao;
    wire [23:0] s_saida_rom;
    wire [N_MUNICAO-1:0] s_municao;
    wire s_fim_disparo, s_fim_recarga_disparo, s_fim_preparacao_disparo;


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

// Circuito do servo da base da Torreta
controle_servo_5 SERVO_BASE (
        .clock(clock),
        .reset(reset),
        .posicao(s_posicao),
        .controle(pwm),
        .db_reset(),
        .db_posicao(),
        .db_controle()
);

contadorg_updown_m # (
.M(29), // 29 posições
.N(5)  // 5 bits para representar 29
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
    .M(357_142), // TEMPO ENTRE ROTAÇÕES: Varredura de 140 graus, de 5 em
             // 5 graus, em 3 segundos:
             // 3/(140/5) = 107,143 ms (5.357.142 ciclos de clock)
    .N(23)   // 23 bits para representar 5_357_142
) CONT_TEMPO (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(conta_tempo),
    .Q(),
    .fim(fim_tempo),
    .meio(meio_tempo)
);

edge_detector EDGE_SOMA_MUNICAO (
    .clock(clock),
    .reset(reset),
    .sinal(conta_municao),
    .pulso(edge_conta_municao)
);

contador_soma_sub_m # (
    .M(M_MUNICAO), // Maximo de M munições
    .N(N_MUNICAO)  // N bits para representar M
) CONT_MUNICAO (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .soma(edge_conta_municao),
    .sub(s_fim_disparo),
    .Q(contagem_municao),
    .fim(),
    .meio()
);

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

contador_m # (
    .M(200_000), // SIMULAR TEMPO DE PREPARACAO: 0,20 ms
    .N(21)   // 21 bits para representar 2_000_000
) CONT_DUMMY_PREPARA (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(armar_disparo),
    .Q(),
    .fim(s_fim_preparacao_disparo),
    .meio()
);

contador_m # (
    .M(200_000), // SIMULAR TEMPO DE DISPARO: 0,20 ms
    .N(21)   // 21 bits para representar 2_000_000
) CONT_DUMMY_DISPARO (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(disparar),
    .Q(),
    .fim(s_fim_disparo),
    .meio()
);

contador_m # (
    .M(200_000), // SIMULAR TEMPO DE RECARGA: 0,20 ms
    .N(21)   // 21 bits para representar 2_000_000
) CONT_DUMMY_RECARGA (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(reset),
    .conta(recarregar_disparo),
    .Q(),
    .fim(s_fim_recarga_disparo),
    .meio()
);

registrador_m_we REG_WE_AMEACA (
    .clock(clock),
    .reset(reset),
    .we(s_medida_pronto),
    .D(s_ameaca_detectada),
    .Q(ameaca_detectada)
);



assign s_unidade = {3'b011, s_medida[3:0]}; //unidade
assign s_dezena = {3'b011, s_medida[7:4]};  //dezena
assign s_centena = {3'b011, s_medida[11:8]};//centena
assign trigger = s_trigger;
assign medida_pronto = s_medida_pronto;
assign envio_pronto = s_envio_pronto;

assign unidade = s_unidade;
assign dezena = s_dezena;
assign centena = s_centena;

//303230 -> 30|32|30 em ASCII = 0(011)(0000)|0(011)(0010)|0(011)(0000) 
//por isso ignora o bit fora do parenteses

assign s_unidade_angulo = {s_saida_rom[6:0]};
assign s_dezena_angulo = {s_saida_rom[14:8]};
assign s_centena_angulo = {s_saida_rom[22:16]};

assign unidade_angulo = s_unidade_angulo;
assign dezena_angulo = s_dezena_angulo;
assign centena_angulo = s_centena_angulo;

// Ameaca
assign s_ameaca_detectada = s_medida < distancia_max_ameaca;

// Disparo
assign municao_carregada = contagem_municao > 0;
assign disparo_carregado = s_fim_recarga_disparo;
assign disparo_pronto = s_fim_preparacao_disparo;
assign fim_disparo = s_fim_disparo;

endmodule