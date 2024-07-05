`timescale 1ns / 1ps

// Simulation testbench for Layer2, writes outputs to file for verifying
module Layer2_tb_top();

    localparam NUM_NEUR = 32;
    localparam NUM_INPS = 196;
    localparam NUM_TESTS = 2;

    // regs
    reg clk = 0;
    reg reset = 0;

    // wires
    wire [15:0] results_bin          [0:NUM_NEUR-1];
    wire [15:0] macc_results_bin     [0:NUM_NEUR-1];
    wire done_stb;

    // Test input data - digit eight as bipolar binary
    logic [7:0] input_data_bin [0:NUM_INPS-1] = '{ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 133, 170, 182, 158, 130, 128, 128, 128, 128, 128, 128, 128, 128, 128, 174, 255, 239, 236, 225, 128, 128, 128, 128, 128, 128, 128, 128, 128, 185, 244, 131, 149, 250, 196, 128, 128, 128, 128, 128, 128, 128, 128, 185, 253, 202, 248, 251, 184, 128, 128, 128, 128, 128, 128, 128, 128, 191, 255, 255, 200, 132, 128, 128, 128, 128, 128, 128, 128, 132, 186, 251, 235, 155, 128, 128, 128, 128, 128, 128, 128, 128, 134, 223, 255, 245, 209, 128, 128, 128, 128, 128, 128, 128, 128, 128, 198, 218, 159, 226, 209, 128, 128, 128, 128, 128, 128, 128, 128, 140, 250, 168, 149, 254, 182, 128, 128, 128, 128, 128, 128, 128, 128, 148, 252, 244, 251, 224, 130, 128, 128, 128, 128, 128, 128, 128, 128, 128, 163, 192, 183, 136, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 };

    // LFSR seeds to test
    logic [7:0] LFSR_seeds [0:29] = '{252, 56, 61, 19, 176, 65, 7, 219, 37, 127, 100, 241, 213, 10, 158, 38, 205, 69, 105, 27, 64, 42, 77, 175, 69, 109, 168, 217, 164, 150};
    logic [7:0] LFSR_seed;

    // Inst. Layer2
    Layer2_tb dut(
        .clk                (clk),
        .reset              (reset),
        .input_data_bin     (input_data_bin),
        .LFSR_inp_seed      (LFSR_seed),

        .results_bin        (results_bin),
        .macc_results_bin   (macc_results_bin),
        .done               (done_stb)
    );

    integer fd; // file object

    // Apply test data in order, change LFSR seed each time to test
    initial begin
        fd = $fopen("C:\Users\Rory\Documents\HDL\Stochastic_NN\Outputs\Layer2_test.txt", "w");
        reset = 1;
        #10;

        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Set LFSR seed 
            reset = 1;
            LFSR_seed = LFSR_seeds[i];

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 255 clock cycles
            //#5100;
            // Wait 2047 clk cycles
            #40940;
            // print results
            $display("Test: %d", i+1);
            $fdisplay(fd, "Test: %d", i+1);
            $write("L2_out: ");
            $fwrite(fd, "L2_out: ");
            for (int j=0; j<NUM_NEUR; j=j+1) begin
                $write("%d, ", results_bin[j]);
                $fwrite(fd, "%d, ", results_bin[j]);
            end
            $write("\nL2_macc_out: ");
            $fwrite(fd, "\nL2_macc_out: ");
            for (int j=0; j<NUM_NEUR; j=j+1) begin
                $write("%d, ", macc_results_bin[j]);
                $fwrite(fd, "%d, ", macc_results_bin[j]);
            end
            $write("\n");
            $fwrite(fd, "\n");
        end
        $fclose(fd);
    end

    // Clock gen
    always begin
        #10;
        clk = ~clk;
    end


endmodule
