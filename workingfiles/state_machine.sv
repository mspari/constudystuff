// 20210222.sv

module state_machine(
    input logic clk_i,
    input logic reset_i,
    input logic in_i,
    output logic [1:0] out_o
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
        state_n = state_p << 1;
end

// Output defined in truth table
always_comb
begin
    if (state_p[1] == 0)
    begin
        if (state_p[0] == 0)
        begin
            if (in_i == 0)
            begin
                // 0 0 0
                out_o[1] = 1;
                out_o[0] = 1;
            end

            else
            begin
                // 0 0 1
                out_o[1] = 1;
                out_o[0] = 1;
            end
        end

        else
        begin
            if (in_i == 0)
            begin
                // 0 1 0
                out_o[1] = 1;
                out_o[0] = 0;
            end

            else
            begin
                // 0 1 1
                out_o[1] = 1;
                out_o[0] = 1;
            end
        end
    end

    else
    begin
        if (state_p[0] == 0)
        begin
            if (in_i == 0)
            begin
                // 1 0 0
                out_o[1] = 0;
                out_o[0] = 0;
            end

            else
            begin
                // 1 0 1
                out_o[1] = 0;
                out_o[0] = 0;
            end
        end

        else
        begin
            if (in_i == 0)
            begin
                // 1 1 0
                out_o[1] = 1;
                out_o[0] = 0;
            end

            else
            begin
                // 1 1 1
                out_o[1] = 1;
                out_o[0] = 0;
            end
        end
    end

end

endmodule
