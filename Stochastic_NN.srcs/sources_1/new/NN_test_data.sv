// Top level synthesis testbench for testing different digits of data
// Plan: Load 100 digits into RAM and test each one sequentially
// recording result of each test into an array

module NN_test_data(
    input sys_clk
    );

    localparam NUM_TESTS = 100;

    reg reset;
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
    wire reset_test;
    reg [7:0] test_ind = 8'd0;
    wire [3:0] label;

    // Test block
    test_data tester(
        .clk                    (clk),
        .addr                   (test_ind),
        .data                   (input_data_bin),
        .label                  (label)
    );

    // Test control signals
    wire [7:0] correct_pred;

    // Code to sequentially read data and write result to array here
    // FSM States
    parameter STATE0 = 3'b000;      // Initialise state
    parameter STATE1 = 3'b001;      // Running state
    parameter STATE2 = 3'b010;      // Finished state

    // State variables
    reg state_ff;        // 2 states
    reg next_state;

    // Internal wires / regs
    reg [7:0] corr_res;
    reg [7:0] corr_res_ff;
    reg done_test;
    reg done_test_ff;
    reg test_ind_inc;

    // Sequential logic for going to next state
    always @(posedge clk) begin
        if (reset_test) begin
            state_ff <= STATE0;
        end else begin
            state_ff <= next_state;
        end
    end

    // Combinational logic for states
    always @(*) begin
        case(state_ff)
            STATE0 : begin                  // Initialise
                reset = 1;
                corr_res = 0;
                test_ind_inc = 0;
                // Get next image from ROM
                if (test_ind < NUM_TESTS) begin
                    next_state = STATE1;
                    done_test = 0;
                end
                else begin
                    done_test = 1;
                    next_state = STATE0;
                end
            end
            STATE1 : begin                  // Run NN
                reset = 0;
                done_test = 0;
                if (done_max) begin
                    // Add result to counter
                    if (digit_res == label) begin
                        corr_res = 1;
                    end else begin
                        corr_res = 0;
                    end
                    test_ind_inc = 1;
                    next_state = STATE0;    // Reset and start again
                end
                else begin
                    corr_res = 0;
                    test_ind_inc = 0;
                    next_state = STATE1;    // Stay on same state until done_max
                end
            end
            default : begin
                reset = 1;
                next_state = STATE0;
            end
        endcase
    end

    // Register output
    always @(posedge clk) begin
        if (reset_test) begin
            corr_res_ff <= 8'd0;
            done_test_ff <= 0;
            test_ind <= 8'd0;
        end else begin
            corr_res_ff <= corr_res_ff + corr_res;
            done_test_ff <= done_test;
            test_ind <= test_ind + test_ind_inc;
        end
    end

    // Assign output
    assign correct_pred = corr_res_ff;


    
    // VIO
    vio_test vio_NN(
        .clk                    (fast_clk),
        .probe_out0             (reset_test)
    );

    // ILA
    ila_test ila_NN(
        .clk                    (fast_clk),
        .probe0                 (done_test),
        .probe1                 (correct_pred),
        .probe2                 (test_ind),
        .probe3                 (digit_res)
    );

endmodule
