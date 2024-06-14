// Testbench for Neuron196_L2, generate stoch nums and convert outputs
// Inputs: Stochastic inputs, weights and bias
// Output: 8-bit binary result

module Neuron196_L2_tb(
    input clk,
    input reset,
    input [7:0] input_data_bin [0:195],
    input [7:0] weights_bin [0:195],
    input [7:0] bias_bin,
    input [7:0] LFSR1_seed,
    input [7:0] LFSR2_seed,

    output [7:0] result_bin,
    output [7:0] macc_result_bin,   // debug
    output [7:0] bias_out_bin,      // debug
    output done
    );

    localparam NUM_INPS = 196;

    // Stochastic inputs
    wire inps_stoch       [0:NUM_INPS-1];
    wire weights_stoch    [0:NUM_INPS-1];
    wire bias_stoch;

    // Stochastic outputs
    wire neur_result_stoch;
    wire macc_out_stoch;
    wire bias_out_stoch;

    // Generate stochastic inputs
    genvar i;
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochNumGen SNG_inps(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR1_seed),
                .prob           (input_data_bin[i]),
                .stoch_num      (inps_stoch[i])
            );
        end
    endgenerate

    // Generate stochastic weights
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochNumGen SNG_weights(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR2_seed),
                .prob           (weights_bin[i]),
                .stoch_num      (weights_stoch[i])
            );
        end
    endgenerate

    // Generate bias stoch num
    StochNumGen SNG_bias(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd132),       // Changed from 12 to 132, fixed issue of outputs too high
        .prob               (bias_bin),
        .stoch_num          (bias_stoch)
    );

    // Neuron
    Neuron196_L2 neur_L2(
        .clk                (clk),
        .reset              (reset),
        .input_data         (inps_stoch),
        .weights            (weights_stoch),
        .bias               (bias_stoch),

        .macc_out           (macc_out_stoch),
        .bias_out           (bias_out_stoch),
        .result             (neur_result_stoch)
    );

    // STB output
    StochToBin STB(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (neur_result_stoch),
        .bin_number         (result_bin),
        .done               (done)
    );

    // STB for macc result
    StochToBin stb_macc(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (macc_out_stoch),
        .bin_number         (macc_result_bin)
    );

    // STB bias result
    StochToBin stb_bias(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (bias_out_stoch),
        .bin_number         (bias_out_bin)
    );

endmodule
