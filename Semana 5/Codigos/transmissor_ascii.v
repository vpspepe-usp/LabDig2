module transmissor_ascii
    (
        input clock,
        input reset,
        input iniciar,
        input [7:0][6:0] dados_ascii ,
        output pronto,
        output saida_serial
    );

transmissor_ascii_fd FD (
    .clock(clock),
    .reset(reset),
    .dados_ascii(dados_ascii[0:7]),
    .pronto(pronto),
    .saida_serial(saida_serial)
);


transmissor_ascii_uc UC (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .pronto(pronto)
);





endmodule