module sonar_uc(
    input clock,
    input reset,
    input ligar,
    input meio_tempo,
    input fim_tempo,
    input medida_pronto,
    input envio_pronto,
    output reg girar,
    output reg medir,
    output reg transmitir,
    output reg pronto,
    output reg conta,
    output reg [3:0] db_estado
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; // 3 bits são suficientes para 7 estados

    // Parâmetros para os estados
        parameter inicial                             = 4'b0000;//0
        parameter faz_rotacao                         = 4'b0001;//1
        parameter aguarda_meio_tempo                  = 4'b0010;//2
        parameter faz_medida                          = 4'b0011;//3
        parameter aguarda_medida                      = 4'b0100;//4
        parameter faz_transmissao                     = 4'b0101;//5
        parameter aguarda_transmissao                 = 4'b0110;//6
        parameter aguarda_tempo                       = 4'b0111;//7
        parameter fim                                 = 4'b1111;//F

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

            inicial:                           Eprox = ligar ? aguarda_meio_tempo : inicial;
            aguarda_meio_tempo:                Eprox = meio_tempo ? faz_medida : aguarda_meio_tempo;
            faz_medida:                        Eprox = aguarda_medida;
            aguarda_medida:                    Eprox = medida_pronto ? faz_transmissao : aguarda_medida;
            faz_transmissao:                   Eprox = aguarda_transmissao;
            aguarda_transmissao:               Eprox = envio_pronto ? aguarda_tempo : aguarda_transmissao;
            aguarda_tempo:                     Eprox = fim_tempo ? faz_rotacao : aguarda_tempo;
            faz_rotacao:                       Eprox = fim;
            fim:                               Eprox = inicial;
            default:                           Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
          medir          = (Eatual == faz_medida) ? 1'b1 : 1'b0;
		  girar          = (Eatual == faz_rotacao) ? 1'b1 : 1'b0;
          transmitir     = (Eatual == faz_transmissao) ? 1'b1 : 1'b0;
		  pronto = (Eatual == fim)  ? 1'b1 : 1'b0;
          conta = (Eatual == aguarda_tempo ||
                    Eatual == aguarda_medida ||
                    Eatual == aguarda_transmissao ||
                    Eatual == faz_medida ||
                    Eatual == faz_rotacao ||
                    Eatual == faz_transmissao ||
                    Eatual == aguarda_meio_tempo) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:                            db_estado = 4'b0000;//0
            faz_rotacao:                        db_estado = 4'b0001;//1
            faz_medida:                         db_estado = 4'b0010;//2
            aguarda_meio_tempo:                 db_estado = 4'b0010;//2
            faz_medida:                         db_estado = 4'b0011;//3
            aguarda_medida:                     db_estado = 4'b0100;//4
            faz_transmissao:                    db_estado = 4'b0101;//5
            aguarda_transmissao:                db_estado = 4'b0110;//6
            aguarda_tempo:                      db_estado = 4'b0111;//7
            fim:                                db_estado = 4'b1111;//F
            default:                            db_estado = 4'b0000;//0
        endcase
    end

endmodule