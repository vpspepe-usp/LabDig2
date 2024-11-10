module servo_recarga_uc (
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       fim_recarga,
    output reg       contar,
    output reg       fim,
    output reg [1:0] db_estado
);

    // Tipos e sinais
    reg [1:0] Eatual, Eprox; // 2 bits são suficientes para 4 estados

    // Parâmetros para os estados
    parameter inicial         = 2'b00;
    parameter recarregando    = 2'b01;
    parameter final_recarga   = 2'b10;

    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:        Eprox = iniciar ? recarregando : inicial;
            recarregando:   Eprox = fim_recarga ? final_recarga : recarregando;
            final_recarga:  Eprox = inicial;
            default: 
                Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        contar   = (Eatual == recarregando)   ? 1'b1 : 1'b0;
        fim      = (Eatual == final_recarga)  ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:        db_estado = 2'b00;
            recarregando:   db_estado = 2'b01;
            final_recarga:  db_estado = 2'b10;
            default:        db_estado = 2'b11;
        endcase
    end

endmodule
