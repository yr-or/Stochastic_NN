`timescale 1ns / 1ps


module Max_Stoch_tb();


    reg clk = 0;
    reg reset = 0;

    reg [15:0] values_bin [0:9] = '{19403, 58492, 4835, 2839, 48395, 10375, 49384, 64403, 3823, 3849};
    wire stoch_nums [0:9];
    wire [3:0] max;

    // Generate stochastic numbers
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin
            StochNumGen16 SNG (
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd48364),
                .prob               (values_bin[i]),
                .stoch_num          (stoch_nums[i])
            );
        end
    endgenerate

    // Input to Max module
    Max_Stoch max_stoch (
        .clk                (clk),
        .reset              (reset),
        .L3_out_stoch       (stoch_nums),
        .max                (max)
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
