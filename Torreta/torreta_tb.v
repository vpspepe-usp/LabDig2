`timescale 1ns/1ns

module torreta_tb;
reg clock;
reg reset;
reg ligar;
reg echo;
reg conta_municao;
reg seletor_hexa;
wire trigger;
wire pwm;
wire saida_serial;
wire fim_posicao;
wire ameaca_detectada;
wire [6:0] db_estado;
wire [6:0] db_centena;
wire [6:0] db_dezena;
wire [6:0] db_unidade;
wire [6:0] hex_contagem_municao;

torreta DUT (
    .clock(clock),
    .reset(reset),
    .ligar(ligar),
    .echo(echo),
    .conta_municao(conta_municao),
    .seletor_hexa(seletor_hexa),
    .trigger(trigger),
    .pwm(pwm),
    .saida_serial(saida_serial),
    .fim_posicao(fim_posicao),
    .ameaca_detectada(ameaca_detectada),
    .db_estado(db_estado),
    .db_centena(db_centena),
    .db_dezena(db_dezena),
    .db_unidade(db_unidade),
    .hex_contagem_municao(hex_contagem_municao)
);

// Configurações do clock
parameter clockPeriod = 20; // clock de 50MHz
// Gerador de clock
always #(clockPeriod/2) clock = ~clock;

// Array de casos de teste (estrutura equivalente em Verilog)
reg [31:0] casos_teste [0:4]; // Usando 32 bits para acomodar o tempo
integer caso;
integer i;

// Largura do pulso
reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores


// Geração dos sinais de entrada (estímulos)
initial begin
    $display("Inicio das simulacoes");

    // Inicialização do array de casos de teste
    casos_teste[0] = 5882;   // 5882us (100cm)
    casos_teste[1] = 4430;   // 4430us (75,29cm)
    casos_teste[2] = 2058;   // 2058us (35cm)
    casos_teste[3] = 1235;   // 1235us (21cm)
    casos_teste[4] = 5882;   // 5882us (100cm)

    // Valores iniciais
    ligar = 0;
    echo  = 0;
    clock = 0;
    seletor_hexa = 0;
    conta_municao = 0;
    reset = 0;

    // Reset
    caso = 0; 
    #(2*clockPeriod);
    reset = 1;
    #(2_000); // 2 us
    reset = 0;
    @(negedge clock);

    // Espera de 100us
    #(100_000); // 100 us

    // Carregar a torreta
    for (i = 0; i < 4; i = i + 1) begin
        conta_municao = 1;
        #(5*clockPeriod);
        conta_municao = 0;
        #(5*clockPeriod);
    end

    // Espera de 100us
    #(100_000); // 100 us
    // Ligar o torreta
    ligar = 1;
    #(5*clockPeriod);

    // Loop pelos casos de teste
    for (caso = 1; caso < 6; caso = caso + 1) begin
        // 1) Determina a largura do pulso echo
        $display("Caso de teste %0d: %0dus", caso, casos_teste[caso-1]);
        larguraPulso = casos_teste[caso-1]*1000; // 1us=1000

        // 2) Espera envio do trigger
        wait (trigger == 1'b1);
        // 3) Espera por 400us (tempo entre trigger e echo)
        #(400_000); // 400 us

        // 4) Gera pulso de echo
        echo = 1;
        #(larguraPulso);
        echo = 0;

        // 5) Espera final da medida
        wait (fim_posicao == 1'b1);
        $display("Fim do caso %0d", caso);

        // 6) Espera entre casos de teste
        #(100); // 100 ns
    end

    // Fim da simulação
    $display("Fim das simulacoes");
    caso = 99; 
    $stop;
end

endmodule