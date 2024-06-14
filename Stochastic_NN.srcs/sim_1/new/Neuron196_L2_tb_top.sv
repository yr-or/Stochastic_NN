`timescale 1ns / 1ps

// Testbench for Neuron196_L2, just applying test data, and writing output to file

module Neuron196_L2_tb_top();

    reg clk = 0;
    reg reset = 0;

    localparam NUM_TESTS = 30;

    // Test data - binary probabilities
    reg [7:0] input_values_bin [0:195] = '{ 184, 205, 19, 47, 138, 44, 137, 202, 48, 34, 248, 143, 223, 160, 166, 154, 86, 202, 175, 72, 184, 91, 202, 224, 166, 196, 4, 136, 143, 195, 63, 146, 131, 51, 200, 33, 19, 100, 28, 35, 228, 166, 165, 136, 44, 125, 76, 25, 176, 88, 56, 228, 204, 149, 149, 120, 253, 42, 240, 30, 48, 185, 55, 5, 177, 229, 159, 206, 160, 87, 129, 169, 187, 148, 142, 106, 166, 78, 218, 166, 212, 193, 15, 111, 6, 30, 68, 184, 78, 139, 59, 88, 16, 123, 92, 70, 13, 229, 25, 199, 156, 98, 198, 106, 153, 250, 179, 37, 106, 238, 50, 12, 27, 118, 179, 190, 255, 65, 97, 51, 252, 195, 15, 2, 210, 62, 88, 6, 102, 152, 209, 154, 117, 208, 150, 73, 6, 214, 15, 162, 237, 75, 159, 26, 37, 253, 78, 45, 210, 156, 159, 25, 54, 74, 50, 76, 36, 12, 117, 43, 8, 83, 136, 206, 48, 205, 214, 40, 173, 130, 151, 54, 197, 178, 41, 194, 178, 211, 106, 197, 223, 12, 194, 12, 96, 16, 93, 233, 46, 63, 159, 216, 31, 10, 28, 58 };
    reg [7:0] weights_bin [0:195] = '{ 65, 19, 188, 71, 161, 31, 88, 23, 2, 49, 112, 219, 133, 131, 60, 138, 87, 142, 14, 51, 85, 244, 42, 85, 219, 103, 214, 35, 144, 54, 170, 4, 136, 65, 31, 12, 196, 149, 76, 174, 104, 108, 10, 147, 201, 76, 93, 34, 145, 22, 165, 251, 143, 48, 202, 13, 50, 31, 253, 134, 123, 55, 52, 76, 202, 1, 42, 245, 62, 54, 94, 243, 58, 105, 12, 152, 151, 11, 224, 68, 85, 144, 185, 14, 87, 163, 121, 52, 26, 75, 71, 192, 34, 82, 109, 7, 69, 108, 198, 247, 156, 169, 250, 211, 253, 172, 102, 196, 9, 228, 198, 226, 206, 182, 63, 58, 65, 234, 221, 145, 214, 18, 120, 116, 203, 119, 205, 128, 183, 219, 58, 50, 93, 64, 214, 166, 34, 206, 146, 97, 209, 40, 253, 63, 5, 175, 205, 89, 228, 156, 62, 96, 35, 43, 79, 27, 130, 233, 40, 126, 198, 56, 195, 22, 30, 85, 137, 159, 207, 197, 152, 42, 85, 6, 205, 28, 35, 229, 117, 212, 111, 43, 217, 83, 176, 230, 66, 198, 120, 62, 84, 144, 45, 206, 254, 137 };
    reg [7:0] bias_bin = 8'd130;    // Keep small number to test

    // LFSR values for SNGs
    reg [7:0] LFSR1_seeds [0:NUM_TESTS-1] = '{252, 56, 61, 19, 176, 65, 7, 219, 37, 127, 100, 241, 213, 10, 158, 38, 205, 69, 105, 27, 64, 42, 77, 175, 69, 109, 168, 217, 164, 150};
    reg [7:0] LFSR2_seeds [0:NUM_TESTS-1] = '{245, 215, 18, 41, 106, 93, 188, 136, 141, 147, 165, 209, 235, 102, 1, 202, 217, 77, 119, 85, 15, 141, 115, 215, 196, 156, 15, 224, 12, 167};
    reg [7:0] LFSR1_seed;
    reg [7:0] LFSR2_seed;

    // Outputs
    reg [7:0] mac_res_bin;
    reg [7:0] bias_out_bin;
    reg [7:0] neur_res_bin;
    reg done;

    Neuron196_L2_tb neur_tb(
        .clk                    (clk),
        .reset                  (reset),
        .input_data_bin         (input_values_bin),
        .weights_bin            (weights_bin),
        .bias_bin               (bias_bin),
        .LFSR1_seed             (LFSR1_seed),
        .LFSR2_seed             (LFSR2_seed),

        .result_bin             (neur_res_bin),
        .macc_result_bin        (mac_res_bin),
        .bias_out_bin           (bias_out_bin),
        .done                   (done)
    );  

    integer fd;  // file descriptor

    // Apply test data
    initial begin
        fd = $fopen("Neur196_L2_test.txt", "w");
        reset = 1;
        #10;

        // Run test 30 times with same data
        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Set inputs
            reset = 1;
            LFSR1_seed = LFSR1_seeds[i];
            LFSR2_seed = LFSR2_seeds[i];

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 256 clock cycles
            #5100;
            $fwrite(fd, "Test: %d, ", i+1);
            $fwrite(fd, "Macc_out: %d, ", mac_res_bin);
            $fwrite(fd, "Bias_out: %d, ", bias_out_bin);
            $fwrite(fd, "Neur_out: %d\n", neur_res_bin);
        end
        $fclose(fd);
    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule
