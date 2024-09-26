module controle_servo_3 (
 input clock,
 input reset,
 input [2:0] posicao,
 output controle,
 output db_reset,
 output [2:0] db_posicao,
 output db_controle
);

wire pwm_out;

circuito_pwm #(    
     .conf_periodo(1000000),    //T = 20ms 
     .largura_000(35000),       // 35000 -> 0,7ms -> 20o
     .largura_001(45700),       // 45700 -> 0,914ms -> 40o
     .largura_010(56450),       // 56450 -> 1,129ms -> 60o
     .largura_011(67150),       // 67150 -> 1,343ms -> 80o
     .largura_100(77850),       // 77850 -> 1,557ms -> 100o
     .largura_101(88550),       // 88550 -> 1,771ms -> 120o
     .largura_110(99300),       // 99300 -> 1,986ms -> 140o
     .largura_111(110000)      // 110000 -> 2,2ms -> 160o

) dut (
    .clock(clock),
    .reset(reset),
    .largura(posicao),
    .pwm(pwm_out)
);

assign controle = pwm_out;
assign db_controle = pwm_out;


endmodule