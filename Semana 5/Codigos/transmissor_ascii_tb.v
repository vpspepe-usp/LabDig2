`timescale 1ns/1ns

module transmissor_ascii_tb;

reg clock, reset, iniciar;
reg [6:0] dados_ascii [0:7];
wire saida_serial, pronto;

transmissor_ascii dut (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .dados_ascii(dados_ascii),
    .pronto(pronto),
    .saida_serial(saida_serial)
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

    // Inicialização do array de casos de teste
    dados_ascii[0] = 7'b0110001;   // 1
    dados_ascii[1] = 7'b0110100;   // 4
    dados_ascii[2] = 7'b0110111;   // 7
    dados_ascii[3] = 7'b0101100;   // ,
    dados_ascii[4] = 7'b0110010;   // 2
    dados_ascii[5] = 7'b0111000;   // 9
    dados_ascii[6] = 7'b0110111;   // 7
    dados_ascii[7] = 7'b0100011;   // #

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

    $stop;
end










endmodule