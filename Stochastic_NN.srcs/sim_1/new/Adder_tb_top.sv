`timescale 1ns / 1ps


module Adder_tb_top();

    localparam NUM_TESTS = 30;

    reg clk = 0;
    reg reset = 0;

    reg [7:0] bin_num1 = 8'd42;
    reg [7:0] bin_num2 = 8'd12;

    wire [7:0] result_bin;


    Adder_tb dut(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd84),        // For select line SNG
        .bin_num1           (bin_num1),
        .bin_num2           (bin_num2),
        .result_bin         (result_bin)
    );

    // Apply test data
    initial begin
        reset = 1;
        #10;

        // Run test 30 times with same data
        for (int i=0; i<NUM_TESTS; i=i+1) begin
            // Set inputs
            reset = 1;

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 255 clock cycles
            #5100;
        end
    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule
