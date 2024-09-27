`timescale 1ns/1ns

module transmissor_ascii_tb();

reg clock, reset, iniciar;
reg [6:0] centena_angulo, dezena_angulo, unidade_angulo, caractere_final_angulo,
          centena_distancia, dezena_distancia, unidade_distancia, caractere_final_distancia;
wire dado_serial, pronto;

transmissor_ascii dut (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .centena_angulo(centena_angulo),
    .dezena_angulo(dezena_angulo),
    .unidade_angulo(unidade_angulo),
    .caractere_final_angulo(caractere_final_angulo),
    .centena_distancia(centena_distancia),
    .dezena_distancia(dezena_distancia),
    .unidade_distancia(unidade_distancia),
    .caractere_final_distancia(caractere_final_distancia),
    .pronto(pronto),
    .dado_serial(dado_serial)
);

// Configurações do clock
parameter clockPeriod = 20; // clock de 50MHz
// Gerador de clock
always #(clockPeriod/2) clock = ~clock;

// Array de casos de teste (estrutura equivalente em Verilog)
integer caso;

// Largura do pulso
reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores

// Geração dos sinais de entrada (estímulos)
initial begin
    $display("Inicio das simulacoes");
    $dumpfile("vvp/transmissor_ascii_tb.vcd");
    $dumpvars(0, transmissor_ascii_tb);

    // Inicialização do array de casos de teste
    centena_angulo = 7'b0110001;   // 1
    dezena_angulo = 7'b0110100;   // 4
    unidade_angulo = 7'b0110111;   // 7
    caractere_final_angulo = 7'b0101100;   // ,
    centena_distancia = 7'b0110010;   // 2
    dezena_distancia = 7'b0111000;   // 9
    unidade_distancia = 7'b0110111;   // 7
    caractere_final_distancia = 7'b0100011;   // #

    // Valores iniciais
    iniciar = 0;
    clock = 0;

    // Reset
    caso = 0; 
    #(2*clockPeriod);
    reset = 1;
    #(2_000); // 2 us
    reset = 0;
    @(negedge clock);
    iniciar = 1;
    #(2*clockPeriod);
    iniciar = 0;
    
    wait (pronto == 1'b1);
    $display("Fim do caso teste");
    #(100*clockPeriod)

    $stop;
end

endmodule