// **Unipolar** stochastic multiply-accumulate module for 32 inputs
// Input: 32 stochastic inputs, 32 stochastic weights
// Output: 1 stochastic number = sum(x[i]*w[i])

module Macc32_L3(
    input clk,
    input reset,
    input input_data    [0:31],
    input weights       [0:31],
    
    output result
    );

    // Consts
    localparam NUM_INPS = 32;
    localparam NUM_ADDS_1 = 16;
    localparam NUM_ADDS_2 = 8;
    localparam NUM_ADDS_3 = 4;
    localparam NUM_ADDS_4 = 2;

    // Internal wires
    wire mul_out    [0:NUM_INPS-1];
    wire add1_res   [0:NUM_ADDS_1-1];
    wire add2_res   [0:NUM_ADDS_2-1];
    wire add3_res   [0:NUM_ADDS_3-1];
    wire add4_res   [0:NUM_ADDS_4-1];


    // BIPOLAR Multipliers - 32 XNOR gates
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

    // Adders: Each adder stage shares a single LFSR seed
    // Adders stage 1 - 16 MUXes
    reg [15:0] LFSR_add1_seed = 16'd19384;
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

    // Adders stage 2 - 8 MUXes
    reg [15:0] LFSR_add2_seed = 16'd29343;
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

    // Adders stage 3 - 4 MUXes
    reg [15:0] LFSR_add3_seed = 16'd18273;
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

    // Adders stage 4 - 2 MUXes
    reg [15:0] LFSR_add4_seed = 16'd57483;
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

    // Last adder - 1 MUX
    Adder add5 (
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (16'd28347),
        .stoch_num1             (add4_res[0]),
        .stoch_num2             (add4_res[1]),
        .result_stoch           (result)
    );

endmodule
