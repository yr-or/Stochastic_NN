// Layer 3 for stochastic NN, contains 10 Neurons with 32 inputs each
// contains hardocded weights and biases for each neuron. And LFSR seeds if used
// needs SNGs to generate weights and biases.
//
// Inputs: stochastic input data x32
// Outputs: stochastic results x10

module Layer3(
    input clk,
    input reset,
    input data_in_stoch     [0:31],
    
    output [15:0] results_bin [0:9],
    output done
    );

    localparam NUM_NEUR = 10;
    localparam NUM_INP = 32;

    // Wires for SNGs -> Neurons
    wire weights_stoch      [0:NUM_NEUR-1][0:NUM_INP-1];
    wire bias_stoch         [0:NUM_NEUR-1];
    // Stoch output wires from neurons
    wire neurons_out_stoch  [0:NUM_NEUR-1];
    wire maccs_out_stoch    [0:NUM_NEUR-1];


    // Hardcoded biases and weights as bipolar int15 probabilities
    // 10 neurons => 10 biases
    reg [15:0] B_ARRAY_L3 [0:NUM_NEUR-1] = '{ 32512, 32768, 32768, 32512, 32768, 32768, 32512, 32512, 32768, 32768 };

    // 10 neurons x 32 inputs => 10x32 weights
    reg [15:0] W_ARRAY_L3 [0:NUM_NEUR-1][0:NUM_INP-1] = '{
        { 39680, 29696, 24576, 31488, 23552, 30976, 33280, 29952, 29440, 23808, 40448, 33536, 22528, 25088, 34816, 24576, 28416, 43008, 38656, 34560, 16896, 23808, 37632, 39936, 29696, 38912, 37376, 32768, 24832, 34048, 39424, 38656 },
        { 51712, 53248, 42240, 31744, 23552, 23552, 41472, 27136, 29440, 48896, 24576, 22016, 44032, 24832, 32000, 36352, 23552, 34560, 35328, 39936, 39680, 39680, 35328, 37632, 21760, 17152, 33792, 34816, 28160, 37888, 19968, 20736 },
        { 26112, 29184, 33792, 54016, 35840, 27904, 27136, 36608, 37888, 38400, 38400, 30208, 30976, 21760, 3840, 35584, 41216, 33280, 28160, 23552, 40704, 40192, 40192, 33792, 48128, 26368, 43008, 33024, 32768, 38656, 27392, 37632 },
        { 25344, 32768, 30720, 32256, 37632, 30464, 38656, 28160, 33536, 33536, 34304, 35072, 38400, 40192, 25344, 28416, 39168, 28928, 40704, 25344, 37120, 39936, 28160, 14848, 28928, 26368, 40448, 46848, 33792, 25600, 38912, 24832 },
        { 40960, 5632, 11776, 28416, 26368, 24064, 24064, 43520, 34048, 29952, 18176, 37376, 43520, 42240, 25344, 38656, 38912, 22528, 23808, 37120, 38656, 22272, 31488, 38912, 24320, 34048, 7168, 18432, 41984, 15872, 19712, 42752 },
        { 21504, 48384, 44032, 29952, 13568, 36864, 29952, 23296, 25600, 20736, 24576, 36864, 28160, 33792, 48128, 34048, 34304, 40960, 16640, 29184, 33536, 27648, 35072, 13824, 40960, 37120, 20224, 38144, 42752, 27136, 28672, 21760 },
        { 37632, 27904, 39424, 34304, 45312, 25088, 33792, 26112, 37376, 37376, 15872, 40704, 18944, 24576, 34048, 35072, 6912, 24064, 41472, 35072, 35840, 8192, 30720, 36608, 25088, 40448, 16384, 29952, 5632, 40192, 27136, 31488 },
        { 41984, 23040, 24320, 34816, 41984, 31744, 15872, 27392, 28160, 54016, 41984, 26368, 28416, 32768, 37120, 25344, 35840, 40448, 33024, 40448, 36352, 36864, 26112, 38400, 40448, 24064, 29440, 22784, 40448, 34816, 38144, 30976 },
        { 17920, 13568, 27648, 14080, 20480, 41984, 36352, 36096, 36096, 21504, 26112, 36096, 31744, 34816, 31744, 37376, 39168, 15616, 19200, 39424, 28160, 29952, 39424, 33024, 32000, 34304, 33280, 20992, 17920, 39168, 37376, 20480 },
        { 26880, 32768, 25600, 10240, 36096, 33792, 33024, 39424, 19968, 11008, 38912, 35328, 19456, 36352, 37120, 38912, 28928, 34560, 32512, 34048, 7936, 40448, 34560, 39424, 256, 28928, 36352, 27648, 41216, 7680, 34816, 41984 }
    };

    // SNGs for weights and biases
    genvar i, j;
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            for (j=0; j<NUM_INP; j=j+1) begin
                // 10x32 SNGs for weights
                StochNumGen16 SNG_weights(
                    .clk                (clk),
                    .reset              (reset),
                    .seed               (16'd19563),       // Using same value for all
                    .prob               (W_ARRAY_L3[i][j]),
                    .stoch_num          (weights_stoch[i][j])
                );
            end
        end
    endgenerate

    generate
        // 10 SNGs for biases
        for (i=0; i<NUM_NEUR; i=i+1) begin
            StochNumGen16 SNG_bias(
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd28374),       // Using same value for all
                .prob               (B_ARRAY_L3[i]),
                .stoch_num          (bias_stoch[i])
            );
        end
    endgenerate

    // Generate 10 neurons
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            Neuron32_L3 neur_l3(
                .clk                (clk),
                .reset              (reset),
                .input_data         (data_in_stoch),
                .weights            (weights_stoch[i]),
                .bias               (bias_stoch[i]),
                .result             (neurons_out_stoch[i]),
                .macc_out           (maccs_out_stoch[i])
            );
        end
    endgenerate

    // STB Layer 3 results DEBUG
    reg [9:0] done_stb_array;
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
                StochToBin16 stb_L3( 
                    .clk                (clk),
                    .reset              (reset),
                    .enable             (1'b1),
                    .bit_stream         (neurons_out_stoch[i]),
                    .bin_number         (results_bin[i]),
                    .done               (done_stb_array[i])
                );
        end
    endgenerate

    assign done = &(done_stb_array);

endmodule
