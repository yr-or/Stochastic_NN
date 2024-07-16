
// Multiplexer with select line stochastic input, not generated in here

module Adder_noSNG(
    input clk,
    input reset,
    input sel,
    input stoch_num1,
    input stoch_num2,
    output result_stoch
    );

    reg sum_stoch;

    // Multiplexer with two inputs - combinational
    always @(*) begin
        if (sel)
            sum_stoch = stoch_num2;    // sel = 1
        else
            sum_stoch = stoch_num1;    // sel = 0
    end

    assign result_stoch = sum_stoch;

endmodule
