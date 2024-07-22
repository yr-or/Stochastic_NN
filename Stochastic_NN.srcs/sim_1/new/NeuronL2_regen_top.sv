`timescale 1ns / 1ps

// Testbench for Macc196, check bipolar outputs
module NeuronL2_regen_top();

    reg clk = 0;
    reg reset = 0;

    // Debug outputs
    reg [15:0] add1_res_bin [0:97];
    reg [15:0] add2_res_bin [0:48];
    reg [15:0] add3_res_bin [0:23];
    reg [15:0] add4_res_bin [0:11];
    reg [15:0] add5_res_bin [0:5];
    reg [15:0] add6_res_bin [0:2];
    reg [15:0] add7_res_bin [0:1];

    NeuronL2_regen_tb dut(
        .clk                    (clk),
        .reset                  (reset),
        .digit_sel              (4'h8),

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
        fd = $fopen("C:/Users/Rory/Documents/HDL/Stochastic_NN/Outputs/Test_neur_regen/NeuronL2_regen_digit8_test1.txt", "w");

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

        end
        $fclose(fd);
    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule
