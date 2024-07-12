// Layer 3 Neuron with 32 inputs for 8-bit data each
// Only uses stochastic numbers
// NOTE: Uses unipolar multiplier instead of bipolar

module Neuron32_L3(
    input clk,
    input reset,
    input input_data    [0:31],
    input weights       [0:31],
    input bias,

    output macc_out,    // Debug wire
    output bias_out,    // Debug wire
    output result
    );

    // Constants
    localparam NUM_INPS = 32;
    //typedef enum {LFSR_GAL, LFSR_FIB, PUF_RNG} RNG_SOURCE = LFSR_GAL;

    // wires/regs
    wire result_macc;
    wire result_bias;

    // MACC module
    Macc32_L3 MAC_L3(
        .clk                (clk),
        .reset              (reset),
        .input_data         (input_data),
        .weights            (weights),
        .result             (result_macc)
    );

    // Add bias - Mux adder
    Adder add_bias(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd28347),
        .stoch_num1         (result_macc),
        .stoch_num2         (bias),
        .result_stoch       (result_bias)
    );

    // Activation function
    /*
    Sigmoid_FSM act_fcn(
        .clk                (clk),
        .reset              (reset),
        .in_stoch           (result_bias),
        .out_stoch          (result)
    );
    */

    assign macc_out = result_macc;
    assign bias_out = result_bias;
    assign result = bias_out;

endmodule
