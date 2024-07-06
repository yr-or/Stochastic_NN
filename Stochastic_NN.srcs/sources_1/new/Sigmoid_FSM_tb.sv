// Instantiate SNG and STB for Sigmoid FSM

module Sigmoid_FSM_tb(
    input clk,
    input reset,
    input [15:0] inp_prob,
    input [15:0] seed,
    output [15:0] out_prob
    );

    // Wires
    wire inp_stoch;
    wire out_stoch;
    wire done_stb;

    // Generate stochastic number
    StochNumGen16 SNG1(
        .clk                (clk),
        .reset              (reset),
        .seed               (seed),
        .prob               (inp_prob),
        .stoch_num          (inp_stoch)
    );

    // Apply stoch input to FSM
    Sigmoid_FSM FSM(
        .clk                (clk),
        .reset              (reset),
        .in_stoch           (inp_stoch),
        .out_stoch          (out_stoch)
    );

    // Estimate probability of output
    StochToBin #(.BITSTR_LEN(2047)) stb(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (out_stoch),
        .bin_number         (out_prob),
        .done               (done_stb)
    );

endmodule
