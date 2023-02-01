module state_machine(
    input logic clk_i,
    input logic reset_i,
    input logic in_i,
    output logic [2:0] out_o
);

logic [1:0] state_p, state_n;

always_ff @(posedge clk_i or posedge reset_i) 
begin
    if (reset_i) 
        state_p <= 2'b00;
    else     
        state_p <= state_n;
end

always_comb 
begin
    if (in_i == 0)
        state_n = state_p + 1;
    else 
    begin
        case (state_p)
            2'b00:   state_n = 2;
            2'b01:   state_n = 3;
            2'b10:   state_n = 1;
            default: state_n = 0;
        endcase 
    end
end

always_comb 
begin
    out_o[0] = 1;
    out_o[1] = state_p[0] | state_p[1];
    out_o[2] = state_p[0] & state_p[1];
end

endmodule
