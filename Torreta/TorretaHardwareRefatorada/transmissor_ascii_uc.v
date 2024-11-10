module transmissor_ascii_uc(
    input clock,
    input reset,
    input iniciar,
    input fim_transmissao,
    output reg transmite,
    output reg pronto
);

// Tipos e sinais
reg [4:0] Eatual, Eprox; // 3 bits são suficientes para 7 estados

// Parâmetros para os estados
parameter inicial                                       = 5'b00000;
parameter transmite_centena_angulo                      = 5'b00001;
parameter espera_transmissao_centena_angulo             = 5'b00010;
parameter transmite_dezena_angulo                       = 5'b00011;
parameter espera_transmissao_dezena_angulo              = 5'b00100;
parameter transmite_unidade_angulo                      = 5'b00101;
parameter espera_transmissao_unidade_angulo             = 5'b00110;
parameter transmite_caracter_final_angulo               = 5'b00111;
parameter espera_transmissao_caracter_final_angulo      = 5'b01000;
parameter transmite_centena_distancia                   = 5'b01001;
parameter espera_transmissao_centena_distancia          = 5'b01010;
parameter transmite_dezena_distancia                    = 5'b01011;
parameter espera_transmissao_dezena_distancia           = 5'b01100;
parameter transmite_unidade_distancia                   = 5'b01101;
parameter espera_transmissao_unidade_distancia          = 5'b01110;
parameter transmite_caracter_final_distancia            = 5'b01111;
parameter espera_transmissao_caracter_final_distancia   = 5'b10000;
parameter fim                                           = 5'b10001;

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
        inicial:                                     Eprox = iniciar ? transmite_centena_angulo : inicial;
        // Transmissão do ângulo
        transmite_centena_angulo:                    Eprox = espera_transmissao_centena_angulo;
        espera_transmissao_centena_angulo:           Eprox = fim_transmissao ? transmite_dezena_angulo : espera_transmissao_centena_angulo;
        transmite_dezena_angulo:                     Eprox = espera_transmissao_dezena_angulo;
        espera_transmissao_dezena_angulo:            Eprox = fim_transmissao ? transmite_unidade_angulo : espera_transmissao_dezena_angulo;
        transmite_unidade_angulo:                    Eprox = espera_transmissao_unidade_angulo;
        espera_transmissao_unidade_angulo:           Eprox = fim_transmissao ? transmite_caracter_final_angulo : espera_transmissao_unidade_angulo;
        transmite_caracter_final_angulo:             Eprox = espera_transmissao_caracter_final_angulo;
        espera_transmissao_caracter_final_angulo:    Eprox = fim_transmissao ? transmite_centena_distancia : espera_transmissao_caracter_final_angulo;
        // Transmissão da distância
        transmite_centena_distancia:                 Eprox = espera_transmissao_centena_distancia;
        espera_transmissao_centena_distancia:        Eprox = fim_transmissao ? transmite_dezena_distancia : espera_transmissao_centena_distancia;
        transmite_dezena_distancia:                  Eprox = espera_transmissao_dezena_distancia;
        espera_transmissao_dezena_distancia:         Eprox = fim_transmissao ? transmite_unidade_distancia : espera_transmissao_dezena_distancia;
        transmite_unidade_distancia:                 Eprox = espera_transmissao_unidade_distancia;
        espera_transmissao_unidade_distancia:        Eprox = fim_transmissao ? transmite_caracter_final_distancia : espera_transmissao_unidade_distancia;
        transmite_caracter_final_distancia:                    Eprox = espera_transmissao_caracter_final_distancia;
        espera_transmissao_caracter_final_distancia: Eprox = fim_transmissao ? fim : espera_transmissao_caracter_final_distancia;
        fim:                                         Eprox = inicial;
        default: 
            Eprox = inicial;
    endcase
end

// Saídas de controle
always @(*) begin
        
        transmite     = (
                        Eatual == transmite_centena_angulo || 
                        Eatual == transmite_dezena_angulo  ||
                        Eatual == transmite_unidade_angulo ||
                        Eatual == transmite_caracter_final_angulo ||
                        Eatual == transmite_centena_distancia || 
                        Eatual == transmite_dezena_distancia  ||
                        Eatual == transmite_unidade_distancia ||
                        Eatual == transmite_caracter_final_distancia
                        ) ? 1'b1 : 1'b0;
        pronto = (Eatual == fim)  ? 1'b1 : 1'b0;

//    case (Eatual)
//        inicial:                           db_estado = 4'b0000;//0
//        faz_medida:                        db_estado = 4'b0001;//1
//        aguarda_medida:                    db_estado = 4'b0010;//2
//        transmite_centena:                 db_estado = 4'b0011;//3
//        espera_transmissao_centena:        db_estado = 4'b0100;//4
//        transmite_dezena:                  db_estado = 4'b0101;//5
//        espera_transmissao_dezena:         db_estado = 4'b0110;//6
//        transmite_unidade:                 db_estado = 4'b0111;//7
//        espera_transmissao_unidade:        db_estado = 4'b1000;//8
//        transmite_caracter_final:          db_estado = 4'b1001;//9
//        espera_transmissao_caracter_final: db_estado = 4'b1010;//A
//        fim:                               db_estado = 4'b1111;//F
//        default:       db_estado = 4'b1110;//E
//    endcase
end


endmodule