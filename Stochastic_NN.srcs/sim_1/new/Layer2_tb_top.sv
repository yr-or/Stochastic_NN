`timescale 1ns / 1ps

// Simulation testbench for Layer2, writes outputs to file for verifying
module Layer2_tb_top();

    localparam NUM_NEUR = 32;
    localparam NUM_INPS = 196;
    localparam NUM_TESTS = 1;

    // regs
    reg clk = 0;
    reg reset = 0;

    // wires
    wire [15:0] results_bin          [0:NUM_NEUR-1];
    wire [15:0] macc_results_bin     [0:NUM_NEUR-1];
    wire done_stb;

    // Test input data - digit eight as bipolar binary
    logic [15:0] test_data_eight [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 34048, 43520, 46592, 40448, 33280, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44544, 65280, 61184, 60416, 57600, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 62464, 33536, 38144, 64000, 50176, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 64768, 51712, 63488, 64256, 47104, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 48896, 65280, 65280, 51200, 33792, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33792, 47616, 64256, 60160, 39680, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 34304, 57088, 65280, 62720, 53504, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50688, 55808, 40704, 57856, 53504, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35840, 64000, 43008, 38144, 65024, 46592, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 37888, 64512, 62464, 64256, 57344, 33280, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 41728, 49152, 46848, 34816, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };

    // LFSR seeds to test
    logic [15:0] LFSR_seeds [0:29] = '{24415, 1399, 39284, 23424, 3406, 56876, 65513, 4333, 57108, 46797, 43306, 33670, 63294, 25652, 24063, 26174, 25863, 5086, 8941, 56061, 19834, 55448, 34864, 32112, 53856, 32399, 46810, 22370, 9258, 10375 };
    logic [15:0] LFSR_seed;

    // Inst. Layer2
    Layer2_tb dut(
        .clk                (clk),
        .reset              (reset),
        .input_data_bin     (test_data_eight),
        //.LFSR_inp_seed      (LFSR_seed),

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
            //LFSR_seed = LFSR_seeds[i];

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 255 clock cycles
            //#5100;
            // Wait 65535 clk cycles
            #1310700;
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
