`timescale 1ns / 1ps


module MultBi_int16_tb();

    reg clk = 0;
    reg reset = 0;

    reg [15:0] test_vals [0:1] = '{32781, 32784};  // 0.0004, 0.0005

    reg [15:0] in_val;
    reg [15:0] out_val;

    MultBi_int16 mu_bin (
        .in_val             (in_val),
        .k                  (16'd2),
        .out_val            (out_val)
    );

    localparam NUM_TESTS = 2;

    // Run tests - total time = 39.33ms
    initial begin

        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Hold reset
            reset = 1;

            // Set inputs
            in_val = test_vals[i];

            #30;
            reset = 0;

            # 40;

            // print results
            $display("Test: %d, Result: %d", i+1, out_val);
        end
    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule
