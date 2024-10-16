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
	 output db_mensurar,
	 output db_saida_serial,
	 output db_trigger,
	 output db_echo
);

wire s_medida_pronto, s_envio_pronto;
wire s_medir, s_transmitir;
wire [3:0] unidade, dezena, centena, s_db_estado;
wire s_saida_serial, s_trigger;

trena_digital_fd FD (
    .clock(clock),
    .reset(reset),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .echo(echo),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .trigger(s_trigger),
    .saida_serial(s_saida_serial),
    .unidade(unidade),
    .dezena(dezena),
    .centena(centena)
);

trena_digital_uc UC(
    .clock(clock),
    .reset(reset),
    .mensurar(mensurar),
    .medida_pronto(s_medida_pronto),
    .envio_pronto(s_envio_pronto),
    .medir(s_medir),
    .transmitir(s_transmitir),
    .pronto(pronto),
    .db_estado(s_db_estado)
);

hexa7seg HEX_UNIDADE (
    .hexa(unidade),
    .display(medida0)
);

hexa7seg HEX_DEZENA (
    .hexa(dezena),
    .display(medida1)
);

hexa7seg HEX_CENTENA (
    .hexa(centena),
    .display(medida2)
);

hexa7seg HEX_DB_ESTADO(
    .hexa(s_db_estado),
    .display(db_estado)
);

assign db_mensurar = mensurar;

assign db_saida_serial = s_saida_serial;
assign saida_serial = s_saida_serial;

assign db_trigger = s_trigger;
assign trigger = s_trigger;

assign db_echo = echo;




endmodule