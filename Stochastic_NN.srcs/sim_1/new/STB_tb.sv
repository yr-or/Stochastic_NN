
module STB_tb();

    reg clk_tb = 1'b0;
    reg reset_tb = 1'b0;
    wire bit_stream_tb;
    wire [15:0] bin_number_tb;
    reg en_tb = 1;
    wire done_tb;

    StochToBin #(.BITSTR_LEN(2048)) stb (
        .clk                (clk_tb),
        .reset              (reset_tb),
        .enable             (en_tb),
        .bit_stream         (bit_stream_tb),
        .bin_number         (bin_number_tb),
        .done               (done_tb)
    );

    // Add SNG to test
    reg [7:0] num_tb = 8'b10000000;  // 0.5
    StochNumGen SNG1(
        .clk                (clk_tb),
        .reset              (reset_tb),
        .seed               (8'd173),
        .prob               (num_tb),
        .stoch_num          (bit_stream_tb)
    );

    // 40,990 ns = 40.99 us in total
    initial begin
        // Assert reset for 1 clk cycle + half clk at start
        reset_tb = 1;
        #30;
        reset_tb = 0;

        // Wait for 2048 clk cycles
        #40960;
    end

    always begin
        #10;
        clk_tb = ~clk_tb;
    end

endmodule
