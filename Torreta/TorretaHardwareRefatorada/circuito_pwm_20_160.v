/*
 * circuito_pwm.v - descrição comportamental
 *
 * gera saída com modulacao pwm conforme parametros do modulo
 *
 * parametros: valores definidos para clock de 50MHz (periodo=20ns)
 * ------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     26/09/2021  1.0     Edson Midorikawa  criacao do componente VHDL
 *     17/08/2024  2.0     Edson Midorikawa  componente em Verilog
 * ------------------------------------------------------------------------
 */
 
module circuito_pwm_20_160 #(    // valores default
    parameter conf_periodo = 1250, // Período do sinal PWM [1250 => f=4KHz (25us)]
    parameter largura_00000 = 0,       //Largura do Pulso p/ 0
    parameter largura_00001 = 0,       //Largura do Pulso p/ 1
    parameter largura_00010 = 0,       //Largura do Pulso p/ 2
    parameter largura_00011 = 0,       //Largura do Pulso p/ 3
    parameter largura_00100 = 0,       //Largura do Pulso p/ 4
    parameter largura_00101 = 0,       //Largura do Pulso p/ 5
    parameter largura_00110 = 0,       //Largura do Pulso p/ 6
    parameter largura_00111 = 0,       //Largura do Pulso p/ 7
    parameter largura_01000 = 0,       //Largura do Pulso p/ 8
    parameter largura_01001 = 0,       //Largura do Pulso p/ 9
    parameter largura_01010 = 0,       //Largura do Pulso p/ 10
    parameter largura_01011 = 0,       //Largura do Pulso p/ 11
    parameter largura_01100 = 0,       //Largura do Pulso p/ 12
    parameter largura_01101 = 0,       //Largura do Pulso p/ 13
    parameter largura_01110 = 0,       //Largura do Pulso p/ 14
    parameter largura_01111 = 0,       //Largura do Pulso p/ 15
    parameter largura_10000 = 0,       //Largura do Pulso p/ 16
    parameter largura_10001 = 0,       //Largura do Pulso p/ 17
    parameter largura_10010 = 0,       //Largura do Pulso p/ 18
    parameter largura_10011 = 0,       //Largura do Pulso p/ 19
    parameter largura_10100 = 0,       //Largura do Pulso p/ 20
    parameter largura_10101 = 0,       //Largura do Pulso p/ 21
    parameter largura_10110 = 0,       //Largura do Pulso p/ 22
    parameter largura_10111 = 0,       //Largura do Pulso p/ 23
    parameter largura_11000 = 0,       //Largura do Pulso p/ 24
    parameter largura_11001 = 0,       //Largura do Pulso p/ 25
    parameter largura_11010 = 0,       //Largura do Pulso p/ 26
    parameter largura_11011 = 0,       //Largura do Pulso p/ 27
    parameter largura_11100 = 0        //Largura do Pulso p/ 28
) (
    input        clock,
    input        reset,
    input  [4:0] largura,
    output reg   pwm
);

reg [31:0] contagem; // Contador interno (32 bits) para acomodar conf_periodo
reg [31:0] largura_pwm;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= largura_00000; // Valor inicial da largura do pulso
    end else begin
        // Saída PWM
        pwm <= (contagem < largura_pwm);

        // Atualização do contador e da largura do pulso
        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                5'b00000: largura_pwm <= largura_00000;
                5'b00001: largura_pwm <= largura_00001;
                5'b00010: largura_pwm <= largura_00010;
                5'b00011: largura_pwm <= largura_00011;
                5'b00100: largura_pwm <= largura_00100;
                5'b00101: largura_pwm <= largura_00101;
                5'b00110: largura_pwm <= largura_00110;
                5'b00111: largura_pwm <= largura_00111;
                5'b01000: largura_pwm <= largura_01000;
                5'b01001: largura_pwm <= largura_01001;
                5'b01010: largura_pwm <= largura_01010;
                5'b01011: largura_pwm <= largura_01011;
                5'b01100: largura_pwm <= largura_01100;
                5'b01101: largura_pwm <= largura_01101;
                5'b01110: largura_pwm <= largura_01110;
                5'b01111: largura_pwm <= largura_01111;
                5'b10000: largura_pwm <= largura_10000;
                5'b10001: largura_pwm <= largura_10001;
                5'b10010: largura_pwm <= largura_10010;
                5'b10011: largura_pwm <= largura_10011;
                5'b10100: largura_pwm <= largura_10100;
                5'b10101: largura_pwm <= largura_10101;
                5'b10110: largura_pwm <= largura_10110;
                5'b10111: largura_pwm <= largura_10111;
                5'b11000: largura_pwm <= largura_11000;
                5'b11001: largura_pwm <= largura_11001;
                5'b11010: largura_pwm <= largura_11010;
                5'b11011: largura_pwm <= largura_11011;
                5'b11100: largura_pwm <= largura_11100;
                default: largura_pwm <= largura_00000; // Valor padrão
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule
