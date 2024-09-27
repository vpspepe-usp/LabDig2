module transmissor_ascii_fd (
    input clock,
    input reset,
    input [6:0] dados_ascii [0:7],
    input transmite,
    output fim_transmissao,
    output saida_serial
);

wire [2:0] sel;
wire [6:0] ascii_transmitido;
wire s_fim_transmissao;


mux_8x1_n MUX (
    .D7(dados_ascii[7]),
    .D6(dados_ascii[6]),
    .D5(dados_ascii[5]),
    .D4(dados_ascii[4]),
    .D3(dados_ascii[3]),
    .D2(dados_ascii[2]),
    .D1(dados_ascii[1]),
    .D0(dados_ascii[0]),
    .SEL(sel),
    .MUX_OUT(ascii_transmitido)
);

contador_m #(.M(8), .N(7)) CONTA_SELECT
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