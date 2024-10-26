module torreta_uc(
    input clock,
    input reset,
    input ligar,
    input meio_tempo,
    input fim_tempo,
    input medida_pronto,
    input ameaca_detectada,
    input envio_pronto,
    input disparo_carregado,
    input municao_carregada,
    input disparo_pronto,
    input fim_disparo,
    output reg girar,
    output reg medir,
    output reg transmitir,
    output reg pronto,
    output reg conta_tempo,
    output reg armar_disparo,
    output reg disparar,
    output reg recarregar_disparo,
    output reg [3:0] db_estado
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; // 3 bits são suficientes para 7 estados

    // Parâmetros para os estados
        parameter inicial                             = 4'b0000;//0
        parameter aguarda_recarga_municao             = 4'b0001;//1
        parameter faz_rotacao                         = 4'b0010;//2
        parameter aguarda_meio_tempo                  = 4'b0011;//3
        parameter faz_medida                          = 4'b0100;//4
        parameter aguarda_medida                      = 4'b0101;//5
        parameter faz_transmissao                     = 4'b0110;//6
        parameter aguarda_transmissao                 = 4'b0111;//7
        parameter prepara_disparo                     = 4'b1000;//8
        parameter efetua_disparo                      = 4'b1001;//9
        parameter recarrega_disparo                   = 4'b1010;//A
        parameter aguarda_recarga_disparo             = 4'b1101;//D
        parameter aguarda_tempo                       = 4'b1011;//B
        parameter fim                                 = 4'b1100;//C

    // Estado
    always @(posedge clock, posedge reset, negedge ligar) begin
        if (reset || !ligar)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)

            inicial:                           Eprox = ligar ? aguarda_recarga_municao : inicial;
            aguarda_recarga_municao:           Eprox = municao_carregada ? faz_medida : aguarda_recarga_municao;
            //aguarda_meio_tempo:                Eprox = meio_tempo ? faz_medida : aguarda_meio_tempo;
            faz_medida:                        Eprox = aguarda_medida;
            aguarda_medida:                    Eprox = medida_pronto ? faz_transmissao : aguarda_medida;
            faz_transmissao:                   Eprox = aguarda_transmissao;
            aguarda_transmissao:               Eprox = envio_pronto ? 
                                                            (ameaca_detectada ? prepara_disparo : aguarda_tempo) : aguarda_transmissao;
            prepara_disparo:                  Eprox = disparo_pronto ? efetua_disparo : prepara_disparo;
            efetua_disparo:                   Eprox = fim_disparo ? recarrega_disparo : efetua_disparo;
            recarrega_disparo:                Eprox = aguarda_recarga_disparo;
            aguarda_recarga_disparo:          Eprox = disparo_carregado ? aguarda_tempo : aguarda_recarga_disparo;
            aguarda_tempo:                    Eprox = fim_tempo ? faz_rotacao : aguarda_tempo;
            faz_rotacao:                      Eprox = fim;
            fim:                              Eprox = inicial;
            default:                          Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        medir          = (Eatual == faz_medida) ? 1'b1 : 1'b0;
        girar          = (Eatual == faz_rotacao) ? 1'b1 : 1'b0;
        transmitir     = (Eatual == faz_transmissao) ? 1'b1 : 1'b0;
        pronto = (Eatual == fim)  ? 1'b1 : 1'b0;
        conta_tempo =  (Eatual == aguarda_tempo ||
                Eatual == aguarda_medida ||
                Eatual == aguarda_transmissao ||
                Eatual == faz_medida ||
                Eatual == faz_rotacao ||
                Eatual == faz_transmissao ||
                Eatual == aguarda_meio_tempo) ? 1'b1 : 1'b0;
        
        armar_disparo = (Eatual == prepara_disparo) ? 1'b1 : 1'b0;
        disparar = (Eatual == efetua_disparo) ? 1'b1 : 1'b0;
        recarregar_disparo = (Eatual == recarrega_disparo ||
                            Eatual == aguarda_recarga_disparo) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:                            db_estado = 4'b0000;//0
            aguarda_recarga_municao:            db_estado = 4'b0001;//1
            faz_rotacao:                        db_estado = 4'b0010;//2
            aguarda_meio_tempo:                 db_estado = 4'b0011;//3
            faz_medida:                         db_estado = 4'b0100;//4
            aguarda_medida:                     db_estado = 4'b0101;//5
            faz_transmissao:                    db_estado = 4'b0110;//6
            aguarda_transmissao:                db_estado = 4'b0111;//7
            prepara_disparo:                    db_estado = 4'b1000;//8
            efetua_disparo:                     db_estado = 4'b1001;//9
            recarrega_disparo:                  db_estado = 4'b1010;//A
            aguarda_recarga_disparo:            db_estado = 4'b1101;//D
            aguarda_tempo:                      db_estado = 4'b1011;//B
            fim:                                db_estado = 4'b1100;//C
        endcase
    end

endmodule