/* -----------------Laboratorio Digital-----------------------------------
 *  Arquivo   : registrador_n.v
 * -----------------------------------------------------------------------
 *  Descricao : registrador com numero de bits N como parametro
 *              com clear assincrono e carga sincrona
 * 
 *              baseado no codigo vreg16.v do livro
 *              J. Wakerly, Digital design: principles and practices 5e
 *
 * -----------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  criacao
 * -----------------------------------------------------------------------
 */
 
module registrador (
    input          clock,
    input          clear,
    input          enable,
    input  D,
    output Q
);

    reg IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule
