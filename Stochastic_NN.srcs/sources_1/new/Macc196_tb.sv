// Testbench for Macc196, provides input stimulus and checks outputs
// Input: Binary values for data and weights
// Output: Binary value from STB and debug lines

module Macc196_tb(
    input clk,
    input reset,
    input [7:0] input_values    [0:195],
    input [7:0] weights         [0:195],
    input [7:0] LFSR1_seed,
    input [7:0] LFSR2_seed,

    output [7:0] mac_res_bin,
    output done
    );

    // Stochastic wires
    wire inps_stoch     [0:195];
    wire weights_stoch  [0:195];
    wire mac_out_stoch;

    // LFSR seeds - 2 for all values
    //reg [7:0] LFSR_seeds [0:1] = '{225, 83};

    // Generate stochastic inputs
    genvar i;
    generate
        for (i=0; i<196; i=i+1) begin
            StochNumGen SNG_inps(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR1_seed),
                .prob           (input_values[i]),
                .stoch_num      (inps_stoch[i])
            );
        end
    endgenerate

    // Generate stochastic weights
    generate
        for (i=0; i<196; i=i+1) begin
            StochNumGen SNG_weights(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR2_seed),
                .prob           (weights[i]),
                .stoch_num      (weights_stoch[i])
            );
        end
    endgenerate


    // Macc module
    Macc196_L2 MAC(
        .clk                (clk),
        .reset              (reset),
        .input_data         (inps_stoch),
        .weights            (weights_stoch),
        .result             (mac_out_stoch)
    );

    // STB output
    StochToBin STB(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (mac_out_stoch),
        .bin_number         (mac_res_bin),
        .done               (done)
    );

endmodule
