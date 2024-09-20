module exp4_trena (
    input clock,
    input reset,
    input mensurar,
    input echo,
    output trigger,
    output saida_serial,
    output [6:0] medida0,
    output [6:0] medida1,
    output [6:0] medida2,
    output pronto,
    output [6:0] db_estado,
);

wire s_medida_pronto, s_envio_pronto;
wire s_medir, s_transmitir;
wire [3:0] unidade, dezena, centena, s_db_estado;

trena_digital_fd FD (
    .clock(clock),
    .reset(reset),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .echo(echo),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .trigger(trigger),
    .saida_serial(saida_serial),
    .unidade(unidade),
    .dezena(dezena),
    .centena(centena),
);

trena_digital_uc UC(
    .clock(clock),
    .mensurar(mensurar),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .pronto(pronto),
    .db_estado(s_db_estado)
);

hexa7seg HEX_UNIDADE (
    .entrada(s_unidade),
    .saida(medida0)
);

hexa7seg HEX_DEZENA (
    .entrada(s_dezena),
    .saida(medida1)
);

hexa7seg HEX_CENTENA (
    .entrada(s_centena),
    .saida(medida2)
);

hexa7seg HEX_DB_ESTADO(
    .entrada(s_db_estado),
    .saida(db_estado)
);



endmodule