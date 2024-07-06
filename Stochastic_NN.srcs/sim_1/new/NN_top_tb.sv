`timescale 1ns / 1ps

// Test different input digits into network
// NN dut takes binary values and outputs binary value
// Testing mathodology:
//     1) Running tests for different LFSR seeds but same digit
//     2) Running tests with different input digits but same seeds

module NN_top_tb();

    localparam NUM_INPS = 196;
    localparam NUM_TESTS = 10;

    // regs
    reg clk = 0;
    reg reset = 0;

    // wires
    wire [3:0] result_bin;
    wire done_stb;

    logic [4:0] digit_sel = 5'd8;

    // LFSR seeds or input SNGs
    logic [7:0] LFSR_seeds [0:29] = '{252, 56, 61, 19, 176, 65, 7, 219, 37, 127, 100, 241, 213, 10, 158, 38, 205, 69, 105, 27, 64, 42, 77, 175, 69, 109, 168, 217, 164, 150};
    logic [7:0] LFSR_seed;

    // Inst. NN_top
    NN_top dut(
        .clk                (clk),
        .reset              (reset),
        .digit_sel          (digit_sel),
        //.LFSR_inp_seed      (LFSR_seed),

        .result_bin         (result_bin),
        .done               (done_stb)
    );

    integer fd; // file object

    /* 8-BIT TEST
    // Apply test data in order, change LFSR seed each time to test
    // Total time = 41200*NUM_TESTS + 10 = ~41us
    initial begin
        fd = $fopen("NN_test.txt", "w");
        reset = 1;
        #10;

        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Set LFSR seed 
            reset = 1;
            LFSR_seed = LFSR_seeds[i];

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 256 clock cycles + 10 clk cycles for max module
            //#5100;
            //#200;

            // Wait 2048 clk cycles + 10 for max module
            #40960;
            #200;

            // print results
            $display("Test: %d", i+1);
            $fdisplay(fd, "Test: %d", i+1);

            $write("Result: %d", result_bin);
            $fwrite(fd, "Result: %d", result_bin);

            $write("\n");
            $fwrite(fd, "\n");
        end
        $fclose(fd);
    end
    */

    initial begin
        reset = 1;
        #30;
        reset = 0;

        // Wait 2047 clock cycles
        #40940;

        // +Wait 10 clk cycles for max module
        #200;

        // Write output
        $write("Max val: %d", result_bin);

    end


    // Clock gen
    always begin
        #10;
        clk = ~clk;
    end

endmodule
