module registrador_m_we #(parameter M=1) (
    input clock,
    input reset,
    input we,
    input [M-1:0] D,
    output [M-1:0] Q
);
reg [M-1:0] Q_reg;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        Q_reg <= {M{1'b0}};
    end else if (we) begin
        Q_reg <= D;
    end
end

assign Q = Q_reg;
endmodule