module sonar_uc(
    input clock,
    input reset,
    input ligar,
    input giro_pronto,
    input medida_pronto,
    input envio_pronto,
    output reg girar,
    output reg medir,
    output reg transmitir,
    output reg pronto,
    output reg [3:0] db_estado
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; // 3 bits são suficientes para 7 estados

    // Parâmetros para os estados
        parameter inicial =                            db_estado = 4'b0000;//0
        parameter faz_rotacao =                        db_estado = 4'b0001;//1
        parameter aguarda_rotacao =                    db_estado = 4'b0010;//2
        parameter faz_medida =                         db_estado = 4'b0011;//3
        parameter aguarda_medida =                     db_estado = 4'b0100;//4
        parameter faz_transmissao =                    db_estado = 4'b0101;//5
        parameter aguarda_transmissao =                db_estado = 4'b0110;//6
        parameter fim =                                db_estado = 4'b1111;//F

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

            inicial:                           Eprox = ligar ? faz_medida : inicial;
            faz_rotacao:                       Eprox = aguarda_rotacao;
            aguarda_rotacao:                   Eprox = giro_pronto ? faz_medida : aguarda_rotacao;
            faz_medida:                        Eprox = aguarda_medida;
            aguarda_medida:                    Eprox = medida_pronto ? faz_transmissao : aguarda_medida;
            faz_transmissao:                   Eprox = aguarda_transmissao;
            aguarda_transmissao:               Eprox = envio_pronto ? fim : aguarda_transmissao;
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

        case (Eatual)
            inicial:                           db_estado = 4'b0000;//0
            faz_rotacao:                       db_estado = 4'b0001;//1
            aguarda_rotacao:                   db_estado = 4'b0010;//2
            faz_medida:                        db_estado = 4'b0011;//3
            aguarda_medida:                    db_estado = 4'b0100;//4
            faz_transmissao:                   db_estado = 4'b0101;//5
            aguarda_transmissao:               db_estado = 4'b0110;//6
            fim:                               db_estado = 4'b1111;//F
            default:                           db_estado = 4'b0000;//E
        endcase
    end

endmodule