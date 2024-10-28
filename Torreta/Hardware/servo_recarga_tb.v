`timescale 1ns/1ns

module servo_recarga_tb;

reg clock, reset, recarregar, caso;
wire pwm, fim_recarga;

servo_recarga DUT (
    .clock(clock),
    .reset(reset),
    .recarregar(recarregar),
    .pwm(pwm),
    .fim_recarga(fim_recarga)
);

// Configurações do clock
parameter clockPeriod = 20; // clock de 50MHz
// Gerador de clock
always #(clockPeriod/2) clock = ~clock;

initial begin
    $display("Inicio das simulacoes");
    caso = 0;
    clock = 0;
    reset = 0;

    // Reset
    reset = 1;
    #(5*clockPeriod);
    reset = 0;

    wait(pwm == 1'b1);
    wait(pwm == 1'b0);

    // Recarregar
    recarregar = 1;
    #(5*clockPeriod);
    recarregar = 0;

    wait(fim_recarga == 1'b1);

    
    $display("Fim das simulacoes");
    caso = 99; 
    $stop;
end
endmodule