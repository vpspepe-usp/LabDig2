module transmissor_ascii # (parameter N=8) 
    (
        input clock,
        input reset,
        input iniciar,
        input [6:0] dados_ascii [0:N-1],
        output pronto,
        output dado_serial
    );

transmissor_ascii_fd #(.N(N)) FD (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .dados_ascii(dados_ascii),
    .pronto(pronto),
    .dado_serial(dado_serial)
);


transmissor_ascii_uc UC (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .pronto(pronto)
);





endmodule