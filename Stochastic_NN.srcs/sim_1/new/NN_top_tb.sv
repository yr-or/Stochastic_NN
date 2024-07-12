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
    wire [15:0] L3_result_bin [0:9];
    wire done_stb;

    logic [3:0] digit_sel = 4'd8;


    // Inst. NN_top
    NN_top dut(
        .clk                (clk),
        .reset              (reset),
        .digit_sel          (digit_sel),

        .L3_res_bin         (L3_result_bin),
        .done               (done_stb)
    );

    initial begin
        reset = 1;
        #30;
        reset = 0;

        // Wait 65535 * 2 clk cycles = 2.63ms
        #1310700;
        #1310700;

    end


    // Clock gen
    always begin
        #10;
        clk = ~clk;
    end

endmodule
