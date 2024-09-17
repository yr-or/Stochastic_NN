`timescale 1ns / 1ps

module NN_test_data_tb();

    // regs
    reg clk = 0;
    reg reset = 0;

    reg reset_test;
    wire done_test;
    wire [7:0] cor_pred;

    NN_test_data NN_test(
        .sys_clk                (clk),
        .reset_test             (reset_test)
    );

    // Apply test data in order, change LFSR seed each time to test
    initial begin
        reset_test = 1;
        # 50;
        reset_test = 0;
        
    end

    // Clock gen
    always begin
        #25;        // 20 MHz
        clk = ~clk;
    end

endmodule
