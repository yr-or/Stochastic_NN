// Bipolar stochastic multiply-accumulate module for 196 inputs
// Input: 196 stochastic inputs, 196 stochastic weights
// Output: 1 stochastic number = sum(x[i]*w[i])

module Macc196_L2(
    input clk,
    input reset,
    input input_data    [0:195],
    input weights       [0:195],
    input add_sel       [0:12],
    
    output result,
    /////////// Debug wires /////////////
    output mul_out_stoch  [0:195],
    output add1_res_stoch [0:97],
    output add2_res_stoch [0:48],
    output add3_res_stoch [0:23],
    output add4_res_stoch [0:11],
    output add5_res_stoch [0:5],
    output add6_res_stoch [0:2],
    output add7_res_stoch [0:1]
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

    assign mul_out_stoch = mul_out;
    assign add1_res_stoch = add1_res;
    assign add2_res_stoch = add2_res;
    assign add3_res_stoch = add3_res;
    assign add4_res_stoch = add4_res;
    assign add5_res_stoch = add5_res;
    assign add6_res_stoch = add6_res;
    assign add7_res_stoch = add7_res;

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

    // Adder_noSNGs stage 1 - 98 MUXes
    generate
        for (i=0; i<NUM_ADDS_1; i=i+1) begin
            Adder_noSNG add1 (
                .sel                    (add_sel[0]),
                .stoch_num1             (mul_out[i*2]),
                .stoch_num2             (mul_out[(i*2)+1]),
                .result_stoch           (add1_res[i])
            );
        end
    endgenerate

    // Adder_noSNGs stage 2 - 49 MUXes
    generate
        for (i=0; i<NUM_ADDS_2; i=i+1) begin
            Adder_noSNG add2 (
                .sel                    (add_sel[1]),
                .stoch_num1             (add1_res[i*2]),
                .stoch_num2             (add1_res[(i*2)+1]),
                .result_stoch           (add2_res[i])
            );
        end
    endgenerate

    // Adder_noSNGs stage 3 - 24 MUXes
    generate
        for (i=0; i<NUM_ADDS_3; i=i+1) begin
            Adder_noSNG add3 (
                .sel                    (add_sel[2]),
                .stoch_num1             (add2_res[i*2]),
                .stoch_num2             (add2_res[(i*2)+1]),
                .result_stoch           (add3_res[i])
            );
        end
    endgenerate

    // Adder_noSNGs stage 4 - 12 MUXes
    generate
        for (i=0; i<NUM_ADDS_4; i=i+1) begin
            Adder_noSNG add4 (
                .sel                    (add_sel[3]),
                .stoch_num1             (add3_res[i*2]),
                .stoch_num2             (add3_res[(i*2)+1]),
                .result_stoch           (add4_res[i])
            );
        end
    endgenerate

    // Adder_noSNGs stage 5 - 6 MUXes
    reg [15:0] LFSR_add5_seed = 16'd1456;
    generate
        for (i=0; i<NUM_ADDS_5; i=i+1) begin
            Adder_noSNG add5 (
                .sel                    (add_sel[4]),
                .stoch_num1             (add4_res[i*2]),
                .stoch_num2             (add4_res[(i*2)+1]),
                .result_stoch           (add5_res[i])
            );
        end
    endgenerate

    // Adder_noSNGs stage 6 - 3 MUXes
    reg [15:0] LFSR_add6_seed = 16'd2568;
    generate
        for (i=0; i<NUM_ADDS_6; i=i+1) begin
            Adder_noSNG add6 (
                .sel                    (add_sel[5]),
                .stoch_num1             (add5_res[i*2]),
                .stoch_num2             (add5_res[(i*2)+1]),
                .result_stoch           (add6_res[i])
            );
        end
    endgenerate

    //////////////////////////////////////////////////////////////////////////
    ////// Scale output 48 of add2 so that it adds correctly in stage 7 //////
    
    (* MARK_DEBUG = "TRUE" *) wire add2_res48_s1;
    (* MARK_DEBUG = "TRUE" *) wire add2_res48_s2;
    (* MARK_DEBUG = "TRUE" *) wire add2_res48_s3;
    (* MARK_DEBUG = "TRUE" *) wire add2_res48_s4;
    // Add bipolar zero value with add2[48] 4 times
    // Bipolar 0 = 0.5 unipolar, so can just use sel line
    Adder_noSNG add2_scale1 (
        .sel                    (add_sel[8]),
        .stoch_num1             (add_sel[12]),
        .stoch_num2             (add2_res[48]),
        .result_stoch           (add2_res48_s1)
    );
    Adder_noSNG add2_scale2 (
        .sel                    (add_sel[9]),
        .stoch_num1             (add_sel[12]),
        .stoch_num2             (add2_res48_s1),
        .result_stoch           (add2_res48_s2)
    );
    Adder_noSNG add2_scale3 (
        .sel                    (add_sel[10]),
        .stoch_num1             (add_sel[12]),
        .stoch_num2             (add2_res48_s2),
        .result_stoch           (add2_res48_s3)
    );
    Adder_noSNG add2_scale4 (
        .sel                    (add_sel[11]),
        .stoch_num1             (add_sel[12]),
        .stoch_num2             (add2_res48_s3),
        .result_stoch           (add2_res48_s4)
    );
    ////////////////////////////////////////////////////////////////////////////
    

    // Adder_noSNGs stage 7 - 2 MUXes
    // Note: Last output of stage 2 adds is added in second MUX here
    reg [15:0] LFSR_add7_seed = 16'd1412;
    Adder_noSNG add7_1 (
        .sel                    (add_sel[6]),
        .stoch_num1             (add6_res[0]),
        .stoch_num2             (add6_res[1]),
        .result_stoch           (add7_res[0])
    );
    Adder_noSNG add7_2 (
        .sel                    (add_sel[6]),
        .stoch_num1             (add6_res[2]),
        .stoch_num2             (add2_res48_s4),        // Changed to scaled value
        .result_stoch           (add7_res[1])
    );

    // Last adder - 1 MUX
    Adder_noSNG add8 (
        .sel                    (add_sel[7]),
        .stoch_num1             (add7_res[0]),
        .stoch_num2             (add7_res[1]),
        .result_stoch           (result)
    );


endmodule
