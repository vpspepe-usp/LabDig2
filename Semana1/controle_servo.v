module controle_servo (
 input wire clock,
 input wire reset,
 input wire [1:0] posicao,
 output wire controle,
 output wire db_controle
);

wire pwm_out;

circuito_pwm #(           // instanciado com valores default
        .conf_periodo(1000000),  // T=20ms
        .largura_00  (0),  // pulso=0
        .largura_01  (50000),  // pulso de 1ms
        .largura_10  (75000),  // pulso de 1.5ms
        .largura_11  (100000)   // pulso de 2ms
    ) dut (
        .clock   (clock),
        .reset   (reset),
        .largura (posicao),
        .pwm     (pwm_out)
    );

assign controle = pwm_out;
assign db_controle = pwm_out;

endmodule