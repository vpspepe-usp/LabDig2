/*
 * rom_angulos_32x24.v
 */
 
module rom_angulos_29x24 (
    input      [4:0]  endereco, 
    output reg [23:0] saida
);

  // conteudo da rom em um array
  reg [23:0] tabela_angulos [0:28]; 

  initial begin
    // inicializa array com valores dos angulos
    tabela_angulos[0] = 24'h303230; // 0 = 020
    tabela_angulos[1] = 24'h303235; // 1 = 025
    tabela_angulos[2] = 24'h303330; // 2 = 030
    tabela_angulos[3] = 24'h303335; // 3 = 035
    tabela_angulos[4] = 24'h303430; // 4 = 040
    tabela_angulos[5] = 24'h303435; // 5 = 045
    tabela_angulos[6] = 24'h303530; // 6 = 050
    tabela_angulos[7] = 24'h303535; // 7 = 055
    tabela_angulos[8] = 24'h303630; // 8 = 060
    tabela_angulos[9] = 24'h303635; // 9 = 065
    tabela_angulos[10] = 24'h303730; // 10 = 070
    tabela_angulos[11] = 24'h303735; // 11 = 075
    tabela_angulos[12] = 24'h303830; // 12 = 080
    tabela_angulos[13] = 24'h303835; // 13 = 085
    tabela_angulos[14] = 24'h303930; // 14 = 090
    tabela_angulos[15] = 24'h303935; // 15 = 095
    tabela_angulos[16] = 24'h313030; // 16 = 100
    tabela_angulos[17] = 24'h313035; // 17 = 105
    tabela_angulos[18] = 24'h313130; // 18 = 110
    tabela_angulos[19] = 24'h313135; // 19 = 115
    tabela_angulos[20] = 24'h313230; // 20 = 120
    tabela_angulos[21] = 24'h313235; // 21 = 125
    tabela_angulos[22] = 24'h313330; // 22 = 130
    tabela_angulos[23] = 24'h313335; // 23 = 135
    tabela_angulos[24] = 24'h313430; // 24 = 140
    tabela_angulos[25] = 24'h313435; // 25 = 145
    tabela_angulos[26] = 24'h313530; // 26 = 150
    tabela_angulos[27] = 24'h313535; // 27 = 155
    tabela_angulos[28] = 24'h313630; // 28 = 160
  end

  // saida da memoria em funcao do endereco
  always @(*) begin 
    saida = tabela_angulos[endereco]; 
  end

endmodule