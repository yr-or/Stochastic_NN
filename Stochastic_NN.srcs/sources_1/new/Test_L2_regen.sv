// Testbench with just L2 and regen outputs

module Test_L2_regen(
    input clk,
    input reset,
    input [15:0] input_data_bin      [0:195],    // 196 8-bit values
    //input [15:0] LFSR_inp_seed,

    output [15:0] relu_results_bin     [0:31],     // 32 Neurons / outputs
    output [15:0] macc_results_bin   [0:31],
    output [15:0] bias_results_bin   [0:31],
    output done
    );

    localparam NUM_NEUR_L2 = 32;
    localparam NUM_INP = 196;

    // Stoch wires inputs
    wire inps_stoch         [0:NUM_INP-1];

    // Wires for Layer2
    wire L2_out_stoch       [0:NUM_NEUR_L2-1];      // Will go into Layer 3
    wire L2_macc_out_stoch  [0:NUM_NEUR_L2-1];
    
    // Wires for regen module
    wire L2_regen_stoch [0:NUM_NEUR_L2-1];
    wire done_regen;

    // Generate stoachastic inputs - 196 SNGs
    genvar i;
    generate
        for (i=0; i<NUM_INP; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd24415),
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
        .results                (L2_out_stoch),
        .macc_results           (L2_macc_out_stoch)
    );

    generate
        for (i=0; i<NUM_NEUR_L2; i=i+1) begin
            StochToBin16 STB_macc (
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (L2_macc_out_stoch[i]),
                .bin_number         (macc_results_bin[i])
            );
        end
    endgenerate

    // Regen module
    Regenerate_L2 regen(
        .clk                    (clk),
        .reset                  (reset),
        .L2_outs_stoch          (L2_out_stoch),

        .L2_regen_stoch         (L2_regen_stoch),
        .done                   (done_regen),
        // Debug ports
        .L2_bias_out_bin        (bias_results_bin),
        .L2_relu_out_bin        (relu_results_bin)
    );

    assign done = done_regen;

endmodule

