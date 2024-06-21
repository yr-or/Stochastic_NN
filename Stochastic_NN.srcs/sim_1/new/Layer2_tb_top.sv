`timescale 1ns / 1ps

// Simulation testbench for Layer2, writes outputs to file for verifying
module Layer2_tb_top();

    localparam NUM_NEUR = 32;
    localparam NUM_INPS = 196;
    localparam NUM_TESTS = 30;

    // regs
    reg clk = 0;
    reg reset = 0;

    // wires
    wire [7:0] results_bin          [0:NUM_NEUR-1];
    wire [7:0] macc_results_bin     [0:NUM_NEUR-1];
    wire done_stb;

    // Test input data - digit zero as bipolar binary
    logic [7:0] input_data_bin [0:NUM_INPS-1] = '{ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 170, 243, 216, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 170, 251, 246, 231, 183, 128, 128, 128, 128, 128, 128, 128, 128, 185, 255, 229, 251, 180, 234, 128, 128, 128, 128, 128, 128, 128, 159, 250, 219, 139, 146, 128, 253, 155, 128, 128, 128, 128, 128, 136, 245, 175, 134, 128, 128, 128, 255, 177, 128, 128, 128, 128, 128, 193, 229, 128, 128, 128, 128, 128, 255, 171, 128, 128, 128, 128, 128, 212, 188, 128, 128, 128, 129, 194, 220, 130, 128, 128, 128, 128, 128, 213, 174, 128, 128, 142, 216, 202, 128, 128, 128, 128, 128, 128, 128, 212, 241, 193, 224, 244, 193, 135, 128, 128, 128, 128, 128, 128, 128, 160, 239, 255, 211, 146, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 };

    // LFSR seeds to test
    logic [7:0] LFSR_seeds [0:NUM_TESTS-1] = '{252, 56, 61, 19, 176, 65, 7, 219, 37, 127, 100, 241, 213, 10, 158, 38, 205, 69, 105, 27, 64, 42, 77, 175, 69, 109, 168, 217, 164, 150};
    logic [7:0] LFSR_seed;

    // Inst. NN_top
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
        fd = $fopen("Layer2_test.txt", "w");
        reset = 1;
        #10;

        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Set LFSR seed 
            reset = 1;
            LFSR_seed = LFSR_seeds[i];

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 256 clock cycles
            #5100;
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
