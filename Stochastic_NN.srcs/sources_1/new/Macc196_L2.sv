// Bipolar stochastic multiply-accumulate module for 196 inputs
// Input: 196 stochastic inputs, 196 stochastic weights
// Output: 1 stochastic number = sum(x[i]*w[i])

module Macc196_L2(
    input clk,
    input reset,
    input input_data    [0:195],
    input weights       [0:195],
    
    output result
    );

    // Consts
    localparam NUM_INPS = 196;
    localparam NUM_ADDS_1 = 98;
    localparam NUM_ADDS_2 = 49;
    localparam NUM_ADDS_3 = 24;
    localparam NUM_ADDS_4 = 12;
    localparam NUM_ADDS_5 = 6;
    localparam NUM_ADDS_6 = 3;
    localparam NUM_ADDS_7 = 2;

    // Internal wires
    wire mul_out    [0:NUM_INPS-1];
    wire add1_res   [0:NUM_ADDS_1-1];
    wire add2_res   [0:NUM_ADDS_2-1];
    wire add3_res   [0:NUM_ADDS_3-1];
    wire add4_res   [0:NUM_ADDS_4-1];
    wire add5_res   [0:NUM_ADDS_5-1];
    wire add6_res   [0:NUM_ADDS_6-1];
    wire add7_res   [0:NUM_ADDS_7-1];      // Add remainder of stage 3 here


    // Multipliers - 196 XNOR gates
    genvar i;
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            Mult_bi mu (
                .stoch_num1             (input_data[i]),
                .stoch_num2             (weights[i]),
                .stoch_res              (mul_out[i])
            );
        end
    endgenerate

    // Adders stage 1 - 98 MUXes
    //reg [7:0] LFSR_seeds_add1 [0:3] = '{150, 118, 250, 58};
    reg [7:0] LFSR_add1_seed = 8'd132;
    generate
        for (i=0; i<NUM_ADDS_1; i=i+1) begin
            Adder add1 (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add1_seed),
                .stoch_num1             (mul_out[i*2]),
                .stoch_num2             (mul_out[(i*2)+1]),
                .result_stoch           (add1_res[i])
            );
        end
    endgenerate

    // Adders stage 2 - 49 MUXes
    reg [7:0] LFSR_add2_seed = 8'd191;
    generate
        for (i=0; i<NUM_ADDS_2; i=i+1) begin
            Adder add2 (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add2_seed),
                .stoch_num1             (add1_res[i*2]),
                .stoch_num2             (add1_res[(i*2)+1]),
                .result_stoch           (add2_res[i])
            );
        end
    endgenerate

    // Adders stage 3 - 24 MUXes
    reg [7:0] LFSR_add3_seed = 8'd82;
    generate
        for (i=0; i<NUM_ADDS_3; i=i+1) begin
            Adder add3 (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add3_seed),
                .stoch_num1             (add2_res[i*2]),
                .stoch_num2             (add2_res[(i*2)+1]),
                .result_stoch           (add3_res[i])
            );
        end
    endgenerate

    // Adders stage 4 - 12 MUXes
    reg [7:0] LFSR_add4_seed = 8'd181;
    generate
        for (i=0; i<NUM_ADDS_4; i=i+1) begin
            Adder add4 (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add4_seed),
                .stoch_num1             (add3_res[i*2]),
                .stoch_num2             (add3_res[(i*2)+1]),
                .result_stoch           (add4_res[i])
            );
        end
    endgenerate

    // Adders stage 5 - 6 MUXes
    reg [7:0] LFSR_add5_seed = 8'd99;
    generate
        for (i=0; i<NUM_ADDS_4; i=i+1) begin
            Adder add5 (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add5_seed),
                .stoch_num1             (add4_res[i*2]),
                .stoch_num2             (add4_res[(i*2)+1]),
                .result_stoch           (add5_res[i])
            );
        end
    endgenerate

    // Adders stage 6 - 3 MUXes
    reg [7:0] LFSR_add6_seed = 8'd25;
    generate
        for (i=0; i<NUM_ADDS_5; i=i+1) begin
            Adder add6 (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add6_seed),
                .stoch_num1             (add5_res[i*2]),
                .stoch_num2             (add5_res[(i*2)+1]),
                .result_stoch           (add6_res[i])
            );
        end
    endgenerate

    // Adders stage 7 - 2 MUXes
    // Note: Last output of stage 2 adds is added in second MUX here
    reg [7:0] LFSR_add7_seed = 8'd79;
    Adder add7_1 (
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (LFSR_add7_seed),
        .stoch_num1             (add6_res[0]),
        .stoch_num2             (add6_res[1]),
        .result_stoch           (add7_res[0])
    );
    Adder add7_2 (
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (LFSR_add7_seed),
        .stoch_num1             (add6_res[2]),
        .stoch_num2             (add2_res[48]),
        .result_stoch           (add7_res[1])
    );

    // Last adder - 1 MUX
    Adder add8 (
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (8'd58),
        .stoch_num1             (add7_res[0]),
        .stoch_num2             (add7_res[1]),
        .result_stoch           (result)
    );


endmodule
