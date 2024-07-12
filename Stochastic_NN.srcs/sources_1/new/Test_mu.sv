// Test stochastic multiply with different bitstream lengths

module Test_mu(
    input clk,
    input reset,
    input [15:0] num1_bin,
    input [15:0] num2_bin,

    output mul_res_256bit,
    output mul_res_512bit,
    output mul_res_1024bit,
    output mul_res_2048bit,
    output mul_res_4096bit
    );

    // Stoch outputs
    wire num1_stoch;
    wire num2_stoch;
    wire res_stoch;

    // Binary outputs
    wire [7:0] mul_res_256bit;
    wire [8:0] mul_res_512bit;
    wire [9:0] mul_res_1024bit;
    wire [10:0] mul_res_2048bit;
    wire [11:0] mul_res_4096bit;

    // Control signals
    wire done_stb256;
    wire done_stb512;
    wire done_stb1024;
    wire done_stb2048;
    wire done_stb4096;


    // SNGs
    StochNumGen16 SNG1(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd38493),
        .prob               (num1_bin),
        .stoch_num          (num1_stoch)
    );
    StochNumGen16 SNG2(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd59403),
        .prob               (num2_bin),
        .stoch_num          (num2_stoch)
    );

    // Mul
    Mult_bi mu(
        .stoch_num1         (num1_stoch),
        .stoch_num2         (num2_stoch),
        .stoch_res          (res_stoch)
    );

    // STBs
    // 256-bit
    StochToBin #(.BITSTR_LEN(256)) STB1(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (res_stoch),
        .bin_number         (mul_res_256bit),
        .done               (done_stb256)
    );
    // 512-bit
    StochToBin #(.BITSTR_LEN(512)) STB2(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (res_stoch),
        .bin_number         (mul_res_512bit),
        .done               (done_stb512)
    );
    // 1024-bit
    StochToBin #(.BITSTR_LEN(1024)) STB3(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (res_stoch),
        .bin_number         (mul_res_1024bit),
        .done               (done_stb1024)
    );
    // 2048-bit
    StochToBin #(.BITSTR_LEN(2048)) STB4(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (res_stoch),
        .bin_number         (mul_res_2048bit),
        .done               (done_stb2048)
    );
    // 4096-bit
    StochToBin #(.BITSTR_LEN(4096)) STB5(
        .clk                (clk),
        .reset              (reset),
        .enable             (1'b1),
        .bit_stream         (res_stoch),
        .bin_number         (mul_res_4096bit),
        .done               (done_stb4096)
    );
    


endmodule
