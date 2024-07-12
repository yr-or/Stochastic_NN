// Layer 2 Neuron with 196 inputs for 8-bit data each
// Only uses stochastic numbers

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module Neuron196_L2(
    input clk,
    input reset,
    input input_data    [0:195],
    input weights       [0:195],
    input bias,

    output macc_out,                // Debug wire
    output add1_res_stoch [0:97],   // Debug wire
    output add2_res_stoch [0:48],
    output add3_res_stoch [0:23],
    output add4_res_stoch [0:11],
    output add5_res_stoch [0:5],
    output add6_res_stoch [0:2],
    output add7_res_stoch [0:1],
    output bias_out,                // Debug wire
    output result
    );

    // Constants
    localparam NUM_INPS = 196;
    //typedef enum {LFSR_GAL, LFSR_FIB, PUF_RNG} RNG_SOURCE = LFSR_GAL;

    // wires/regs
    wire result_macc;
    wire result_bias;

    // MACC module
    Macc196_L2 MAC_L2(
        .clk                (clk),
        .reset              (reset),
        .input_data         (input_data),
        .weights            (weights),
        .result             (result_macc),

        .add1_res_stoch     (add1_res_stoch),
        .add2_res_stoch     (add2_res_stoch),
        .add3_res_stoch     (add3_res_stoch),
        .add4_res_stoch     (add4_res_stoch),
        .add5_res_stoch     (add5_res_stoch),
        .add6_res_stoch     (add6_res_stoch),
        .add7_res_stoch     (add7_res_stoch)
    );

    // Add bias - Mux adder
    Adder add_bias(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd4839),
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
    assign result = result_bias;

endmodule
