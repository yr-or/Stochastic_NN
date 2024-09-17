// Top level synthesis testbench for testing different digits of data
// Plan: Load 100 digits into RAM and test each one sequentially
// recording result of each test into an array

module NN_test_data_single(
    input sys_clk
    );

    localparam NUM_TESTS = 100;

    wire reset;
    wire clk;
    wire fast_clk;
    wire locked;

    clk_wiz_0 clkwiz (
        .clk_in1            (sys_clk),
        .reset              (1'b0),
        .clk_out1           (clk),
        .clk_out2           (fast_clk),
        .locked             (locked)
    );

    // outputs of NN
    wire [15:0] L2_res_bin [0:31];     // Upscaled and regend
    wire [15:0] L3_res_bin [0:9];
    wire done_regen;
    wire done_L3;
    wire [3:0] digit_res;
    wire done_max;
    reg [15:0] input_data_bin [0:195];

    // DUT
    NN_top NN_top(
        .clk                    (clk),
        .reset                  (reset),
        .input_data_bin         (input_data_bin),
        
        .L2_res_bin             (L2_res_bin),
        .L3_res_bin             (L3_res_bin),
        .done_regen             (done_regen),
        .done                   (done_L3),
        .max_ind                (digit_res),
        .done_max               (done_max)
    );

    // Test block signals
    wire [7:0] test_ind;
    wire [3:0] label;

    // Test block
    test_data tester(
        .clk                    (clk),
        .addr                   (test_ind),
        .data                   (input_data_bin),
        .label                  (label)
    );
    
    // VIO
    vio_test1 vio_NN2(
        .clk                    (fast_clk),
        .probe_out0             (reset),
        .probe_out1             (test_ind)
    );

    // ILA
    ila_test1 ila_NN2(
        .clk                    (fast_clk),
        .probe0                 (done_max),
        .probe1                 (label),
        .probe2                 (digit_res),
        .probe3                 (test_ind)
    );

endmodule
