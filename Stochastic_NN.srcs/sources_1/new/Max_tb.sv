// Generate 10 stoch inputs

module Max_tb(
    input clk,
    input reset,
    input [7:0] values_bin [0:9],

    output [3:0] result,
    output done
    );

    wire stoch_nums [0:9];

    // Generate stochastic numbers
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin
            StochNumGen SNG (
                .clk                (clk),
                .reset              (reset),
                .seed               (8'd193),
                .prob               (values_bin[i]),
                .stoch_num          (stoch_nums[i])
            );
        end
    endgenerate

    // Input to Max module
    Max max (
        .clk                (clk),
        .reset              (reset),
        .stoch_array        (stoch_nums),
        .max_ind            (result),
        .done               (done)
    );

endmodule
