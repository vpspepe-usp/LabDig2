/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de interface com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04 (
    input wire         clock,
    input wire         reset,
    input wire         medir,
    input wire         echo,
    output wire        trigger,
    output wire [11:0] medida,
    output wire        pronto,
    output wire [3:0]  db_estado
);

    // Sinais internos
    wire        s_zera;
    wire        s_gera;
    wire        s_registra;
    wire        s_fim_medida;
    wire [11:0] s_medida;

    // Unidade de controle
    interface_hcsr04_uc U1 (
        .clock     (clock       ),
        .reset     (reset       ),
        .medir     (medir       ),
        .echo      (echo        ),
        .fim_medida(s_fim_medida),
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .pronto    (pronto      ),
        .db_estado (db_estado   )
    );

    // Fluxo de dados
    interface_hcsr04_fd U2 (
        .clock     (clock       ),
        .pulso     (echo        ), 
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .fim_medida(s_fim_medida),
        .trigger   (trigger     ),
        .fim       (            ),  // (desconectado)
        .distancia (s_medida    )
    );

    // Saída
    assign medida = s_medida; 

endmodule
