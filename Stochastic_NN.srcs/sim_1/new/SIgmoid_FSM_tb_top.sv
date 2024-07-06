`timescale 1ns / 1ps

module Sigmoid_FSM_tb_top();

    reg clk = 0;
    reg reset = 0;
    // Inputs and outputs to DUT
    reg [15:0] inp_prob;
    wire [15:0] out_prob;

    // FSM DUT
    Sigmoid_FSM_tb FSM_tb(
        .clk                (clk),
        .reset              (reset),
        .inp_prob           (inp_prob),
        .seed               (16'd28394),
        .out_prob           (out_prob)
    );

    // Test data
    reg [15:0] test_data [0:99] = '{ 5392, 52451, 39606, 24807, 6628, 2935, 33107, 25290, 35582, 1063, 49745, 23005, 22329, 6659, 54879, 19303, 29630, 16870, 23554, 23905, 5780, 32852, 378, 33867, 42236, 30373, 61828, 16103, 26779, 30946, 45399, 23937, 4878, 54233, 41956, 13096, 45409, 34022, 19452, 5845, 60010, 43098, 29742, 41623, 22188, 32549, 51807, 63200, 15797, 57501, 30314, 14880, 10712, 52943, 11395, 22995, 11700, 16894, 55875, 55566, 56298, 54729, 13368, 24682, 51390, 47001, 6590, 50869, 22922, 47707, 38124, 60847, 24289, 31777, 2366, 32655, 59075, 57306, 11767, 29749, 7994, 43845, 2225, 36540, 64120, 5591, 10132, 7529, 63188, 11, 6409, 8673, 27967, 21641, 7226, 26340, 50428, 32771, 62908, 31892 };

    integer fd;     // File descriptor

    // Input test data
    initial begin
        fd = $fopen("sigmoid_data.txt", "w");
        reset = 1;
        #10;

        for (int i=0; i<100; i=i+1) begin
            // Set inputs
            reset = 1;
            inp_prob = test_data[i];

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 2047
            #40940;
            $fdisplay(fd, "Input: %d, Output: %d", inp_prob, out_prob);
        end
        $fclose(fd);
    end

    // Clock gen
    always begin
        #10;
        clk = ~clk;
    end

endmodule
