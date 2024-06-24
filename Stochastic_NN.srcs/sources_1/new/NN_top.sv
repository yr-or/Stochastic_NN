// Top-level module for Neural Network
// contains each layer and max module, as well as SNGs to generate inputs
// Inputs: 8-bit binary input array encoding the digit
// Output: 4-bit binary value indicating predicted digit (0-9)

module NN_top(
    input clk,
    input reset,
    input [7:0] input_data_bin    [0:195],     // 196 8-bit values
    input [7:0] LFSR_inp_seed,

    output [3:0] result_bin,                     // Predicted digit binary
    output done
    );

    localparam NUM_NEUR_L2 = 32;
    localparam NUM_NEUR_L3 = 10;
    localparam NUM_INP = 196;

    // Stoch wires inputs
    wire inps_stoch [0:NUM_INP-1];

    // Wires for outputs of layers
    wire L2_out_stoch [0:NUM_NEUR_L2-1];
    wire L3_out_stoch [0:NUM_NEUR_L3-1];

    // Generate stoachastic inputs - 196 SNGs
    genvar i;
    generate
        for (i=0; i<NUM_INP; i=i+1) begin
            StochNumGen SNG_inps(
                .clk                (clk),
                .reset              (reset),
                .seed               (LFSR_inp_seed),
                .prob               (input_data_bin[i]),
                .stoch_num          (inps_stoch[i])
            );
        end
    endgenerate

    // Connect to Layer2
    Layer2 L2(
        .clk                    (clk),
        .reset                  (reset),
        .data_in_stoch          (inps_stoch),
        .results                (L2_out_stoch)
    );

    // Connect to Layer3
    Layer3 L3(
        .clk                    (clk),
        .reset                  (reset),
        .data_in_stoch          (L2_out_stoch),
        .results                (L3_out_stoch)
    );

    // Max module
    Max max (
        .clk                    (clk),
        .reset                  (reset),
        .stoch_array            (L3_out_stoch),
        .max_ind                (result_bin),
        .done                   (done)
    );

endmodule
