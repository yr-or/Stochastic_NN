// Testbench for Neuron196_L2, generate stoch nums and convert outputs
// Inputs: Stochastic inputs, weights and bias
// Output: 8-bit binary result

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module Neuron196_L2_tb(
    input clk,
    input reset,
    input [15:0] input_data_bin  [0:195],
    input [15:0] weights_bin     [0:195],
    input [15:0] bias_bin,

    output [15:0] result_bin,
    output [15:0] macc_result_bin,
    output [15:0] bias_out_bin,

    /////////// Debug wires /////////////
    output [15:0] add1_res_bin [0:97],
    output [15:0] add2_res_bin [0:48],
    output [15:0] add3_res_bin [0:23],
    output [15:0] add4_res_bin [0:11],
    output [15:0] add5_res_bin [0:5],
    output [15:0] add6_res_bin [0:2],
    output [15:0] add7_res_bin [0:1],

    output done
    );

    // Debug
    reg [15:0] LFSR1_seed = 16'd25645;
    reg [15:0] LFSR2_seed = 16'd57842;

    // Stochastic inputs
    wire inps_stoch       [0:NUM_INPS-1];
    wire weights_stoch    [0:NUM_INPS-1];
    wire bias_stoch;

    // Stochastic outputs
    wire neur_result_stoch;
    wire macc_out_stoch;
    wire bias_out_stoch;
    // Debug wires
    wire add1_res_stoch [0:97];
    wire add2_res_stoch [0:48];
    wire add3_res_stoch [0:23];
    wire add4_res_stoch [0:11];
    wire add5_res_stoch [0:5];
    wire add6_res_stoch [0:2];
    wire add7_res_stoch [0:1];

    // Consts
    localparam NUM_INPS = 196;
    localparam NUM_ADDS_1 = 98;
    localparam NUM_ADDS_2 = 49;
    localparam NUM_ADDS_3 = 24;
    localparam NUM_ADDS_4 = 12;
    localparam NUM_ADDS_5 = 6;
    localparam NUM_ADDS_6 = 3;
    localparam NUM_ADDS_7 = 2;


    // Generate stochastic inputs
    genvar i;
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR1_seed),
                .prob           (input_data_bin[i]),
                .stoch_num      (inps_stoch[i])
            );
        end
    endgenerate

    // Generate stochastic weights
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochNumGen16 SNG_weights(
                .clk            (clk),
                .reset          (reset),
                .seed           (LFSR2_seed),
                .prob           (weights_bin[i]),
                .stoch_num      (weights_stoch[i])
            );
        end
    endgenerate

    // Generate bias stoch num
    StochNumGen16 SNG_bias(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd37483),           // Changed from 8 to 16 bits
        .prob               (bias_bin),
        .stoch_num          (bias_stoch)
    );

    /////////////// SNGs for adder select lines //////////////////
    // Wire array for adder stages and bias, i.e. add1, add2, ... add8, add_bias
    wire add_sel_stoch [0:8];
    reg [15:0] adder_seeds [0:8] = '{49449, 65515, 49141, 34104, 65172, 23739, 62006, 39009, 47385};

    generate
        for (i=0; i<9; i=i+1) begin
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

    // Neuron
    Neuron196_L2 neur_L2(
        .clk                (clk),
        .reset              (reset),
        .input_data         (inps_stoch),
        .weights            (weights_stoch),
        .bias               (bias_stoch),
        .add_sel            (add_sel_stoch),

        .macc_out           (macc_out_stoch),
        .add1_res_stoch     (add1_res_stoch),
        .add2_res_stoch     (add2_res_stoch),
        .add3_res_stoch     (add3_res_stoch),
        .add4_res_stoch     (add4_res_stoch),
        .add5_res_stoch     (add5_res_stoch),
        .add6_res_stoch     (add6_res_stoch),
        .add7_res_stoch     (add7_res_stoch),
        .bias_out           (bias_out_stoch),
        .result             (neur_result_stoch)
    );

    // STB output
    StochToBin16 STB_res(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (neur_result_stoch),
        .bin_number         (result_bin),
        .done               (done)
    );

    // STB for macc result
    StochToBin16 stb_macc(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (macc_out_stoch),
        .bin_number         (macc_result_bin)
    );

    //////// STBs for adder stages result /////////
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

    // STB bias result
    StochToBin16 stb_bias(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (bias_out_stoch),
        .bin_number         (bias_out_bin)
    );

endmodule
