`timescale 1ns / 1ps

// Testbench for Neuron196_L2, just applying test data, and writing output to file

module Neuron196_L2_tb_top();

    reg clk = 0;
    reg reset = 0;

    // Layer weights - weights for first neuron in L2
    reg [15:0] weights_bin [0:195] = '{ 35072, 32512, 33792, 37120, 38656, 43776, 40448, 34560, 23296, 32768, 41216, 36096, 35072, 31232, 33280, 35328, 24832, 33792, 33024, 35584, 32512, 33792, 26880, 25856, 32000, 39936, 39168, 31744, 29696, 31232, 39680, 36096, 38144, 27648, 27904, 27904, 31232, 40704, 38144, 36864, 22272, 26112, 35584, 31744, 35584, 35584, 33792, 37376, 32768, 20480, 39936, 45312, 37120, 36864, 25344, 28672, 43264, 29440, 34816, 32256, 39424, 35584, 28160, 19968, 49408, 41216, 34816, 32768, 23296, 11008, 41728, 37120, 26368, 32000, 35584, 35584, 17920, 26368, 44800, 37632, 35072, 35072, 23552, 17664, 40960, 31232, 28672, 35584, 37888, 30720, 19456, 28928, 38400, 29440, 28928, 35072, 41216, 29184, 37120, 30720, 33024, 41984, 36096, 28672, 26624, 28416, 33792, 24576, 30976, 38144, 35584, 32512, 32256, 21248, 32512, 34816, 37376, 28672, 26112, 29952, 30208, 32000, 34560, 34560, 36608, 38144, 39936, 31232, 24576, 32768, 39424, 38400, 29696, 27392, 34560, 33280, 40704, 36608, 33536, 25088, 34560, 34304, 32000, 33280, 38144, 44288, 33024, 29696, 32000, 33024, 36864, 34560, 31744, 40704, 33792, 22016, 38400, 41216, 39424, 38144, 33280, 31488, 33024, 29440, 33792, 29184, 21760, 29440, 33280, 31744, 41728, 39680, 33024, 30208, 34816, 27136, 33280, 17408, 22016, 22016, 24832, 32256, 35072, 25600, 24576, 33280, 34816, 31744, 31232, 31488, 34560, 36352, 26624, 40704, 27648, 30976 };
    
    // Bias value
    reg [15:0] bias_bin = 16'd32768;    // Values of bias for first neuron, scaled and in 16-bit

    // Outputs
    reg [15:0] mac_res_bin;
    reg [15:0] bias_out_bin;
    reg [15:0] neur_res_bin;
    reg done;
    // Debug outputs
    reg [15:0] add1_res_bin [0:97];
    reg [15:0] add2_res_bin [0:48];
    reg [15:0] add3_res_bin [0:23];
    reg [15:0] add4_res_bin [0:11];
    reg [15:0] add5_res_bin [0:5];
    reg [15:0] add6_res_bin [0:2];
    reg [15:0] add7_res_bin [0:1];


    Neuron196_L2_tb neur_tb(
        .clk                    (clk),
        .reset                  (reset),
        .digit_sel              (4'h8),
        .weights_bin            (weights_bin),
        .bias_bin               (bias_bin),

        .result_bin             (neur_res_bin), 
        .macc_result_bin        (mac_res_bin),
        .bias_out_bin           (bias_out_bin),
        .done                   (done),

        // Debug wires
        .add1_res_bin           (add1_res_bin),
        .add2_res_bin           (add2_res_bin),
        .add3_res_bin           (add3_res_bin),
        .add4_res_bin           (add4_res_bin),
        .add5_res_bin           (add5_res_bin),
        .add6_res_bin           (add6_res_bin),
        .add7_res_bin           (add7_res_bin)
    );  

    integer fd;  // file descriptor
    integer j = 0;
    localparam NUM_TESTS = 1;

    // Apply test data
    // Total time = 1310740 per test = 1.31ms
    initial begin
        fd = $fopen("Neur196_L2_test.txt", "w");

        // Run test 30 times with same data
        for (int i=0; i<NUM_TESTS; i=i+1) begin
            reset = 1;
            # 90;
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
