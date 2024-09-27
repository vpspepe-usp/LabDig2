module trena_digital_fd(
     .clock,
    input reset,
    input medir,
    input transmitir,
    input girar,
    input echo,
    output medida_pronto,
    output envio_pronto,
    output giro_pronto, 
    output trigger,
    output saida_serial,
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
         .controle(),
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

rom_angulos_8x24 ROM(
    .endereco(s_posicao), 
    .saida(s_saida_rom)
);

    // tx_serial_7O1 SER(
    //     .clock(clock),
    //     .reset(reset),
    //     .partida(transmitir),
    //     .dados_ascii(dados_ascii),
    //     .saida_serial(saida_serial),
    //     .pronto(s_envio_pronto),
    //     .db_clock(),
    //     .db_tick(),
    //     .db_partida(),
    //     .db_saida_serial(),
    //     .db_estado()
    // );

    // // MUX que seleciona o dado de saída
    // mux_4x1_n SEL_CHAR (
    //     .D3(7'b0100011), // # (23 em Hexa)
    //     .D2(s_unidade), //3Unidade
    //     .D1(s_dezena), //3Dezena
    //     .D0(s_centena), //3Centena
    //     .SEL(seletor_mux),
    //     .MUX_OUT(dados_ascii)
    // );

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
