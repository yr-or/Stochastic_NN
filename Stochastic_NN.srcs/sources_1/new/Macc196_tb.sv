// Testbench for Macc196, provides input stimulus and checks outputs
// Input: Binary values for data and weights
// Output: Binary value from STB and debug lines

module Macc196_tb(
    input clk,
    input reset,
    input [15:0] input_values    [0:195],
    input [15:0] weights         [0:195],

    output [15:0] mac_res_bin,
    output done,
    // debug
    output [15:0] add1_res_bin [0:97],   // Debug wire
    output [15:0] add2_res_bin [0:48],
    output [15:0] add3_res_bin [0:23],
    output [15:0] add4_res_bin [0:11],
    output [15:0] add5_res_bin [0:5],
    output [15:0] add6_res_bin [0:2],
    output [15:0] add7_res_bin [0:1]
    );

    // Stochastic wires
    wire inps_stoch     [0:195];
    wire weights_stoch  [0:195];
    wire mac_out_stoch;

    wire add1_res_stoch [0:97];
    wire add2_res_stoch [0:48];
    wire add3_res_stoch [0:23];
    wire add4_res_stoch [0:11];
    wire add5_res_stoch [0:5];
    wire add6_res_stoch [0:2];
    wire add7_res_stoch [0:1];

    // LFSR seeds - 2 for all values
    reg [15:0] LFSR_inps_seed = 16'd25645;
    reg [15:0] LFSR_wghts_seed = 16'd57842;
    reg [15:0] LFSR_bias_seed = 16'd37483;

    // Generate stochastic inputs
    genvar i;
    generate
        for (i=0; i<196; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR_inps_seed),
                .prob           (input_values[i]),
                .stoch_num      (inps_stoch[i])
            );
        end
    endgenerate

    // Generate stochastic weights
    generate
        for (i=0; i<196; i=i+1) begin
            StochNumGen16 SNG_weights(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR_wghts_seed),
                .prob           (weights[i]),
                .stoch_num      (weights_stoch[i])
            );
        end
    endgenerate

    /////////////// SNGs for adder select lines //////////////////
    // Wire array for adder stages and bias, i.e. add1, add2, ... add8, + 4 for the add2 fix + 1 for zero val
    wire add_sel_stoch [0:12];
    reg [15:0] adder_seeds [0:12] = '{49449, 65515, 49141, 34104, 65172, 23739, 62006, 39009, 47385, 20948, 19473, 48533, 29342};
    generate
        for (i=0; i<13; i=i+1) begin
            StochNumGen16 SNG_add_sel(
                .clk                (clk),
                .reset              (reset),
                .seed               (adder_seeds[i]),
                .prob               (16'h8000),     // 0.5
                .stoch_num          (add_sel_stoch[i])
            );
        end
    endgenerate
    //////////////////////////////////////////////////////////////


    // Macc module
    Macc196_L2 MAC(
        .clk                (clk),
        .reset              (reset),
        .input_data         (inps_stoch),
        .weights            (weights_stoch),
        .add_sel            (add_sel_stoch),

        .result             (mac_out_stoch),
        // Debug wires
        .add1_res_stoch     (add1_res_stoch),
        .add2_res_stoch     (add2_res_stoch),
        .add3_res_stoch     (add3_res_stoch),
        .add4_res_stoch     (add4_res_stoch),
        .add5_res_stoch     (add5_res_stoch),
        .add6_res_stoch     (add6_res_stoch),
        .add7_res_stoch     (add7_res_stoch)
    );

    // STB output
    StochToBin16 STB(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (mac_out_stoch),
        .bin_number         (mac_res_bin),
        .done               (done)
    );


    //////// STBs for adder stages result /////////
    // Consts
    localparam NUM_ADDS_1 = 98;
    localparam NUM_ADDS_2 = 49;
    localparam NUM_ADDS_3 = 24;
    localparam NUM_ADDS_4 = 12;
    localparam NUM_ADDS_5 = 6;
    localparam NUM_ADDS_6 = 3;
    localparam NUM_ADDS_7 = 2;
    generate
        for (i=0; i<NUM_ADDS_1; i=i+1) begin
            StochToBin16 stb_add1(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add1_res_stoch[i]),
                .bin_number         (add1_res_bin[i])
            );
        end
    endgenerate
    generate
        for (i=0; i<NUM_ADDS_2; i=i+1) begin
            StochToBin16 stb_add2(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add2_res_stoch[i]),
                .bin_number         (add2_res_bin[i])
            );
        end
    endgenerate
    generate
        for (i=0; i<NUM_ADDS_3; i=i+1) begin
            StochToBin16 stb_add3(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add3_res_stoch[i]),
                .bin_number         (add3_res_bin[i])
            );
        end
    endgenerate
    generate
        for (i=0; i<NUM_ADDS_4; i=i+1) begin
            StochToBin16 stb_add4(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add4_res_stoch[i]),
                .bin_number         (add4_res_bin[i])
            );
        end
    endgenerate
    generate
        for (i=0; i<NUM_ADDS_5; i=i+1) begin
            StochToBin16 stb_add5(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add5_res_stoch[i]),
                .bin_number         (add5_res_bin[i])
            );
        end
    endgenerate
    generate
        for (i=0; i<NUM_ADDS_6; i=i+1) begin
            StochToBin16 stb_add6(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add6_res_stoch[i]),
                .bin_number         (add6_res_bin[i])
            );
        end
    endgenerate
    generate
        for (i=0; i<NUM_ADDS_7; i=i+1) begin
            StochToBin16 stb_add7(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (add7_res_stoch[i]),
                .bin_number         (add7_res_bin[i])
            );
        end
    endgenerate


endmodule
