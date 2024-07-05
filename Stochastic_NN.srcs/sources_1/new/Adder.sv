// Multiplexer with select line = stoch number = 0.5

module Adder(
    input clk,
    input reset,
    input [15:0] seed,
    input stoch_num1,
    input stoch_num2,
    output result_stoch
    );

    reg sum_stoch;

    // SNG for select line
    wire stoch_num_sel;
    StochNumGen16 sng_sel(
        .clk                (clk),
        .reset              (reset),
        .seed               (seed),
        .prob               (16'b1000000000000000),     // 0.5
        .stoch_num          (stoch_num_sel)
    );

    // Multiplexer with two inputs - combinational
    always @(*) begin
        if (stoch_num_sel)
            sum_stoch = stoch_num2;    // sel = 1
        else
            sum_stoch = stoch_num1;    // sel = 0
    end

    assign result_stoch = sum_stoch;

endmodule
