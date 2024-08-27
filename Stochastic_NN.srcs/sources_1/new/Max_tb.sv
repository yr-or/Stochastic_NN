// Generate 10 stoch inputs

module Max_tb(
    input clk,
    input reset,
    input [15:0] values_bin [0:9],

    output [3:0] result,
    output done
    );

    wire stoch_nums [0:9];

    // Generate stochastic numbers
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin
            StochNumGen16 SNG (
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd38493),
                .prob               (values_bin[i]),
                .stoch_num          (stoch_nums[i])
            );
        end
    endgenerate

    // Input to Max module
    Max_int16 max (
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .nums               (stoch_nums),
        .max_ind            (result),
        .done               (done)
    );

endmodule
