module servo_recarga_fd (
    input clock,
    input reset,
    input contar,
    output pwm,
    output fim_recarga
);

wire [2:0] s_posicao;


contador_m #(
    .N(25),
    .M(25_000_000)  // 25_000_000 = 0,5 s
                    // 2_000_000 no testbench = 40 ms 
    ) TEMPO_RECARGA (
    .clock(clock),
    .zera_as(),
    .zera_s(reset),
    .conta(contar),
    .Q(),
    .fim(fim_recarga),
    .meio()
);

controle_servo_3 CONTROLE_SERVO_RECARGA(
    .clock(clock),
    .reset(reset),
    .posicao(s_posicao),
    .controle(pwm),
    .db_reset(),
    .db_posicao(),
    .db_controle()
);

assign s_posicao = contar ? 3'b111 : 3'b000;

endmodule