module servo_recarga (
    input clock,
    input reset,
    input recarregar,
    output pwm,
    output fim_recarga
);

wire contar;
wire s_fim_recarga;

servo_recarga_fd FD (
    .clock(clock),
    .reset(reset),
    .contar(contar),
    .pwm(pwm),
    .fim_recarga(s_fim_recarga)
);

servo_recarga_uc UC (
    .clock(clock),
    .reset(reset),
    .iniciar(recarregar),
    .fim_recarga(s_fim_recarga),
    .contar(contar),
    .fim(fim_recarga),
    .db_estado()
);

endmodule