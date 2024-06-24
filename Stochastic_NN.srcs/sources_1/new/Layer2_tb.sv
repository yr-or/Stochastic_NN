// Testbench for Layer2: generate stoch nums and convert outputs
// Inputs: Binary inputs x196, LFSR seed for input SNGs, to allow for testing
// multiple seeds instead of multiple input values in simulation.
// Output: Binary output of each neuron, binary macc results of each neuron

module Layer2_tb(
    input clk,
    input reset,
    input [7:0] input_data_bin      [0:195],    // 196 8-bit values
    input [7:0] LFSR_inp_seed,

    output [7:0] results_bin        [0:31],     // 32 Neurons / outputs
    output [7:0] macc_results_bin   [0:31],
    output done
    );

    localparam NUM_NEUR_L2 = 32;
    localparam NUM_INP = 196;

    // Stoch wires inputs
    wire inps_stoch         [0:NUM_INP-1];

    // Wires for Layer2
    wire L2_out_stoch       [0:NUM_NEUR_L2-1];
    wire L2_macc_out_stoch  [0:NUM_NEUR_L2-1];

    // Generate stoachastic inputs - 8 SNGs
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
        .results                (L2_out_stoch),
        .macc_results           (L2_macc_out_stoch)
    );

    // STBs //
    // Layer2
    wire [0:NUM_NEUR_L2-1] done_stb_res_L2;
    wire [0:NUM_NEUR_L2-1] done_stb_macc_L2;
    wire [7:0] L2_out_bin [0:NUM_NEUR_L2-1];
    wire [7:0] L2_macc_out_bin [0:NUM_NEUR_L2-1];

    // Layer2 outputs STBs
    genvar j;
    generate
        for (j=0; j<NUM_NEUR_L2; j=j+1) begin
            // Convert layer 2 outputs to binary
            StochToBin stb_L2_res(
                .clk                (clk),
                .reset              (reset),
                .enable             (1),
                .bit_stream         (L2_out_stoch[j]),
                .bin_number         (L2_out_bin[j]),
                .done               (done_stb_res_L2[j])
            );
        end
    endgenerate


    // Convert macc results to binary
    generate
        for (j=0; j<NUM_NEUR_L2; j=j+1) begin
            StochToBin stb_L2_macc(
                .clk                (clk),
                .reset              (reset),
                .enable             (1),
                .bit_stream         (L2_macc_out_stoch[j]),
                .bin_number         (L2_macc_out_bin[j]),
                .done               (done_stb_macc_L2[j])
            );
        end
    endgenerate

    assign done = &(done_stb_res_L2);
    assign results_bin = L2_out_bin;
    assign macc_results_bin = L2_macc_out_bin;

endmodule
