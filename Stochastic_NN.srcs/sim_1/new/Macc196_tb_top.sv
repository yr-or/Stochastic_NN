`timescale 1ns / 1ps

// Testbench for Macc196, check bipolar outputs
module Macc196_tb_top();

    reg clk = 0;
    reg reset = 0;

    // Test data - binary probabilities
    reg [15:0] input_values_bin [0:195] = '{ 59515, 31128, 8548, 34814, 61633, 14650, 64936, 51980, 32088, 23611, 23680, 24313, 64751, 18374, 64626, 14668, 51708, 27976, 49513, 31126, 41181, 20890, 29148, 22957, 16825, 17732, 18344, 56667, 3050, 61664, 9407, 32876, 25881, 406, 50196, 53347, 44660, 52504, 15807, 61648, 31807, 45253, 148, 54800, 29782, 51418, 20423, 63867, 24468, 50360, 62976, 6943, 22109, 23804, 50049, 14525, 52506, 44163, 58966, 58079, 32206, 19649, 53951, 18782, 20237, 56134, 31871, 54746, 46385, 48314, 5580, 52057, 55472, 13286, 31517, 11490, 7624, 58271, 3806, 36172, 20068, 43934, 46255, 9652, 53548, 65343, 50007, 52365, 48693, 30741, 13814, 59189, 16257, 29561, 31560, 35384, 3889, 20401, 42976, 2537, 64958, 34691, 5501, 59066, 37999, 61945, 38791, 60705, 1781, 2291, 62318, 22025, 58049, 63456, 8069, 62182, 51652, 58257, 33478, 62158, 16689, 23740, 20036, 5003, 8104, 43923, 3681, 24988, 34726, 62561, 6889, 48333, 20090, 12613, 54109, 55823, 22780, 6863, 55456, 46549, 33537, 45063, 3169, 5545, 7890, 61168, 20231, 48828, 20654, 7356, 26520, 14187, 32535, 31732, 30124, 9943, 5179, 10938, 15237, 45288, 55386, 32326, 36931, 8411, 51735, 11281, 36151, 17660, 24974, 58110, 49287, 32634, 12267, 4160, 58354, 19773, 44279, 35388, 40160, 34391, 49639, 13463, 49248, 32644, 13204, 57487, 23845, 25618, 4087, 274, 34243, 15302, 23851, 45613, 29916, 31099 };
    reg [15:0] weights_bin      [0:195] = '{ 22579, 55996, 65178, 52645, 15405, 45988, 31397, 32579, 63674, 27088, 15268, 64213, 18289, 56015, 38928, 7484, 45454, 45673, 18203, 25351, 25587, 14279, 60876, 26690, 35646, 8347, 59600, 57946, 39831, 61489, 33300, 23032, 15764, 59522, 41830, 40801, 56954, 1709, 44006, 32395, 25698, 30567, 20623, 8462, 41657, 27721, 59416, 36165, 10265, 2221, 60376, 53477, 44133, 51598, 8481, 44603, 15684, 171, 37971, 23355, 10642, 20824, 32404, 19401, 11115, 14977, 52221, 34168, 12823, 51260, 30489, 58796, 56481, 42314, 2371, 41874, 19382, 61376, 13592, 24876, 60805, 45436, 36024, 5986, 41631, 51704, 21305, 51708, 19335, 17425, 59894, 53442, 4441, 18411, 49397, 10749, 5340, 50424, 32937, 24968, 22983, 63818, 12816, 47003, 32124, 9153, 24462, 62113, 13575, 55519, 64607, 44395, 32984, 52373, 19803, 23554, 51036, 57465, 593, 24236, 62994, 41703, 18788, 9167, 23118, 55030, 33812, 57382, 51338, 47755, 42018, 3657, 33158, 25557, 15257, 38799, 55889, 46289, 55349, 17991, 52664, 28043, 58973, 52253, 45612, 25130, 61708, 55499, 5929, 18640, 16734, 4003, 37429, 746, 47356, 44142, 33341, 21718, 1265, 5538, 13272, 43250, 12612, 30171, 32964, 56153, 32526, 54296, 49106, 15009, 7028, 60778, 34584, 26863, 62072, 50556, 34003, 45239, 31501, 53983, 55335, 39423, 61848, 53184, 17957, 31471, 17794, 59416, 13931, 18707, 32573, 10804, 20451, 61325, 62147, 3311 };

    // Outputs
    reg [15:0] mac_res_bin;
    reg done;

    // Debug outputs
    reg [15:0] add1_res_bin [0:97];
    reg [15:0] add2_res_bin [0:48];
    reg [15:0] add3_res_bin [0:23];
    reg [15:0] add4_res_bin [0:11];
    reg [15:0] add5_res_bin [0:5];
    reg [15:0] add6_res_bin [0:2];
    reg [15:0] add7_res_bin [0:1];

    Macc196_tb macc_tb(
        .clk                (clk),
        .reset              (reset),
        .input_values       (input_values_bin),
        .weights            (weights_bin),

        .mac_res_bin        (mac_res_bin),
        .done               (done),
        // debug
        .add1_res_bin           (add1_res_bin),
        .add2_res_bin           (add2_res_bin),
        .add3_res_bin           (add3_res_bin),
        .add4_res_bin           (add4_res_bin),
        .add5_res_bin           (add5_res_bin),
        .add6_res_bin           (add6_res_bin),
        .add7_res_bin           (add7_res_bin)
    );  

    integer fd;  // file descriptor
    localparam NUM_TESTS = 1;
    integer j = 0;

    // Apply test data
    initial begin
        fd = $fopen("C:/Users/Rory/Documents/HDL/Stochastic_NN/Outputs/Test_mac_rand_vals/Macc196_test_rtlfix_1.txt", "w");

        // Run test 30 times with same data
        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Set inputs
            reset = 1;
            #30;
            reset = 0;
            reset = 0;

                        // Wait 65535 clock cycles
            #1310700;

            // Adder stages
            $fwrite(fd, "Add1_out: ");
            for (j=0; j<98; j=j+1) begin
                $fwrite(fd, "%d, ", add1_res_bin[j]);
            end
            $fwrite(fd, "\nAdd2_out: ");
            for (j=0; j<49; j=j+1) begin
                $fwrite(fd, "%d, ", add2_res_bin[j]);
            end
            $fwrite(fd, "\nAdd3_out: ");
            for (j=0; j<24; j=j+1) begin
                $fwrite(fd, "%d, ", add3_res_bin[j]);
            end
            $fwrite(fd, "\nAdd4_out: ");
            for (j=0; j<12; j=j+1) begin
                $fwrite(fd, "%d, ", add4_res_bin[j]);
            end
            $fwrite(fd, "\nAdd5_out: ");
            for (j=0; j<6; j=j+1) begin
                $fwrite(fd, "%d, ", add5_res_bin[j]);
            end
            $fwrite(fd, "\nAdd6_out: ");
            for (j=0; j<3; j=j+1) begin
                $fwrite(fd, "%d, ", add6_res_bin[j]);
            end
            $fwrite(fd, "\nAdd7_out: ");
            for (j=0; j<2; j=j+1) begin
                $fwrite(fd, "%d, ", add7_res_bin[j]);
            end

            $fwrite(fd, "Macc_out: %d, ", mac_res_bin);
        end
        $fclose(fd);
    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule
