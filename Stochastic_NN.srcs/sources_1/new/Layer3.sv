// Layer 3 for stochastic NN, contains 10 Neurons with 32 inputs each
// contains hardocded weights and biases for each neuron. And LFSR seeds if used
// needs SNGs to generate weights and biases.
//
// Inputs: stochastic input data x32
// Outputs: stochastic results x10

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module Layer3(
    input clk,
    input reset,
    input data_in_stoch     [0:31],
    
    output results [0:9]
    );

    localparam NUM_NEUR = 10;
    localparam NUM_INP = 32;
    localparam NUM_WGHTS_UNQ = 123;


    // Wires for SNGs -> Neurons
    wire weights_stoch      [0:NUM_WGHTS_UNQ-1];
    wire bias_stoch         [0:NUM_NEUR-1];
    // Stoch output wires from neurons
    wire neurons_out_stoch  [0:NUM_NEUR-1];
    wire maccs_out_stoch    [0:NUM_NEUR-1];


    // Hardcoded biases and weights as bipolar int15 probabilities
    // 10 neurons => 10 biases
    reg [15:0] B_ARRAY_L3 [0:NUM_NEUR-1] = '{ 32752, 32770, 32770, 32749, 32779, 32782, 32765, 32758, 32776, 32772 };   // Changed to upscaled value

    // Unique weights values, 123
    reg [15:0] W_ARRAY_L3_unique [0:NUM_WGHTS_UNQ-1] = '{40448, 33792, 28160, 29952, 34816, 38656, 38912, 37376, 34048, 39424, 41984, 24576, 23552, 37632, 32768, 36352, 25344, 37120, 33536, 28416, 34560, 31744, 27136, 26112, 38400, 40192, 26368, 33024, 34304, 35072, 28928, 24064, 36096, 39680, 31488, 30976, 33280, 29440, 23808, 25088, 39936, 24832, 35328, 21760, 35840, 40704, 39168, 25600, 40960, 15872, 36864, 27648, 29696, 22528, 43008, 42240, 41472, 44032, 32000, 37888, 19968, 20736, 29184, 54016, 27904, 36608, 41216, 48128, 27392, 30720, 5632, 43520, 24320, 42752, 21504, 13568, 38144, 17920, 20480, 16896, 51712, 53248, 48896, 22016, 17152, 30208, 3840, 35584, 32256, 30464, 14848, 46848, 11776, 18176, 22272, 7168, 18432, 19712, 48384, 23296, 16640, 13824, 20224, 28672, 45312, 18944, 6912, 8192, 16384, 23040, 22784, 14080, 15616, 19200, 20992, 26880, 10240, 11008, 19456, 32512, 7936, 256, 7680};


    // Look-up table for indexes of stochastic wires
    reg [15:0] W_ARRAY_INDEX_LUT [0:NUM_NEUR-1][0:NUM_INP-1] = '{
        {33, 52, 11, 34, 12, 35, 36, 3, 37, 38, 0, 18, 53, 39, 4, 11, 19, 54, 5, 20, 79, 38, 13, 40, 52, 6, 7, 14, 41, 8, 9, 5},
        {80, 81, 55, 21, 12, 12, 56, 22, 37, 82, 11, 83, 57, 41, 58, 15, 12, 20, 42, 40, 33, 33, 42, 13, 43, 84, 1, 4, 2, 59, 60, 61},
        {23, 62, 1, 63, 44, 64, 22, 65, 59, 24, 24, 85, 35, 43, 86, 87, 66, 36, 2, 12, 45, 25, 25, 1, 67, 26, 54, 27, 14, 5, 68, 13},
        {16, 14, 69, 88, 13, 89, 5, 2, 18, 18, 28, 29, 24, 25, 16, 19, 46, 30, 45, 16, 17, 40, 2, 90, 30, 26, 0, 91, 1, 47, 6, 41},
        {48, 70, 92, 19, 26, 31, 31, 71, 8, 3, 93, 7, 71, 55, 16, 5, 6, 53, 38, 17, 5, 94, 34, 6, 72, 8, 95, 96, 10, 49, 97, 73},
        {74, 98, 57, 3, 75, 50, 3, 99, 47, 61, 11, 50, 2, 1, 67, 8, 28, 48, 100, 62, 18, 51, 29, 101, 48, 17, 102, 76, 73, 22, 103, 43},
        {13, 64, 9, 28, 104, 39, 1, 23, 7, 7, 49, 45, 105, 11, 8, 29, 106, 31, 56, 29, 44, 107, 69, 65, 39, 0, 108, 3, 70, 25, 22, 34},
        {10, 109, 72, 4, 10, 21, 49, 68, 2, 63, 10, 26, 19, 14, 17, 16, 44, 0, 27, 0, 15, 50, 23, 24, 0, 31, 37, 110, 0, 4, 76, 35},
        {77, 75, 51, 111, 78, 10, 15, 32, 32, 74, 23, 32, 21, 4, 21, 7, 46, 112, 113, 9, 2, 3, 9, 27, 58, 28, 36, 114, 77, 46, 7, 78},
        {115, 14, 47, 116, 32, 1, 27, 9, 60, 117, 6, 42, 118, 15, 17, 6, 30, 20, 119, 8, 120, 0, 20, 9, 121, 30, 15, 51, 66, 122, 4, 10}
    };

    wire W_ARRAY_wires [0:NUM_NEUR-1][0:NUM_INP-1];

    ////////////////////// SNGs for weights and biases ///////////////////////////
    // One LFSR for all 
    wire [15:0] rand_num_lfsr_wghts;
    LFSR16_Galois lfsr_wghts(
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (16'd19563),
        .parallel_out           (rand_num_lfsr_wghts)
    );

    genvar i, j;
    generate
        for (i=0; i<NUM_WGHTS_UNQ; i=i+1) begin
            // 123 SNGs for unique weights vals
            SNG16_noLFSR SNG_weights(
                .clk                (clk),
                .reset              (reset),
                .rand_num           (rand_num_lfsr_wghts),
                .prob               (W_ARRAY_L3_unique[i]),
                .stoch_num          (weights_stoch[i])
            );
        end
    endgenerate

    // Create array of weights from look-up table
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            for (j=0; j<NUM_INP; j=j+1) begin
                assign W_ARRAY_wires[i][j] = weights_stoch[ W_ARRAY_INDEX_LUT[i][j] ];
            end
        end
    endgenerate

    // Biases
    wire [15:0] rand_num_lfsr_biases;
    LFSR16_Galois lfsr_biases(
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (16'd28374),
        .parallel_out           (rand_num_lfsr_biases)
    );

    generate
        // 10 SNGs for biases
        for (i=0; i<NUM_NEUR; i=i+1) begin
            SNG16_noLFSR SNG_bias(
                .clk                (clk),
                .reset              (reset),
                .rand_num           (rand_num_lfsr_biases),
                .prob               (B_ARRAY_L3[i]),
                .stoch_num          (bias_stoch[i])
            );
        end
    endgenerate
    ///////////////////////////////////////////////////////////////////////////////////

    /////////////// SNGs for adder select lines //////////////////
    // Wire array for adder stages and bias, i.e. add1, add2, ... add8, add_bias
    wire add_sel_stoch [0:5];
    reg [15:0] adder_seeds [0:5] = '{14828, 48550, 59877, 26511, 4940, 15401};

    generate
        for (i=0; i<6; i=i+1) begin
            StochNumGen16 SNG_add_sel(
                .clk                (clk),
                .reset              (reset),
                .seed               (adder_seeds[i]),
                .prob               (16'h8000),         // 0.5 unipolar, 0 bipolar
                .stoch_num          (add_sel_stoch[i])
            );
        end
    endgenerate
    //////////////////////////////////////////////////////////////


    // Generate 10 neurons
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            Neuron32_L3 neur_l3(
                .clk                (clk),
                .reset              (reset),
                .input_data         (data_in_stoch),
                .weights            (W_ARRAY_wires[i]),     // Get weight value by index into LUT
                .bias               (bias_stoch[i]),
                .add_sel            (add_sel_stoch),

                .result             (neurons_out_stoch[i]),
                .macc_out           (maccs_out_stoch[i])
            );
        end
    endgenerate

    assign results = neurons_out_stoch;

endmodule
