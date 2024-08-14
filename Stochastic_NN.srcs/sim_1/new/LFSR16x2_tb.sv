`timescale 1ns / 1ps


module LFSR16x2_tb();

    reg clk = 0;
    reg reset = 0;

    reg [15:0] rand_nums [0:3];

    LFSR16x4 lfsr_block(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'ha5),
        .parallel_out       (rand_nums)
    );

    initial begin
        reset = 1;
        #30;
        reset = 0;
    end

    always begin
        #10;
        clk = ~clk;
    end


endmodule
