
module Adder_tb(
    input clk,
    input reset,
    input [7:0] seed,
    input [7:0] bin_num1,
    input [7:0] bin_num2,

    output [7:0] result_bin
    );

    // Stoch wires
    wire stoch_num1;
    wire stoch_num2;
    wire result_stoch;


    // SNGs
    StochNumGen SNG_num1 (
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd193),
        .prob               (bin_num1),
        .stoch_num          (stoch_num1)
    );
    StochNumGen SNG_num2 (
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd193),
        .prob               (bin_num2),
        .stoch_num          (stoch_num2)
    );

    // dut
    Adder adder(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd84),        // For select line SNG
        .stoch_num1         (stoch_num1),
        .stoch_num2         (stoch_num2),
        .result_stoch       (result_stoch)
    );

    //STBs
    wire [7:0] num1_stb_out;
    wire [7:0] num2_stb_out;

    // STB num1
    StochToBin stb_num1(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (stoch_num1),
        .bin_number         (num1_stb_out)
    );
    // STB num2
    StochToBin stb_num2(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (stoch_num2),
        .bin_number         (num2_stb_out)
    );
    // Result
    StochToBin stb_result(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (result_stoch),
        .bin_number         (result_bin)
    );


endmodule
