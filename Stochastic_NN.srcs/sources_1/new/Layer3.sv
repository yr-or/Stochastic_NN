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
    
    output macc_results     [0:9],
    output results          [0:9]
    );

    localparam NUM_NEUR = 10;
    localparam NUM_INP = 32;

    // Wires for SNGs -> Neurons
    wire weights_stoch      [0:NUM_NEUR-1][0:NUM_INP-1];
    wire bias_stoch         [0:NUM_NEUR-1];
    // Stoch output wires from neurons
    wire neurons_out_stoch  [0:NUM_NEUR-1];
    wire maccs_out_stoch [0:NUM_NEUR-1];


    // Hardcoded biases and weights as bipolar int8 probabilities
    // 10 neurons => 10 biases
    reg [7:0] B_ARRAY_L3 [0:NUM_NEUR-1] = '{ 112, 130, 130, 109, 139, 142, 125, 118, 136, 132 };

    // 10 neurons x 32 inputs => 10x32 weights
    reg [7:0] W_ARRAY_L3 [0:NUM_NEUR-1][0:NUM_INP-1] = '{
        { 155, 116, 96, 123, 92, 121, 130, 117, 115, 93, 158, 131, 88, 98, 136, 96, 111, 168, 151, 135, 66, 93, 147, 156, 116, 152, 146, 128, 97, 133, 154, 151 },
        { 202, 208, 165, 124, 92, 92, 162, 106, 115, 191, 96, 86, 172, 97, 125, 142, 92, 135, 138, 156, 155, 155, 138, 147, 85, 67, 132, 136, 110, 148, 78, 81 },
        { 102, 114, 132, 211, 140, 109, 106, 143, 148, 150, 150, 118, 121, 85, 15, 139, 161, 130, 110, 92, 159, 157, 157, 132, 188, 103, 168, 129, 128, 151, 107, 147 },
        { 99, 128, 120, 126, 147, 119, 151, 110, 131, 131, 134, 137, 150, 157, 99, 111, 153, 113, 159, 99, 145, 156, 110, 58, 113, 103, 158, 183, 132, 100, 152, 97 },
        { 160, 22, 46, 111, 103, 94, 94, 170, 133, 117, 71, 146, 170, 165, 99, 151, 152, 88, 93, 145, 151, 87, 123, 152, 95, 133, 28, 72, 164, 62, 77, 167 },
        { 84, 189, 172, 117, 53, 144, 117, 91, 100, 81, 96, 144, 110, 132, 188, 133, 134, 160, 65, 114, 131, 108, 137, 54, 160, 145, 79, 149, 167, 106, 112, 85 },
        { 147, 109, 154, 134, 177, 98, 132, 102, 146, 146, 62, 159, 74, 96, 133, 137, 27, 94, 162, 137, 140, 32, 120, 143, 98, 158, 64, 117, 22, 157, 106, 123 },
        { 164, 90, 95, 136, 164, 124, 62, 107, 110, 211, 164, 103, 111, 128, 145, 99, 140, 158, 129, 158, 142, 144, 102, 150, 158, 94, 115, 89, 158, 136, 149, 121 },
        { 70, 53, 108, 55, 80, 164, 142, 141, 141, 84, 102, 141, 124, 136, 124, 146, 153, 61, 75, 154, 110, 117, 154, 129, 125, 134, 130, 82, 70, 153, 146, 80 },
        { 105, 128, 100, 40, 141, 132, 129, 154, 78, 43, 152, 138, 76, 142, 145, 152, 113, 135, 127, 133, 31, 158, 135, 154, 1, 113, 142, 108, 161, 30, 136, 164 }
    };

    // SNGs for weights and biases
    genvar i, j;
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            for (j=0; j<NUM_INP; j=j+1) begin
                // 10x32 SNGs for weights
                StochNumGen SNG_weights(
                    .clk                (clk),
                    .reset              (reset),
                    .seed               (8'd134),       // Using same value for all
                    .prob               (W_ARRAY_L3[i][j]),
                    .stoch_num          (weights_stoch[i][j])
                );
            end
        end
    endgenerate

    generate
        // 10 SNGs for biases
        for (i=0; i<NUM_NEUR; i=i+1) begin
            StochNumGen SNG_bias(
                .clk                (clk),
                .reset              (reset),
                .seed               (8'd132),       // Using same value for all
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

    assign results = neurons_out_stoch;
    assign macc_results = maccs_out_stoch;

endmodule
