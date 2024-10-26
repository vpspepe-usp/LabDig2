module controle_servo_5 (
 input clock,
 input reset,
 input [4:0] posicao,
 output controle,
 output db_reset,
 output [4:0] db_posicao,
 output db_controle
);

wire pwm_out;

circuito_pwm_20_160 #(    
    .conf_periodo(1000000),      // T = 20ms 
    .largura_00000(35000),       // 35000 -> 0,7ms -> 20o
    .largura_00001(37675),       // 37675 -> 0,7535ms -> 25o
    .largura_00010(40350),       // 40350 -> 0,807ms -> 30o
    .largura_00011(43025),       // 43025 -> 0,861ms -> 35o
    .largura_00100(45700),       // 45700 -> 0,914ms -> 40o
    .largura_00101(48375),       // 48375 -> 0,9675ms -> 45o
    .largura_00110(51050),       // 51050 -> 1,021ms -> 50o
    .largura_00111(53725),       // 53725 -> 1,075ms -> 55o
    .largura_01000(56400),       // 56400 -> 1,128ms -> 60o
    .largura_01001(59075),       // 59075 -> 1,181ms -> 65o
    .largura_01010(61750),       // 61750 -> 1,235ms -> 70o
    .largura_01011(64425),       // 64425 -> 1,289ms -> 75o
    .largura_01100(67100),       // 67100 -> 1,343ms -> 80o
    .largura_01101(69775),       // 69775 -> 1,395ms -> 85o
    .largura_01110(72450),       // 72450 -> 1,449ms -> 90o
    .largura_01111(75125),       // 75125 -> 1,503ms -> 95o
    .largura_10000(77800),       // 77800 -> 1,556ms -> 100o
    .largura_10001(80475),       // 80475 -> 1,609ms -> 105o
    .largura_10010(83150),       // 83150 -> 1,663ms -> 110o
    .largura_10011(85825),       // 85825 -> 1,717ms -> 115o
    .largura_10100(88500),       // 88500 -> 1,77ms -> 120o
    .largura_10101(91175),       // 91175 -> 1,823ms -> 125o
    .largura_10110(93850),       // 93850 -> 1,877ms -> 130o
    .largura_10111(96525),       // 96525 -> 1,931ms -> 135o
    .largura_11000(99200),       // 99200 -> 1,984ms -> 140o
    .largura_11001(101875),      // 101875 -> 2,037ms -> 145o
    .largura_11010(104550),      // 104550 -> 2,091ms -> 150o
    .largura_11011(107225),      // 107225 -> 2,145ms -> 155o
    .largura_11100(109900)       // 109900 -> 2,199ms -> 160o

) dut (
    .clock(clock),
    .reset(reset),
    .largura(posicao),
    .pwm(pwm_out)
);

assign controle = pwm_out;
assign db_controle = pwm_out;


endmodule