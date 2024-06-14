// Uses XOR gate for bipolar multiplication

module Mult_bi(
    input stoch_num1,
    input stoch_num2,
    output stoch_res
    );

    assign stoch_res = ~(stoch_num1 ^ stoch_num2);

endmodule
