module transmissor_ascii_fd (
    input clock,
    input reset,
    input [6:0] centena_angulo,
    input [6:0] dezena_angulo,
    input [6:0] unidade_angulo,
    input [6:0] caractere_final_angulo,
    input [6:0] centena_distancia,
    input [6:0] dezena_distancia,
    input [6:0] unidade_distancia,
    input [6:0] caractere_final_distancia,
    input transmite,
    output fim_transmissao,
    output saida_serial
);

wire [2:0] sel;
wire [6:0] ascii_transmitido;
wire s_fim_transmissao;


mux_8x1_n MUX (
    .D0(centena_angulo),
    .D1(dezena_angulo),
    .D2(unidade_angulo),
    .D3(caractere_final_angulo),
    .D4(centena_distancia),
    .D5(dezena_distancia),
    .D6(unidade_distancia),
    .D7(caractere_final_distancia),
    .SEL(sel),
    .MUX_OUT(ascii_transmitido)
);

contador_m #(.M(8), .N(3)) CONTA_SELECT
  (
    .clock(clock),
    .zera_as(),
    .zera_s(reset),
    .conta(s_fim_transmissao),
    .Q(sel),
    .fim(),
    .meio()
);

tx_serial_7O1 SERIAL (
    .clock(clock),
    .reset(reset),
    .partida(transmite),
    .dados_ascii(ascii_transmitido),
    .saida_serial(saida_serial),
    .pronto(s_fim_transmissao),
    .db_partida(),
    .db_saida_serial(),
    .db_estado()
);

assign fim_transmissao = s_fim_transmissao;

endmodule